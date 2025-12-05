from app import create_app
from app.model.question import import_questions_from_json

# Créer l'application avec la configuration par défaut
app = create_app()

with app.app_context():
    import_questions_from_json()
    
if __name__ == '__main__':
    app.run(debug=True, port=5045)
