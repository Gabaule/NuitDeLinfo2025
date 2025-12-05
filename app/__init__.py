from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from .config import Config

# Instanciation de l'extension SQLAlchemy
db = SQLAlchemy()

def create_app(config_class=Config):
    # Création de l'application Flask
    app = Flask(__name__)
    app.config.from_object(config_class)

    # Initialisation des extensions
    db.init_app(app)

    # Enregistrement des Blueprints
    from .controllers.user_controller import user_bp
    app.register_blueprint(user_bp, url_prefix='/api/users')

    # D'autres contrôleurs peuvent être enregistrés ici à l'avenir

    return app
