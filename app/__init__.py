"""Factory Flask pour l'application NIRD - Nuit de l'Info 2025"""
from flask import Flask
from flask_login import LoginManager
from flask_cors import CORS
import os

from app.config import config
from app.models import db, User


login_manager = LoginManager()


@login_manager.user_loader
def load_user(user_id):
    """Charge un utilisateur pour Flask-Login"""
    return User.query.get(user_id)


def create_app(config_name=None):
    """Factory pour créer l'application Flask"""

    if config_name is None:
        config_name = os.environ.get('FLASK_ENV', 'development')

    app = Flask(__name__,
                template_folder='../templates',
                static_folder='../static')

    # Configuration
    app.config.from_object(config[config_name])

    # Initialize extensions
    db.init_app(app)
    CORS(app)

    # Flask-Login
    login_manager.init_app(app)
    login_manager.login_view = 'auth.login'
    login_manager.login_message = 'Veuillez vous connecter pour accéder à cette page.'
    login_manager.login_message_category = 'info'

    # Register blueprints
    from app.routes import home, auth, qcm, chatbot

    app.register_blueprint(home.bp)
    app.register_blueprint(auth.bp)
    app.register_blueprint(qcm.bp)
    app.register_blueprint(chatbot.bp)

    # Context processor pour les templates
    @app.context_processor
    def inject_user():
        from flask_login import current_user
        return dict(current_user=current_user)

    return app
