#!/bin/bash

# Script de configuration Ollama avec modèle
# Nuit de l'Info 2025

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

cd "$(dirname "$0")"

echo -e "${BLUE}🤖 Configuration Ollama - Nuit de l'Info 2025${NC}"
echo "=============================================="
echo ""

# Vérifier si Ollama tourne
echo -e "${YELLOW}[1/5]${NC} Vérification du service Ollama..."
if ! sudo docker ps | grep -q nuitinfo_ollama; then
    echo "Ollama n'est pas démarré. Lancement..."
    sudo docker-compose up -d ollama
    echo "Attente du démarrage d'Ollama (30 secondes)..."
    sleep 30
else
    echo -e "${GREEN}✓${NC} Ollama est déjà démarré"
fi

echo ""
echo -e "${YELLOW}[2/5]${NC} Choix du modèle à télécharger"
echo ""
echo "Modèles recommandés pour un chatbot :"
echo "  1) llama3.2:3b     - Petit, rapide (2 GB)"
echo "  2) phi3:mini       - Très léger (2.3 GB)"
echo "  3) mistral:7b      - Bon équilibre (4.1 GB)"
echo "  4) llama3.2:1b     - Ultra-léger (1.3 GB) - Recommandé pour démarrer"
echo "  5) Autre modèle"
echo ""
echo -n "Votre choix [1-5] (défaut: 4): "
read CHOICE

case ${CHOICE:-4} in
    1)
        MODEL="llama3.2:3b"
        ;;
    2)
        MODEL="phi3:mini"
        ;;
    3)
        MODEL="mistral:7b"
        ;;
    4)
        MODEL="llama3.2:1b"
        ;;
    5)
        echo -n "Nom du modèle : "
        read MODEL
        ;;
    *)
        MODEL="llama3.2:1b"
        ;;
esac

echo ""
echo -e "${YELLOW}[3/5]${NC} Téléchargement du modèle ${MODEL}..."
echo "Cela peut prendre quelques minutes selon votre connexion..."
sudo docker exec nuitinfo_ollama ollama pull ${MODEL}

echo ""
echo -e "${YELLOW}[4/5]${NC} Test du modèle..."
echo "Question test : 'Bonjour, qui es-tu ?'"
echo ""
RESPONSE=$(sudo docker exec nuitinfo_ollama ollama run ${MODEL} "Bonjour, qui es-tu ? Réponds en une phrase courte.")
echo -e "${GREEN}Réponse du modèle :${NC}"
echo "$RESPONSE"

echo ""
echo -e "${YELLOW}[5/5]${NC} Démarrage de l'interface Web..."
sudo docker-compose up -d ollama-webui
sleep 5

echo ""
echo -e "${GREEN}🎉 Configuration terminée !${NC}"
echo ""
echo "📝 Accès au chatbot :"
echo "  Interface Web : http://localhost:3000"
echo "  API Ollama    : http://localhost:11434"
echo ""
echo "🔧 Utilisation de l'API :"
echo ""
echo "# Lister les modèles installés"
echo "curl http://localhost:11434/api/tags"
echo ""
echo "# Envoyer un message au chatbot"
echo "curl http://localhost:11434/api/generate -d '{"
echo "  \"model\": \"${MODEL}\","
echo "  \"prompt\": \"Explique ce qu'est un océan en une phrase\","
echo "  \"stream\": false"
echo "}'"
echo ""
echo "📚 Modèle actif : ${MODEL}"
echo ""
echo "💡 Pour tester depuis Python :"
echo ""
cat << 'PYTHON_EOF'
import requests

def chat_with_ollama(message, model="llama3.2:1b"):
    response = requests.post(
        "http://localhost:11434/api/generate",
        json={
            "model": model,
            "prompt": message,
            "stream": False
        }
    )
    return response.json()["response"]

# Test
print(chat_with_ollama("Bonjour !"))
PYTHON_EOF

echo ""
echo "🌐 Interface Web Ollama :"
echo "  Ouvrez http://localhost:3000 dans votre navigateur"
echo "  Créez un compte (local, stocké dans le container)"
echo "  Commencez à chatter avec le modèle ${MODEL}"
echo ""
