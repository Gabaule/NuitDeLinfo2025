class Config:
    SQLALCHEMY_DATABASE_URI = 'postgresql://admin:password@localhost:5432/TheNewCantina'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SECRET_KEY = 'Rand0mKey!'  # Utilisée pour sécuriser les sessions Flask
