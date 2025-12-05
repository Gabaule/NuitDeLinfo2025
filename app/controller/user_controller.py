from flask import Blueprint, jsonify
from app import db
from app.models import User

# Création d'un Blueprint pour gérer les utilisateurs
user_bp = Blueprint('user_bp', __name__)

# Route pour lister tous les utilisateurs
@user_bp.route('/', methods=['GET'])
def get_users():
    users = User.query.all()
    result = [{"id_user": user.id_user, "pseudo": user.pseudo, "mail": user.mail, "date_inscription": user.date_inscription, "role": user.role} for user in users]
    return jsonify(result)

# Vous pouvez ajouter d'autres routes pour la gestion des utilisateurs (création, modification, suppression)
