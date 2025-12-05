"""Routes pour la page d'accueil"""
from flask import Blueprint, render_template

bp = Blueprint('home', __name__)


@bp.route('/')
def index():
    """Page d'accueil NIRD"""
    return render_template('index.html')
