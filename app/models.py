from app import db
from datetime import datetime

class User(db.Model):
    __tablename__ = 'user'  # Le nom de la table en base de données
    id_user = db.Column(db.Integer, primary_key=True)
    pseudo = db.Column(db.String(50), unique=True, nullable=False)
    mail = db.Column(db.String(100), unique=True, nullable=False)
    mdp = db.Column(db.String(255), nullable=False)
    date_inscription = db.Column(db.DateTime, default=datetime.utcnow)
    role = db.Column(db.String(20), nullable=False)

    __table_args__ = (
        db.CheckConstraint(role.in_(['admin', 'participant', 'visiteur'])),
    )

    def __repr__(self):
        return f'<User {self.pseudo}, {self.role}>'
