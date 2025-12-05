class ResultatQuizz(db.Model):
    __tablename__ = 'resultat_quizz'
    id_resultat = db.Column(db.Integer, primary_key=True)
    score = db.Column(db.Integer, nullable=False)
    date = db.Column(db.DateTime, default=datetime.utcnow)
    id_user = db.Column(db.Integer, db.ForeignKey('user.id_user'), nullable=False)

    user = db.relationship('User', backref=db.backref('resultats', lazy=True))

    def __repr__(self):
        return f'<ResultatQuizz {self.id_resultat}, Score: {self.score}>'
