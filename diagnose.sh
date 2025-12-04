#!/bin/bash

echo "🔍 Diagnostic PostgreSQL - Nuit de l'Info 2025"
echo "=============================================="
echo ""

cd "$(dirname "$0")"

echo "1️⃣ Statut des conteneurs Docker :"
echo "-----------------------------------"
sudo docker ps -a | grep nuitinfo
echo ""

echo "2️⃣ Logs PostgreSQL (50 dernières lignes) :"
echo "-------------------------------------------"
sudo docker logs nuitinfo_postgres 2>&1 | tail -50
echo ""

echo "3️⃣ Health check du conteneur :"
echo "--------------------------------"
sudo docker inspect nuitinfo_postgres --format='{{json .State.Health}}' | python3 -m json.tool 2>/dev/null || echo "Pas de health check info"
echo ""

echo "4️⃣ Test de connexion direct :"
echo "-------------------------------"
if sudo docker exec nuitinfo_postgres pg_isready -U nuitinfo_user; then
    echo "✅ PostgreSQL répond"
else
    echo "❌ PostgreSQL ne répond pas"
fi
echo ""

echo "5️⃣ Vérification des fichiers d'initialisation :"
echo "-------------------------------------------------"
ls -lh database/init/
echo ""

echo "6️⃣ Tentative de connexion à la base :"
echo "---------------------------------------"
sudo docker exec nuitinfo_postgres psql -U nuitinfo_user -d nuitinfo_db -c "SELECT version();" 2>&1
echo ""
