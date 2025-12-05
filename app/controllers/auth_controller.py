# -*- coding: utf-8 -*-
"""Auth Controller - Architecture MVC"""
from flask import Blueprint, render_template, request, redirect, url_for, flash
from flask_login import login_user, logout_user, login_required
from app.models import db, User

auth_bp = Blueprint('auth', __name__, url_prefix='/auth')


@auth_bp.route('/login', methods=['GET', 'POST'])
def login():
    """Page de connexion"""
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')

        user = User.query.filter_by(email=email).first()

        if user and user.check_password(password):
            login_user(user)
            flash(f'Bienvenue {user.pseudo}!', 'success')
            next_page = request.args.get('next')
            return redirect(next_page or url_for('home.index'))
        else:
            flash('Email ou mot de passe incorrect', 'danger')

    return render_template('login.html')


@auth_bp.route('/logout')
@login_required
def logout():
    """D�connexion"""
    logout_user()
    flash('Vous avez �t� d�connect�', 'info')
    return redirect(url_for('home.index'))


@auth_bp.route('/register', methods=['GET', 'POST'])
def register():
    """Inscription (optionnel pour la Nuit de l'Info)"""
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')
        pseudo = request.form.get('pseudo')

        # V�rifier si l'utilisateur existe d�j�
        if User.query.filter_by(email=email).first():
            flash('Cet email est d�j� utilis�', 'danger')
            return redirect(url_for('auth.register'))

        if User.query.filter_by(pseudo=pseudo).first():
            flash('Ce pseudo est d�j� pris', 'danger')
            return redirect(url_for('auth.register'))

        # Cr�er nouvel utilisateur
        user = User(email=email, pseudo=pseudo)
        user.set_password(password)

        db.session.add(user)
        db.session.commit()

        flash('Compte cr�� avec succ�s! Vous pouvez maintenant vous connecter.', 'success')
        return redirect(url_for('auth.login'))

    return render_template('register.html')
