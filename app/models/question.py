"""Question models - Gestion des questions et thèmes"""
from datetime import datetime
from sqlalchemy.dialects.postgresql import UUID
import uuid

from app.models import db


class Theme(db.Model):
    """Thèmes des questions"""
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
    question_type = db.Column(db.String(20), nullable=False, index=True)
    difficulty = db.Column(db.String(20), nullable=False, index=True)
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
    """Choix de réponses pour QCM à choix multiples"""
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
    """Réponses correctes pour questions à texte libre"""
    __tablename__ = 'question_text_answers'

    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    question_id = db.Column(UUID(as_uuid=True), db.ForeignKey('questions.id', ondelete='CASCADE'), unique=True, nullable=False, index=True)
    correct_answer = db.Column(db.Text, nullable=False)
    created_at = db.Column(db.DateTime(timezone=True), default=datetime.utcnow)

    def __repr__(self):
        return f'<QuestionTextAnswer for {self.question_id}>'
