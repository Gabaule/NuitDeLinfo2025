"""Models package - Architecture MVC"""
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

# Import all models for easier access
from app.models.user import User
from app.models.question import Theme, Question, QuestionChoice, QuestionTextAnswer
from app.models.qcm import QcmSession, QcmSessionQuestion, UserAnswer
from app.models.chatbot import ChatbotConversation, ChatbotMessage

__all__ = [
    'db',
    'User',
    'Theme',
    'Question',
    'QuestionChoice',
    'QuestionTextAnswer',
    'QcmSession',
    'QcmSessionQuestion',
    'UserAnswer',
    'ChatbotConversation',
    'ChatbotMessage'
]
