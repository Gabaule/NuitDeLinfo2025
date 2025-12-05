"""Script d'initialisation automatique de la base de données"""
from app.models import db, User, Theme, Question, QuestionChoice, QuestionTextAnswer
import os


def init_database(app):
    """Initialise la BDD avec les données par défaut si elles n'existent pas"""

    with app.app_context():
        # Créer toutes les tables
        db.create_all()

        # 1. Créer le compte admin s'il n'existe pas
        admin = User.query.filter_by(email='admin@nuitinfo.com').first()
        if not admin:
            print("🔧 Création du compte admin...")
            admin = User(
                email='admin@nuitinfo.com',
                pseudo='Admin',
                role='admin'
            )
            admin.set_password('admin123')
            db.session.add(admin)
            db.session.commit()
            print("✅ Compte admin créé (admin@nuitinfo.com / admin123)")
        else:
            print("✅ Compte admin existe déjà")

        # 2. Créer les thèmes s'ils n'existent pas
        themes_data = [
            {'name': 'Océans et climat', 'description': 'Impact des océans sur le climat mondial'},
            {'name': 'Biodiversité marine', 'description': 'Diversité de la vie dans les océans'},
            {'name': 'Pollution océanique', 'description': 'Pollutions et leurs impacts'},
            {'name': 'Ressources marines', 'description': 'Exploitation des ressources océaniques'},
            {'name': 'Océanographie', 'description': 'Science des océans'},
            {'name': 'Logiciels libres', 'description': 'Open source et numérique responsable'}
        ]

        if Theme.query.count() == 0:
            print("🔧 Création des thèmes...")
            for theme_data in themes_data:
                theme = Theme(**theme_data)
                db.session.add(theme)
            db.session.commit()
            print(f"✅ {len(themes_data)} thèmes créés")
        else:
            print(f"✅ {Theme.query.count()} thèmes existent déjà")

        # 3. Créer des questions d'exemple s'il n'y en a pas
        if Question.query.count() == 0:
            print("🔧 Création de questions d'exemple...")

            # Récupérer les thèmes
            ocean_climat = Theme.query.filter_by(name='Océans et climat').first()
            biodiv = Theme.query.filter_by(name='Biodiversité marine').first()
            pollution = Theme.query.filter_by(name='Pollution océanique').first()
            logiciels = Theme.query.filter_by(name='Logiciels libres').first()

            questions_exemples = [
                # Questions faciles - Océans et climat
                {
                    'theme': ocean_climat,
                    'difficulty': 'facile',
                    'question_type': 'multiple_choice',
                    'question_text': "Quel pourcentage de l'oxygène de la Terre est produit par les océans ?",
                    'choices': [
                        {'text': '10%', 'is_correct': False, 'order': 'A'},
                        {'text': '30%', 'is_correct': False, 'order': 'B'},
                        {'text': '50%', 'is_correct': True, 'order': 'C'},
                        {'text': '70%', 'is_correct': False, 'order': 'D'}
                    ]
                },
                {
                    'theme': ocean_climat,
                    'difficulty': 'facile',
                    'question_type': 'multiple_choice',
                    'question_text': "Quelle est la principale cause du réchauffement des océans ?",
                    'choices': [
                        {'text': 'Les volcans sous-marins', 'is_correct': False, 'order': 'A'},
                        {'text': 'Les émissions de CO2', 'is_correct': True, 'order': 'B'},
                        {'text': 'La déforestation', 'is_correct': False, 'order': 'C'},
                        {'text': 'La fonte des glaciers', 'is_correct': False, 'order': 'D'}
                    ]
                },

                # Questions faciles - Biodiversité
                {
                    'theme': biodiv,
                    'difficulty': 'facile',
                    'question_type': 'multiple_choice',
                    'question_text': "Quel est le plus grand mammifère marin ?",
                    'choices': [
                        {'text': 'Le requin baleine', 'is_correct': False, 'order': 'A'},
                        {'text': 'La baleine bleue', 'is_correct': True, 'order': 'B'},
                        {'text': "L'orque", 'is_correct': False, 'order': 'C'},
                        {'text': 'Le cachalot', 'is_correct': False, 'order': 'D'}
                    ]
                },
                {
                    'theme': biodiv,
                    'difficulty': 'facile',
                    'question_type': 'multiple_choice',
                    'question_text': "Quel organisme produit la majorité de l'oxygène océanique ?",
                    'choices': [
                        {'text': 'Les algues géantes', 'is_correct': False, 'order': 'A'},
                        {'text': 'Les coraux', 'is_correct': False, 'order': 'B'},
                        {'text': 'Le phytoplancton', 'is_correct': True, 'order': 'C'},
                        {'text': 'Les méduses', 'is_correct': False, 'order': 'D'}
                    ]
                },

                # Questions faciles - Pollution
                {
                    'theme': pollution,
                    'difficulty': 'facile',
                    'question_type': 'multiple_choice',
                    'question_text': "Combien de temps met un sac plastique à se dégrader dans l'océan ?",
                    'choices': [
                        {'text': '10 ans', 'is_correct': False, 'order': 'A'},
                        {'text': '50 ans', 'is_correct': False, 'order': 'B'},
                        {'text': '100 ans', 'is_correct': False, 'order': 'C'},
                        {'text': '400-450 ans', 'is_correct': True, 'order': 'D'}
                    ]
                },

                # Questions faciles - Logiciels libres
                {
                    'theme': logiciels,
                    'difficulty': 'facile',
                    'question_type': 'multiple_choice',
                    'question_text': "Qu'est-ce qu'un logiciel libre ?",
                    'choices': [
                        {'text': 'Un logiciel gratuit', 'is_correct': False, 'order': 'A'},
                        {'text': 'Un logiciel dont le code source est accessible et modifiable', 'is_correct': True, 'order': 'B'},
                        {'text': 'Un logiciel sans licence', 'is_correct': False, 'order': 'C'},
                        {'text': 'Un logiciel pour Linux uniquement', 'is_correct': False, 'order': 'D'}
                    ]
                },
                {
                    'theme': logiciels,
                    'difficulty': 'facile',
                    'question_type': 'multiple_choice',
                    'question_text': "Quel est le système d'exploitation libre le plus connu ?",
                    'choices': [
                        {'text': 'Windows', 'is_correct': False, 'order': 'A'},
                        {'text': 'macOS', 'is_correct': False, 'order': 'B'},
                        {'text': 'Linux', 'is_correct': True, 'order': 'C'},
                        {'text': 'Android', 'is_correct': False, 'order': 'D'}
                    ]
                },

                # Questions moyennes
                {
                    'theme': ocean_climat,
                    'difficulty': 'moyen',
                    'question_type': 'multiple_choice',
                    'question_text': "Quel phénomène climatique est lié aux variations de température dans l'océan Pacifique ?",
                    'choices': [
                        {'text': 'La mousson', 'is_correct': False, 'order': 'A'},
                        {'text': 'El Niño', 'is_correct': True, 'order': 'B'},
                        {'text': 'Le Gulf Stream', 'is_correct': False, 'order': 'C'},
                        {'text': 'La banquise', 'is_correct': False, 'order': 'D'}
                    ]
                },
                {
                    'theme': biodiv,
                    'difficulty': 'moyen',
                    'question_type': 'multiple_choice',
                    'question_text': "À quelle profondeur commence la zone aphoti (sans lumière) ?",
                    'choices': [
                        {'text': '50 mètres', 'is_correct': False, 'order': 'A'},
                        {'text': '200 mètres', 'is_correct': True, 'order': 'B'},
                        {'text': '500 mètres', 'is_correct': False, 'order': 'C'},
                        {'text': '1000 mètres', 'is_correct': False, 'order': 'D'}
                    ]
                },
                {
                    'theme': pollution,
                    'difficulty': 'moyen',
                    'question_type': 'multiple_choice',
                    'question_text': "Quel est le principal composant du 7ème continent de plastique ?",
                    'choices': [
                        {'text': 'Des bouteilles en plastique', 'is_correct': False, 'order': 'A'},
                        {'text': 'Des microplastiques', 'is_correct': True, 'order': 'B'},
                        {'text': 'Des filets de pêche', 'is_correct': False, 'order': 'C'},
                        {'text': 'Des sacs plastiques', 'is_correct': False, 'order': 'D'}
                    ]
                },
                {
                    'theme': logiciels,
                    'difficulty': 'moyen',
                    'question_type': 'multiple_choice',
                    'question_text': "Quelle licence open source permet de créer des logiciels propriétaires dérivés ?",
                    'choices': [
                        {'text': 'GPL', 'is_correct': False, 'order': 'A'},
                        {'text': 'MIT', 'is_correct': True, 'order': 'B'},
                        {'text': 'AGPL', 'is_correct': False, 'order': 'C'},
                        {'text': 'Copyleft', 'is_correct': False, 'order': 'D'}
                    ]
                },

                # Questions difficiles
                {
                    'theme': ocean_climat,
                    'difficulty': 'difficile',
                    'question_type': 'multiple_choice',
                    'question_text': "Quelle est la salinité moyenne des océans ?",
                    'choices': [
                        {'text': '25 g/L', 'is_correct': False, 'order': 'A'},
                        {'text': '30 g/L', 'is_correct': False, 'order': 'B'},
                        {'text': '35 g/L', 'is_correct': True, 'order': 'C'},
                        {'text': '40 g/L', 'is_correct': False, 'order': 'D'}
                    ]
                },
                {
                    'theme': biodiv,
                    'difficulty': 'difficile',
                    'question_type': 'multiple_choice',
                    'question_text': "Combien d'espèces marines sont estimées dans les océans ?",
                    'choices': [
                        {'text': '100 000', 'is_correct': False, 'order': 'A'},
                        {'text': '500 000', 'is_correct': False, 'order': 'B'},
                        {'text': '2 millions', 'is_correct': True, 'order': 'C'},
                        {'text': '10 millions', 'is_correct': False, 'order': 'D'}
                    ]
                },
                {
                    'theme': pollution,
                    'difficulty': 'difficile',
                    'question_type': 'multiple_choice',
                    'question_text': "Quelle quantité de plastique finit dans les océans chaque année ?",
                    'choices': [
                        {'text': '1 million de tonnes', 'is_correct': False, 'order': 'A'},
                        {'text': '5 millions de tonnes', 'is_correct': False, 'order': 'B'},
                        {'text': '8 millions de tonnes', 'is_correct': True, 'order': 'C'},
                        {'text': '15 millions de tonnes', 'is_correct': False, 'order': 'D'}
                    ]
                },
                {
                    'theme': logiciels,
                    'difficulty': 'difficile',
                    'question_type': 'multiple_choice',
                    'question_text': "En quelle année le projet GNU a-t-il été lancé par Richard Stallman ?",
                    'choices': [
                        {'text': '1983', 'is_correct': True, 'order': 'A'},
                        {'text': '1991', 'is_correct': False, 'order': 'B'},
                        {'text': '1985', 'is_correct': False, 'order': 'C'},
                        {'text': '1989', 'is_correct': False, 'order': 'D'}
                    ]
                }
            ]

            # Ajouter les questions
            for q_data in questions_exemples:
                question = Question(
                    theme_id=q_data['theme'].id,
                    difficulty=q_data['difficulty'],
                    question_type=q_data['question_type'],
                    question_text=q_data['question_text']
                )
                db.session.add(question)
                db.session.flush()

                # Ajouter les choix si c'est une question à choix multiples
                if 'choices' in q_data:
                    for choice_data in q_data['choices']:
                        choice = QuestionChoice(
                            question_id=question.id,
                            choice_text=choice_data['text'],
                            is_correct=choice_data['is_correct'],
                            choice_order=choice_data['order']
                        )
                        db.session.add(choice)

            db.session.commit()
            print(f"✅ {len(questions_exemples)} questions créées")
        else:
            print(f"✅ {Question.query.count()} questions existent déjà")

        print("\n🎉 Initialisation de la base de données terminée!\n")
