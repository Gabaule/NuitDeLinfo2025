# Nuit de l'Info 2025 - Base de données PostgreSQL

Système de QCM avec chatbot pour la Nuit de l'Info 2025.

## Architecture

- **Base de données** : PostgreSQL 16
- **Administration** : pgAdmin 4
- **Backend** : Flask (Python)

## Structure de la base de données

### Tables principales

1. **users** - Utilisateurs avec rôles (admin/user)
2. **themes** - 6 thèmes fixes sur les océans
3. **questions** - Questions avec types (QCM/texte) et niveaux (facile/moyen/difficile)
4. **question_choices** - Choix de réponses pour QCM
5. **question_text_answers** - Réponses pour questions texte
6. **qcm_sessions** - Tentatives de QCM
7. **qcm_session_questions** - Questions d'une session
8. **user_answers** - Réponses utilisateurs
9. **chatbot_conversations** - Conversations chatbot
10. **chatbot_messages** - Messages du chatbot

## Démarrage rapide

### 1. Lancer la base de données

```bash
cd /home/noam/Bureau/nuitinfo/NuitDeLinfo2025
docker-compose up -d
```

### 2. Vérifier que tout fonctionne

```bash
# Voir les logs
docker-compose logs -f postgres

# Vérifier que la BDD est accessible
docker exec -it nuitinfo_postgres psql -U nuitinfo_user -d nuitinfo_db -c "\dt"
```

### 3. Accéder à pgAdmin

Ouvrir dans le navigateur : http://localhost:5050

- Email : admin@nuitinfo.com
- Mot de passe : admin123

Pour se connecter au serveur PostgreSQL dans pgAdmin :
- Host : postgres
- Port : 5432
- Database : nuitinfo_db
- Username : nuitinfo_user
- Password : SecurePassword123!

## Données initiales

### Compte admin

- Email : admin@nuitinfo.com
- Mot de passe : admin123
- Pseudo : admin

### Thèmes

1. Océanographie
2. Climat
3. Biodiversité marine
4. Pollution
5. Énergies marines
6. Protection des océans

### Questions exemples

La base contient des questions exemples pour chaque thème et niveau de difficulté.

## Commandes utiles

### Docker

```bash
# Démarrer les services
docker-compose up -d

# Arrêter les services
docker-compose down

# Arrêter et supprimer les volumes (⚠️ supprime toutes les données)
docker-compose down -v

# Redémarrer PostgreSQL
docker-compose restart postgres

# Voir les logs
docker-compose logs -f postgres
```

### PostgreSQL

```bash
# Se connecter au shell PostgreSQL
docker exec -it nuitinfo_postgres psql -U nuitinfo_user -d nuitinfo_db

# Lister les tables
docker exec -it nuitinfo_postgres psql -U nuitinfo_user -d nuitinfo_db -c "\dt"

# Compter les questions
docker exec -it nuitinfo_postgres psql -U nuitinfo_user -d nuitinfo_db -c "SELECT COUNT(*) FROM questions;"

# Voir les thèmes
docker exec -it nuitinfo_postgres psql -U nuitinfo_user -d nuitinfo_db -c "SELECT * FROM themes;"

# Backup de la base
docker exec nuitinfo_postgres pg_dump -U nuitinfo_user nuitinfo_db > backup_$(date +%Y%m%d_%H%M%S).sql

# Restaurer la base
docker exec -i nuitinfo_postgres psql -U nuitinfo_user -d nuitinfo_db < backup.sql
```

## Configuration Flask (pour plus tard)

### Installation des dépendances

```bash
# Créer un environnement virtuel
python3 -m venv venv
source venv/bin/activate

# Installer les dépendances
pip install -r requirements.txt
```

### Variables d'environnement

Le fichier `.env` contient les configurations. Modifier si nécessaire :

```env
POSTGRES_DB=nuitinfo_db
POSTGRES_USER=nuitinfo_user
POSTGRES_PASSWORD=SecurePassword123!
DATABASE_URL=postgresql://nuitinfo_user:SecurePassword123!@localhost:5432/nuitinfo_db
```

## Fonctionnalités du système QCM

### Types de questions

1. **QCM à choix multiples** (`multiple_choice`)
   - 1 à N réponses correctes possibles
   - +1 point par bonne réponse
   - -1 point par mauvaise réponse
   - Score minimum 0 par question

2. **Questions à texte libre** (`text_input`)
   - Validation flexible (ignore casse, espaces, accents)

### Niveaux de difficulté

- Facile
- Moyen
- Difficile

### QCM

- 30 questions par session
- Répartition équilibrée entre les thèmes
- Sélection aléatoire des questions
- Tentatives illimitées
- Relecture de la meilleure tentative

### Chatbot

- Historique complet des conversations
- Les admins peuvent voir les historiques de tous les utilisateurs

## Schéma de la base de données

```
users
├── qcm_sessions
│   ├── qcm_session_questions
│   │   └── user_answers
│   └── (score tracking)
└── chatbot_conversations
    └── chatbot_messages
```

## Troubleshooting

### Le container PostgreSQL ne démarre pas

```bash
# Vérifier les logs
docker-compose logs postgres

# Supprimer les volumes et recréer
docker-compose down -v
docker-compose up -d
```

### Impossible de se connecter à PostgreSQL

```bash
# Vérifier que le container tourne
docker ps

# Vérifier le health check
docker inspect nuitinfo_postgres | grep -A 10 Health
```

### Réinitialiser complètement la base

```bash
# Arrêter et supprimer tout
docker-compose down -v

# Relancer
docker-compose up -d

# La base sera recréée avec les scripts init
```

## Ports utilisés

- **5432** : PostgreSQL
- **5050** : pgAdmin

## Sécurité

⚠️ **Pour une Nuit de l'Info uniquement** : Les mots de passe sont en clair pour simplifier.
**NE PAS utiliser en production !**

## Support

Pour toute question, voir la documentation PostgreSQL ou Flask :
- PostgreSQL : https://www.postgresql.org/docs/
- Flask-SQLAlchemy : https://flask-sqlalchemy.palletsprojects.com/

## Licence

Apache 2.0