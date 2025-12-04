#!/bin/bash

# Script de démarrage CORRIGÉ - Nuit de l'Info 2025

set -e

echo "🌊 Nuit de l'Info 2025 - Setup PostgreSQL (CORRIGÉ)"
echo "===================================================="
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

cd "$(dirname "$0")"

echo -e "${YELLOW}[1/6]${NC} Correction des permissions des fichiers SQL..."
chmod 644 database/init/*.sql
ls -lh database/init/
echo ""

echo -e "${YELLOW}[2/6]${NC} Arrêt et nettoyage complet..."
sudo docker-compose down -v
echo ""

echo -e "${YELLOW}[3/6]${NC} Démarrage de PostgreSQL..."
sudo docker-compose up -d postgres
echo ""

echo -e "${YELLOW}[4/6]${NC} Attente de l'initialisation (45 secondes)..."
sleep 45
echo ""

echo -e "${YELLOW}[5/6]${NC} Vérification de l'initialisation..."
echo "Logs d'initialisation :"
sudo docker logs nuitinfo_postgres 2>&1 | grep -A 5 "docker-entrypoint-initdb.d" || echo "Pas de logs d'init trouvés"
echo ""

echo -e "${YELLOW}[6/6]${NC} Test de la base de données..."
if sudo docker exec nuitinfo_postgres psql -U nuitinfo_user -d nuitinfo_db -c "\dt" > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Base de données accessible !"
    echo ""

    echo "📊 Statistiques :"
    echo "================="

    TABLE_COUNT=$(sudo docker exec nuitinfo_postgres psql -U nuitinfo_user -d nuitinfo_db -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" | xargs)
    echo -e "Tables : ${GREEN}${TABLE_COUNT}${NC}"

    if [ "$TABLE_COUNT" -gt "0" ]; then
        QUESTION_COUNT=$(sudo docker exec nuitinfo_postgres psql -U nuitinfo_user -d nuitinfo_db -t -c "SELECT COUNT(*) FROM questions;" 2>/dev/null | xargs || echo "0")
        echo -e "Questions : ${GREEN}${QUESTION_COUNT}${NC}"

        THEME_COUNT=$(sudo docker exec nuitinfo_postgres psql -U nuitinfo_user -d nuitinfo_db -t -c "SELECT COUNT(*) FROM themes;" 2>/dev/null | xargs || echo "0")
        echo -e "Thèmes : ${GREEN}${THEME_COUNT}${NC}"

        USER_COUNT=$(sudo docker exec nuitinfo_postgres psql -U nuitinfo_user -d nuitinfo_db -t -c "SELECT COUNT(*) FROM users;" 2>/dev/null | xargs || echo "0")
        echo -e "Utilisateurs : ${GREEN}${USER_COUNT}${NC}"
    fi

    echo ""
    echo "🎉 Installation réussie !"
    echo ""
    echo "📝 Informations de connexion :"
    echo "  PostgreSQL : localhost:5432"
    echo "    Database : nuitinfo_db"
    echo "    User     : nuitinfo_user"
    echo "    Password : SecurePassword123!"
    echo ""
    echo "  Admin BDD :"
    echo "    Email    : admin@nuitinfo.com"
    echo "    Password : admin123"
    echo ""

    echo -e "${YELLOW}[BONUS]${NC} Démarrage de pgAdmin..."
    sudo docker-compose up -d pgadmin
    sleep 5
    echo -e "${GREEN}✓${NC} pgAdmin : http://localhost:5050"
    echo "    Email    : admin@nuitinfo.com"
    echo "    Password : admin123"
    echo ""

else
    echo -e "${RED}✗${NC} Erreur lors de l'accès à la base"
    echo ""
    echo "Logs complets :"
    sudo docker logs nuitinfo_postgres 2>&1 | tail -30
    exit 1
fi
