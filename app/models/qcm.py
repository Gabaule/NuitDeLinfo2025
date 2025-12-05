"""QCM models - Gestion des sessions de quiz"""
from datetime import datetime
from sqlalchemy.dialects.postgresql import UUID
import uuid

from app.models import db


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
    """Questions d'une session spécifique"""
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
    """Réponses données par les utilisateurs"""
    __tablename__ = 'user_answers'

    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    session_question_id = db.Column(UUID(as_uuid=True), db.ForeignKey('qcm_session_questions.id', ondelete='CASCADE'), nullable=False, index=True)
    choice_id = db.Column(UUID(as_uuid=True), db.ForeignKey('question_choices.id', ondelete='SET NULL'), index=True)
    text_answer = db.Column(db.Text)
    is_correct = db.Column(db.Boolean)
    created_at = db.Column(db.DateTime(timezone=True), default=datetime.utcnow)

    def __repr__(self):
        return f'<UserAnswer {self.id}>'
