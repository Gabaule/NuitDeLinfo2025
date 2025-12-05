"""Routes pour l'authentification (login/logout/register)"""
from flask import Blueprint, render_template, request, redirect, url_for, flash
from flask_login import login_user, logout_user, login_required
from app.models import db, User

bp = Blueprint('auth', __name__, url_prefix='/auth')


@bp.route('/login', methods=['GET', 'POST'])
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


@bp.route('/logout')
@login_required
def logout():
    """Déconnexion"""
    logout_user()
    flash('Vous avez été déconnecté', 'info')
    return redirect(url_for('home.index'))


@bp.route('/register', methods=['GET', 'POST'])
def register():
    """Inscription (optionnel pour la Nuit de l'Info)"""
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')
        pseudo = request.form.get('pseudo')

        # Vérifier si l'utilisateur existe déjà
        if User.query.filter_by(email=email).first():
            flash('Cet email est déjà utilisé', 'danger')
            return redirect(url_for('auth.register'))

        if User.query.filter_by(pseudo=pseudo).first():
            flash('Ce pseudo est déjà pris', 'danger')
            return redirect(url_for('auth.register'))

        # Créer nouvel utilisateur
        user = User(email=email, pseudo=pseudo)
        user.set_password(password)

        db.session.add(user)
        db.session.commit()

        flash('Compte créé avec succès! Vous pouvez maintenant vous connecter.', 'success')
        return redirect(url_for('auth.login'))

    return render_template('register.html')
