# -*- coding: utf-8 -*-
"""Chatbot Controller - Architecture MVC"""
from flask import Blueprint, request, jsonify, current_app, Response
from flask_login import login_required, current_user
from app.models import db, ChatbotConversation, ChatbotMessage
import sys
import os

# Ajouter le répertoire parent au path pour importer ollama_client
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(__file__))))
from ollama_client import OllamaClient

chatbot_bp = Blueprint('chatbot', __name__, url_prefix='/api/chat')


@chatbot_bp.route('', methods=['POST'])
@login_required
def chat():
    """
    Endpoint pour discuter avec ShadyGPT
    Accepte un JSON avec:
    - message: le message de l'utilisateur
    - conversation_id: (optionnel) ID de conversation existante
    - context: (optionnel) contexte des questions en cours pour réponse contextuelle
    """
    data = request.get_json()
    user_message = data.get('message', '')
    conversation_id = data.get('conversation_id')
    context = data.get('context', {})  # {'theme': 'Océans', 'question_text': '...'}

    if not user_message:
        return jsonify({'error': 'Message requis'}), 400

    # Récupérer ou créer une conversation
    if conversation_id:
        conversation = ChatbotConversation.query.get(conversation_id)
        if not conversation or conversation.user_id != current_user.id:
            return jsonify({'error': 'Conversation invalide'}), 404
    else:
        # Nouvelle conversation
        conversation = ChatbotConversation(
            user_id=current_user.id,
            title=user_message[:50]  # Utiliser le premier message comme titre
        )
        db.session.add(conversation)
        db.session.flush()

    # Sauvegarder le message utilisateur
    user_msg = ChatbotMessage(
        conversation_id=conversation.id,
        role='user',
        content=user_message
    )
    db.session.add(user_msg)
    db.session.commit()

    # Préparer le contexte pour Ollama
    ollama_client = OllamaClient(base_url=current_app.config['OLLAMA_BASE_URL'])
    model = current_app.config['OLLAMA_MODEL']

    # Construire l'historique des messages
    messages = []

    # Ajouter un message système avec le contexte si fourni
    if context:
        system_prompt = "Tu es ShadyGPT, un assistant IA pour aider les utilisateurs pendant un quiz sur les océans et l'open source."

        if context.get('theme'):
            system_prompt += f"\n\nContexte actuel: L'utilisateur répond à des questions sur le thème '{context['theme']}'."

        if context.get('question_text'):
            system_prompt += f"\n\nQuestion en cours: {context['question_text']}"

        messages.append({
            'role': 'system',
            'content': system_prompt
        })

    # Ajouter l'historique de conversation (les 10 derniers messages)
    history = ChatbotMessage.query.filter_by(
        conversation_id=conversation.id
    ).order_by(ChatbotMessage.created_at.desc()).limit(10).all()

    for msg in reversed(history[:-1]):  # Exclure le dernier (c'est le message actuel)
        messages.append({
            'role': msg.role,
            'content': msg.content
        })

    # Ajouter le message actuel
    messages.append({
        'role': 'user',
        'content': user_message
    })

    try:
        # Appeler Ollama
        response = ollama_client.chat(model, messages, stream=False)
        assistant_message = response['message']['content']

        # Sauvegarder la réponse
        assistant_msg = ChatbotMessage(
            conversation_id=conversation.id,
            role='assistant',
            content=assistant_message
        )
        db.session.add(assistant_msg)
        db.session.commit()

        return jsonify({
            'success': True,
            'message': assistant_message,
            'conversation_id': str(conversation.id)
        })

    except Exception as e:
        return jsonify({
            'error': f'Erreur lors de la communication avec ShadyGPT: {str(e)}'
        }), 500


@chatbot_bp.route('/stream', methods=['POST'])
@login_required
def chat_stream():
    """Version streaming du chatbot (pour réponses en temps réel)"""
    data = request.get_json()
    user_message = data.get('message', '')
    conversation_id = data.get('conversation_id')
    context = data.get('context', {})

    if not user_message:
        return jsonify({'error': 'Message requis'}), 400

    # Même logique que chat() mais avec streaming
    if conversation_id:
        conversation = ChatbotConversation.query.get(conversation_id)
        if not conversation or conversation.user_id != current_user.id:
            return jsonify({'error': 'Conversation invalide'}), 404
    else:
        conversation = ChatbotConversation(
            user_id=current_user.id,
            title=user_message[:50]
        )
        db.session.add(conversation)
        db.session.flush()

    user_msg = ChatbotMessage(
        conversation_id=conversation.id,
        role='user',
        content=user_message
    )
    db.session.add(user_msg)
    db.session.commit()

    ollama_client = OllamaClient(base_url=current_app.config['OLLAMA_BASE_URL'])
    model = current_app.config['OLLAMA_MODEL']

    # Construire messages (même logique)
    messages = []

    if context:
        system_prompt = "Tu es ShadyGPT, un assistant IA pour aider les utilisateurs pendant un quiz."
        if context.get('theme'):
            system_prompt += f"\n\nThème: {context['theme']}"
        if context.get('question_text'):
            system_prompt += f"\nQuestion: {context['question_text']}"

        messages.append({'role': 'system', 'content': system_prompt})

    messages.append({'role': 'user', 'content': user_message})

    def generate():
        """Générateur pour le streaming SSE"""
        full_response = ""
        try:
            for chunk in ollama_client.chat(model, messages, stream=True):
                if 'message' in chunk and 'content' in chunk['message']:
                    token = chunk['message']['content']
                    full_response += token
                    yield f"data: {token}\n\n"

            # Sauvegarder la réponse complète
            assistant_msg = ChatbotMessage(
                conversation_id=conversation.id,
                role='assistant',
                content=full_response
            )
            db.session.add(assistant_msg)
            db.session.commit()

            yield f"data: [DONE]\n\n"

        except Exception as e:
            yield f"data: [ERROR] {str(e)}\n\n"

    return Response(generate(), mimetype='text/event-stream')
