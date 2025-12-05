from app import create_app

# Créer l'application avec la configuration par défaut
app = create_app()

if __name__ == '__main__':
    app.run(debug=True, port=5045)
