"""Chatbot models - Gestion des conversations ShadyGPT"""
from datetime import datetime
from sqlalchemy.dialects.postgresql import UUID
import uuid

from app.models import db


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
    """Messages échangés avec le chatbot"""
    __tablename__ = 'chatbot_messages'

    id = db.Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    conversation_id = db.Column(UUID(as_uuid=True), db.ForeignKey('chatbot_conversations.id', ondelete='CASCADE'), nullable=False, index=True)
    role = db.Column(db.String(20), nullable=False)
    content = db.Column(db.Text, nullable=False)
    created_at = db.Column(db.DateTime(timezone=True), default=datetime.utcnow, index=True)

    def __repr__(self):
        return f'<ChatbotMessage {self.role}: {self.content[:50]}...>'
