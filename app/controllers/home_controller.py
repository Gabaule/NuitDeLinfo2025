# -*- coding: utf-8 -*-
"""Home Controller - Architecture MVC"""
from flask import Blueprint, render_template

home_bp = Blueprint('home', __name__)


@home_bp.route('/')
def index():
    """Page d'accueil NIRD"""
    # Données pour les quiz
    quiz_levels = [
        {
            'title': 'Quiz Facile',
            'description': 'Questions simples pour débuter',
            'badge': 'Niveau 1',
            'color': 'green',
            'difficulty': 'facile'
        },
        {
            'title': 'Quiz Moyen',
            'description': 'Questions de difficulté moyenne',
            'badge': 'Niveau 2',
            'color': 'orange',
            'difficulty': 'moyen'
        },
        {
            'title': 'Quiz Difficile',
            'description': 'Questions avancées pour les experts',
            'badge': 'Niveau 3',
            'color': 'red',
            'difficulty': 'difficile'
        }
    ]

    # Question exemple
    sample_question = {
        'title': 'Qu\'est-ce qu\'un logiciel libre ?',
        'subtitle': 'Testez vos connaissances sur l\'open source',
        'hint': 'Pensez aux 4 libertés fondamentales',
        'answers': [
            {'number': 'A', 'label': 'Un logiciel gratuit', 'active': False},
            {'number': 'B', 'label': 'Un logiciel dont le code source est accessible', 'active': True},
            {'number': 'C', 'label': 'Un logiciel sans licence', 'active': False},
            {'number': 'D', 'label': 'Un logiciel pour Linux uniquement', 'active': False}
        ]
    }

    return render_template('index.html',
                         quiz_levels=quiz_levels,
                         sample_question=sample_question)


@home_bp.route('/retro')
def retro():
    return render_template('retro.html')