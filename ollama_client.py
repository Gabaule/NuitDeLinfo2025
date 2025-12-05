#!/usr/bin/env python3
"""
Client Python pour interagir avec l'API Ollama
Nuit de l'Info 2025
"""

import requests
import json
import sys


class OllamaClient:
    """Client pour l'API Ollama"""

    def __init__(self, base_url="http://localhost:11434"):
        self.base_url = base_url

    def list_models(self):
        """Liste tous les modèles installés"""
        response = requests.get(f"{self.base_url}/api/tags")
        return response.json()

    def generate(self, model, prompt, stream=False):
        """
        Génère une réponse du modèle

        Args:
            model: Nom du modèle (ex: "llama3.2:1b")
            prompt: Question/prompt à envoyer
            stream: Si True, retourne un générateur pour streaming
        """
        if stream:
            return self._generate_stream(model, prompt)
        else:
            data = {
                "model": model,
                "prompt": prompt,
                "stream": False
            }
            response = requests.post(
                f"{self.base_url}/api/generate",
                json=data
            )
            return response.json()

    def _generate_stream(self, model, prompt):
        """Générateur pour le streaming"""
        data = {
            "model": model,
            "prompt": prompt,
            "stream": True
        }
        response = requests.post(
            f"{self.base_url}/api/generate",
            json=data,
            stream=True
        )
        for line in response.iter_lines():
            if line:
                yield json.loads(line)

    def chat(self, model, messages, stream=False):
        """
        Chat avec historique de conversation

        Args:
            model: Nom du modèle
            messages: Liste de messages [{"role": "user", "content": "..."}]
            stream: Si True, retourne un générateur pour streaming
        """
        if stream:
            return self._chat_stream(model, messages)
        else:
            data = {
                "model": model,
                "messages": messages,
                "stream": False
            }
            response = requests.post(
                f"{self.base_url}/api/chat",
                json=data
            )
            return response.json()

    def _chat_stream(self, model, messages):
        """Générateur pour le streaming du chat"""
        data = {
            "model": model,
            "messages": messages,
            "stream": True
        }
        response = requests.post(
            f"{self.base_url}/api/chat",
            json=data,
            stream=True
        )
        for line in response.iter_lines():
            if line:
                yield json.loads(line)


def main():
    """Exemples d'utilisation"""
    client = OllamaClient()

    print("=" * 60)
    print("CLIENT API OLLAMA - Nuit de l'Info 2025")
    print("=" * 60)
    print()

    # 1. Lister les modèles disponibles
    print("📋 Modèles installés:")
    print("-" * 60)
    try:
        models = client.list_models()
        if "models" in models and models["models"]:
            for model in models["models"]:
                print(f"  - {model['name']}")
                print(f"    Taille: {model.get('size', 'N/A')} bytes")
                print(f"    Modifié: {model.get('modified_at', 'N/A')}")
                print()
        else:
            print("  ⚠️  Aucun modèle installé")
            print("  Utilisez: docker exec nuitinfo_ollama ollama pull llama3.2:1b")
            return
    except requests.exceptions.ConnectionError:
        print("  ❌ Erreur: Impossible de se connecter à Ollama")
        print("  Vérifiez que le service est démarré: sudo docker-compose up -d ollama")
        return

    # Sélectionner le premier modèle disponible
    model_name = models["models"][0]["name"]
    print()
    print(f"🤖 Utilisation du modèle: {model_name}")
    print("=" * 60)
    print()

    # 2. Exemple de génération simple (sans streaming)
    print("💬 Exemple 1: Génération simple")
    print("-" * 60)
    prompt = "Explique en une phrase ce qu'est un océan."
    print(f"Prompt: {prompt}")
    print()

    response = client.generate(model_name, prompt, stream=False)
    print(f"Réponse: {response['response']}")
    print()

    # 3. Exemple de chat avec historique
    print()
    print("💬 Exemple 2: Chat avec historique")
    print("-" * 60)
    messages = [
        {"role": "user", "content": "Bonjour! Peux-tu me parler des océans?"},
    ]

    response = client.chat(model_name, messages, stream=False)
    assistant_message = response["message"]["content"]
    print(f"User: {messages[0]['content']}")
    print(f"Assistant: {assistant_message}")
    print()

    # Continuer la conversation
    messages.append({"role": "assistant", "content": assistant_message})
    messages.append({"role": "user", "content": "Pourquoi sont-ils importants pour la planète?"})

    response = client.chat(model_name, messages, stream=False)
    print(f"User: {messages[-1]['content']}")
    print(f"Assistant: {response['message']['content']}")
    print()

    # 4. Exemple de streaming
    print()
    print("💬 Exemple 3: Streaming (réponse en temps réel)")
    print("-" * 60)
    prompt = "Cite 3 menaces pour les océans."
    print(f"Prompt: {prompt}")
    print("Réponse (streaming): ", end="", flush=True)

    full_response = ""
    for chunk in client.generate(model_name, prompt, stream=True):
        if "response" in chunk:
            token = chunk["response"]
            full_response += token
            print(token, end="", flush=True)

    print("\n")
    print("=" * 60)
    print()


if __name__ == "__main__":
    main()
