"""User model - Gestion des utilisateurs"""
from datetime import datetime
from flask_login import UserMixin
from sqlalchemy.dialects.postgresql import UUID
import uuid
import bcrypt

from app.models import db


class User(UserMixin, db.Model):
    """Utilisateurs du système"""
    __tablename__ = 'users'

    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    email = db.Column(db.String(255), unique=True, nullable=False, index=True)
    password_hash = db.Column(db.String(255), nullable=False)
    pseudo = db.Column(db.String(100), unique=True, nullable=False, index=True)
    role = db.Column(db.String(20), nullable=False, default='user', index=True)
    created_at = db.Column(db.DateTime(timezone=True), default=datetime.utcnow)
    updated_at = db.Column(db.DateTime(timezone=True), default=datetime.utcnow, onupdate=datetime.utcnow)

    # Relations
    qcm_sessions = db.relationship('QcmSession', backref='user', lazy='dynamic', cascade='all, delete-orphan')
    chatbot_conversations = db.relationship('ChatbotConversation', backref='user', lazy='dynamic', cascade='all, delete-orphan')

    def set_password(self, password):
        """Hash le mot de passe avec bcrypt"""
        self.password_hash = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')

    def check_password(self, password):
        """Vérifie le mot de passe"""
        return bcrypt.checkpw(password.encode('utf-8'), self.password_hash.encode('utf-8'))

    def get_id(self):
        """Override pour Flask-Login (UUID au lieu d'int)"""
        return str(self.id)

    def __repr__(self):
        return f'<User {self.pseudo}>'
