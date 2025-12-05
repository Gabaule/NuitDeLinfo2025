class Reponse(db.Model):
    __tablename__ = 'reponse'
    id_reponse = db.Column(db.Integer, primary_key=True)
    texte = db.Column(db.Text, nullable=False)
    est_correcte = db.Column(db.Boolean, default=False, nullable=False)
    question_id = db.Column(db.Integer, db.ForeignKey('question.id_question'), nullable=False)

    question = db.relationship('Question', backref=db.backref('reponses', lazy=True))

    def __repr__(self):
        return f'<Reponse {self.id_reponse}, Correct: {self.est_correcte}>'
