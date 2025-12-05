class Config:
    SQLALCHEMY_DATABASE_URI = 'postgresql://admin:password@localhost:5432/TribordNuitInfo2025'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SECRET_KEY = 'Rand0mKey!'  # Utilisée pour sécuriser les sessions Flask
