"""Point d'entrée de l'application Flask NIRD"""
from app import create_app
from app.models import db
import os

# Créer l'application
app = create_app(os.environ.get('FLASK_ENV', 'development'))

if __name__ == "__main__":
    with app.app_context():
        # Créer les tables si elles n'existent pas (en dev uniquement)
        # En production, utiliser flask-migrate
        if app.config['DEBUG']:
            db.create_all()
            print("✅ Tables créées (si elles n'existaient pas)")

    # Lancer l'application
    app.run(
        host=os.environ.get('FLASK_RUN_HOST', '0.0.0.0'),
        port=int(os.environ.get('FLASK_RUN_PORT', 5000)),
        debug=app.config['DEBUG']
    )
