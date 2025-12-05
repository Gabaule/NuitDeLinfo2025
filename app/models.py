"""Mod�les SQLAlchemy pour la base de donn�es NIRD"""
from datetime import datetime
from flask_sqlalchemy import SQLAlchemy
from flask_login import UserMixin
from sqlalchemy.dialects.postgresql import UUID
import uuid
import bcrypt

db = SQLAlchemy()


class User(UserMixin, db.Model):
    """Utilisateurs du syst�me"""
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
        """V�rifie le mot de passe"""
        return bcrypt.checkpw(password.encode('utf-8'), self.password_hash.encode('utf-8'))

    def get_id(self):
        """Override pour Flask-Login (UUID au lieu d'int)"""
        return str(self.id)

    def __repr__(self):
        return f'<User {self.pseudo}>'


class Theme(db.Model):
    """Th�mes des questions"""
    __tablename__ = 'themes'

    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = db.Column(db.String(100), unique=True, nullable=False)
    description = db.Column(db.Text)
    is_active = db.Column(db.Boolean, default=True, index=True)
    created_at = db.Column(db.DateTime(timezone=True), default=datetime.utcnow)

    # Relations
    questions = db.relationship('Question', backref='theme', lazy='dynamic')

    def __repr__(self):
        return f'<Theme {self.name}>'


class Question(db.Model):
    """Questions du QCM"""
    __tablename__ = 'questions'

    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    theme_id = db.Column(UUID(as_uuid=True), db.ForeignKey('themes.id'), nullable=False, index=True)
    question_type = db.Column(db.String(20), nullable=False, index=True)  # 'multiple_choice' ou 'text_input'
    difficulty = db.Column(db.String(20), nullable=False, index=True)  # 'facile', 'moyen', 'difficile'
    question_text = db.Column(db.Text, nullable=False)
    explanation = db.Column(db.Text)
    created_at = db.Column(db.DateTime(timezone=True), default=datetime.utcnow)
    updated_at = db.Column(db.DateTime(timezone=True), default=datetime.utcnow, onupdate=datetime.utcnow)

    # Relations
    choices = db.relationship('QuestionChoice', backref='question', lazy='dynamic', cascade='all, delete-orphan')
    text_answer = db.relationship('QuestionTextAnswer', backref='question', uselist=False, cascade='all, delete-orphan')
    session_questions = db.relationship('QcmSessionQuestion', backref='question', lazy='dynamic')

    def __repr__(self):
        return f'<Question {self.id} - {self.difficulty}>'


class QuestionChoice(db.Model):
    """Choix de r�ponses pour QCM � choix multiples"""
    __tablename__ = 'question_choices'

    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    question_id = db.Column(UUID(as_uuid=True), db.ForeignKey('questions.id', ondelete='CASCADE'), nullable=False, index=True)
    choice_text = db.Column(db.Text, nullable=False)
    is_correct = db.Column(db.Boolean, nullable=False, default=False)
    choice_order = db.Column(db.Integer, nullable=False)
    created_at = db.Column(db.DateTime(timezone=True), default=datetime.utcnow)

    # Relations
    user_answers = db.relationship('UserAnswer', backref='choice', lazy='dynamic')

    def __repr__(self):
        return f'<QuestionChoice {self.choice_order}>'


class QuestionTextAnswer(db.Model):
    """R�ponses correctes pour questions � texte libre"""
    __tablename__ = 'question_text_answers'

    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    question_id = db.Column(UUID(as_uuid=True), db.ForeignKey('questions.id', ondelete='CASCADE'), unique=True, nullable=False, index=True)
    correct_answer = db.Column(db.Text, nullable=False)
    created_at = db.Column(db.DateTime(timezone=True), default=datetime.utcnow)

    def __repr__(self):
        return f'<QuestionTextAnswer for {self.question_id}>'


class QcmSession(db.Model):
    """Sessions de QCM des utilisateurs"""
    __tablename__ = 'qcm_sessions'

    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = db.Column(UUID(as_uuid=True), db.ForeignKey('users.id', ondelete='CASCADE'), nullable=False, index=True)
    difficulty = db.Column(db.String(20), nullable=False)
    total_score = db.Column(db.Integer, nullable=False, default=0)
    max_possible_score = db.Column(db.Integer, nullable=False, default=30)
    is_completed = db.Column(db.Boolean, default=False, index=True)
    started_at = db.Column(db.DateTime(timezone=True), default=datetime.utcnow)
    completed_at = db.Column(db.DateTime(timezone=True))
    created_at = db.Column(db.DateTime(timezone=True), default=datetime.utcnow)

    # Relations
    session_questions = db.relationship('QcmSessionQuestion', backref='session', lazy='dynamic', cascade='all, delete-orphan', order_by='QcmSessionQuestion.question_order')

    def __repr__(self):
        return f'<QcmSession {self.id} - {self.user.pseudo if self.user else "unknown"}>'


class QcmSessionQuestion(db.Model):
    """Questions d'une session sp�cifique"""
    __tablename__ = 'qcm_session_questions'

    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    session_id = db.Column(UUID(as_uuid=True), db.ForeignKey('qcm_sessions.id', ondelete='CASCADE'), nullable=False, index=True)
    question_id = db.Column(UUID(as_uuid=True), db.ForeignKey('questions.id'), nullable=False, index=True)
    question_order = db.Column(db.Integer, nullable=False)
    question_score = db.Column(db.Integer, default=0)
    created_at = db.Column(db.DateTime(timezone=True), default=datetime.utcnow)

    # Relations
    user_answers = db.relationship('UserAnswer', backref='session_question', lazy='dynamic', cascade='all, delete-orphan')

    def __repr__(self):
        return f'<QcmSessionQuestion {self.question_order}>'


class UserAnswer(db.Model):
    """R�ponses donn�es par les utilisateurs"""
    __tablename__ = 'user_answers'

    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    session_question_id = db.Column(UUID(as_uuid=True), db.ForeignKey('qcm_session_questions.id', ondelete='CASCADE'), nullable=False, index=True)
    choice_id = db.Column(UUID(as_uuid=True), db.ForeignKey('question_choices.id', ondelete='SET NULL'), index=True)
    text_answer = db.Column(db.Text)
    is_correct = db.Column(db.Boolean)
    created_at = db.Column(db.DateTime(timezone=True), default=datetime.utcnow)

    def __repr__(self):
        return f'<UserAnswer {self.id}>'


class ChatbotConversation(db.Model):
    """Conversations avec le chatbot"""
    __tablename__ = 'chatbot_conversations'

    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = db.Column(UUID(as_uuid=True), db.ForeignKey('users.id', ondelete='CASCADE'), nullable=False, index=True)
    title = db.Column(db.String(255))
    created_at = db.Column(db.DateTime(timezone=True), default=datetime.utcnow)
    updated_at = db.Column(db.DateTime(timezone=True), default=datetime.utcnow, onupdate=datetime.utcnow, index=True)

    # Relations
    messages = db.relationship('ChatbotMessage', backref='conversation', lazy='dynamic', cascade='all, delete-orphan', order_by='ChatbotMessage.created_at')

    def __repr__(self):
        return f'<ChatbotConversation {self.title or self.id}>'


class ChatbotMessage(db.Model):
    """Messages �chang�s avec le chatbot"""
    __tablename__ = 'chatbot_messages'

    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    conversation_id = db.Column(UUID(as_uuid=True), db.ForeignKey('chatbot_conversations.id', ondelete='CASCADE'), nullable=False, index=True)
    role = db.Column(db.String(20), nullable=False)  # 'user' ou 'assistant'
    content = db.Column(db.Text, nullable=False)
    created_at = db.Column(db.DateTime(timezone=True), default=datetime.utcnow, index=True)

    def __repr__(self):
        return f'<ChatbotMessage {self.role}: {self.content[:50]}...>'
