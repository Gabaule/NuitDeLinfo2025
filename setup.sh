#!/bin/bash

# Script de démarrage de la base de données PostgreSQL
# Nuit de l'Info 2025

set -e  # Arrêter en cas d'erreur

echo "🌊 Nuit de l'Info 2025 - Setup PostgreSQL"
echo "=========================================="
echo ""

# Couleurs pour l'affichage
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

cd "$(dirname "$0")"

echo -e "${YELLOW}[1/5]${NC} Arrêt des conteneurs existants..."
sudo docker-compose down -v

echo ""
echo -e "${YELLOW}[2/5]${NC} Démarrage de PostgreSQL et pgAdmin..."
sudo docker-compose up -d

echo ""
echo -e "${YELLOW}[3/5]${NC} Attente du démarrage de PostgreSQL (30 secondes)..."
sleep 30

echo ""
echo -e "${YELLOW}[4/5]${NC} Vérification du statut des conteneurs..."
sudo docker-compose ps

echo ""
echo -e "${YELLOW}[5/5]${NC} Test de connexion à PostgreSQL..."
if sudo docker exec -it nuitinfo_postgres psql -U nuitinfo_user -d nuitinfo_db -c "\dt" > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} PostgreSQL est opérationnel !"

    echo ""
    echo "📊 Informations de la base de données :"
    echo "========================================"

    # Compter les tables
    TABLE_COUNT=$(sudo docker exec nuitinfo_postgres psql -U nuitinfo_user -d nuitinfo_db -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';")
    echo -e "Tables créées : ${GREEN}${TABLE_COUNT}${NC}"

    # Compter les questions
    QUESTION_COUNT=$(sudo docker exec nuitinfo_postgres psql -U nuitinfo_user -d nuitinfo_db -t -c "SELECT COUNT(*) FROM questions;")
    echo -e "Questions exemples : ${GREEN}${QUESTION_COUNT}${NC}"

    # Compter les thèmes
    THEME_COUNT=$(sudo docker exec nuitinfo_postgres psql -U nuitinfo_user -d nuitinfo_db -t -c "SELECT COUNT(*) FROM themes;")
    echo -e "Thèmes : ${GREEN}${THEME_COUNT}${NC}"

    echo ""
    echo "🎉 Installation terminée avec succès !"
    echo ""
    echo "📝 Accès :"
    echo "  - PostgreSQL : localhost:5432"
    echo "  - pgAdmin : http://localhost:5050"
    echo "    Email : admin@nuitinfo.com"
    echo "    Password : admin123"
    echo ""
    echo "👤 Compte admin de la BDD :"
    echo "  - Email : admin@nuitinfo.com"
    echo "  - Password : admin123"
    echo "  - Pseudo : admin"
    echo ""
    echo "📚 Commandes utiles :"
    echo "  sudo docker-compose logs -f postgres    # Voir les logs"
    echo "  sudo docker-compose down               # Arrêter les services"
    echo "  sudo docker-compose down -v            # Tout supprimer"
    echo ""
else
    echo -e "${RED}✗${NC} Erreur : PostgreSQL n'est pas accessible"
    echo ""
    echo "Logs PostgreSQL :"
    sudo docker-compose logs postgres | tail -20
    exit 1
fi
