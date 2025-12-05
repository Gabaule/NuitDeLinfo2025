"""Routes pour le système de QCM"""
from flask import Blueprint, render_template, request, redirect, url_for, flash, jsonify
from flask_login import login_required, current_user
from app.models import db, Question, QcmSession, QcmSessionQuestion, UserAnswer, QuestionChoice
import random
from datetime import datetime

bp = Blueprint('qcm', __name__, url_prefix='/qcm')


@bp.route('/')
@login_required
def select_difficulty():
    """Page de sélection de la difficulté"""
    return render_template('qcm_select.html')


@bp.route('/<difficulty>/start')
@login_required
def start_quiz(difficulty):
    """Démarrer un nouveau quiz avec une difficulté donnée"""
    if difficulty not in ['facile', 'moyen', 'difficile']:
        flash('Difficulté invalide', 'danger')
        return redirect(url_for('qcm.select_difficulty'))

    # Récupérer 30 questions aléatoires de cette difficulté
    questions = Question.query.filter_by(difficulty=difficulty).all()

    if len(questions) < 30:
        flash(f'Pas assez de questions disponibles pour le niveau {difficulty}', 'warning')
        return redirect(url_for('qcm.select_difficulty'))

    # Sélection aléatoire de 30 questions
    selected_questions = random.sample(questions, 30)

    # Créer une nouvelle session
    session = QcmSession(
        user_id=current_user.id,
        difficulty=difficulty,
        total_score=0,
        max_possible_score=30,
        is_completed=False
    )
    db.session.add(session)
    db.session.flush()  # Pour obtenir l'ID de la session

    # Ajouter les questions à la session
    for i, question in enumerate(selected_questions, start=1):
        session_question = QcmSessionQuestion(
            session_id=session.id,
            question_id=question.id,
            question_order=i,
            question_score=0
        )
        db.session.add(session_question)

    db.session.commit()

    return redirect(url_for('qcm.question', session_id=session.id, num=1))


@bp.route('/<uuid:session_id>/question/<int:num>')
@login_required
def question(session_id, num):
    """Afficher une question spécifique"""
    session = QcmSession.query.get_or_404(session_id)

    # Vérifier que c'est bien la session de l'utilisateur
    if session.user_id != current_user.id:
        flash('Session invalide', 'danger')
        return redirect(url_for('qcm.select_difficulty'))

    if num < 1 or num > 30:
        flash('Numéro de question invalide', 'danger')
        return redirect(url_for('qcm.question', session_id=session_id, num=1))

    # Récupérer la question
    session_question = QcmSessionQuestion.query.filter_by(
        session_id=session_id,
        question_order=num
    ).first_or_404()

    question_data = session_question.question

    # Récupérer la réponse existante si elle existe
    existing_answer = UserAnswer.query.filter_by(
        session_question_id=session_question.id
    ).first()

    return render_template('qcm.html',
                           session=session,
                           session_question=session_question,
                           question=question_data,
                           question_num=num,
                           existing_answer=existing_answer)


@bp.route('/<uuid:session_id>/answer', methods=['POST'])
@login_required
def submit_answer(session_id):
    """Enregistrer une réponse"""
    session = QcmSession.query.get_or_404(session_id)

    if session.user_id != current_user.id:
        return jsonify({'error': 'Unauthorized'}), 403

    data = request.get_json()
    question_num = data.get('question_num')
    answer_data = data.get('answer')

    session_question = QcmSessionQuestion.query.filter_by(
        session_id=session_id,
        question_order=question_num
    ).first_or_404()

    # Supprimer l'ancienne réponse si elle existe
    UserAnswer.query.filter_by(session_question_id=session_question.id).delete()

    # Enregistrer la nouvelle réponse
    question = session_question.question

    if question.question_type == 'multiple_choice':
        # Réponse à choix multiple
        choice_ids = answer_data if isinstance(answer_data, list) else [answer_data]

        score = 0
        for choice_id in choice_ids:
            choice = QuestionChoice.query.get(choice_id)
            is_correct = choice.is_correct if choice else False

            answer = UserAnswer(
                session_question_id=session_question.id,
                choice_id=choice_id,
                is_correct=is_correct
            )
            db.session.add(answer)

            if is_correct:
                score += 1
            else:
                score -= 1

        session_question.question_score = max(0, score)  # Score minimum 0

    else:
        # Réponse texte
        text_answer = answer_data
        # Comparaison simple (à améliorer)
        is_correct = text_answer.strip().lower() == question.text_answer.correct_answer.strip().lower()

        answer = UserAnswer(
            session_question_id=session_question.id,
            text_answer=text_answer,
            is_correct=is_correct
        )
        db.session.add(answer)

        session_question.question_score = 1 if is_correct else 0

    db.session.commit()

    return jsonify({'success': True, 'score': session_question.question_score})


@bp.route('/<uuid:session_id>/complete')
@login_required
def complete_quiz(session_id):
    """Terminer le quiz et calculer le score final"""
    session = QcmSession.query.get_or_404(session_id)

    if session.user_id != current_user.id:
        flash('Session invalide', 'danger')
        return redirect(url_for('qcm.select_difficulty'))

    # Calculer le score total
    total_score = sum(sq.question_score for sq in session.session_questions)

    session.total_score = total_score
    session.is_completed = True
    session.completed_at = datetime.utcnow()

    db.session.commit()

    return redirect(url_for('qcm.results', session_id=session_id))


@bp.route('/<uuid:session_id>/results')
@login_required
def results(session_id):
    """Afficher les résultats du quiz"""
    session = QcmSession.query.get_or_404(session_id)

    if session.user_id != current_user.id:
        flash('Session invalide', 'danger')
        return redirect(url_for('qcm.select_difficulty'))

    return render_template('results.html', session=session)
