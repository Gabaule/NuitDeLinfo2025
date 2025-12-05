class Anomalie(db.Model):
    __tablename__ = 'anomalie'
    id_anomalie = db.Column(db.Integer, primary_key=True)
    date = db.Column(db.DateTime, default=datetime.utcnow)
    id_user = db.Column(db.Integer, db.ForeignKey('user.id_user'), nullable=False)
    categorie = db.Column(db.String(50), nullable=False)

    # Les catégories d'anomalie autorisées
    __table_args__ = (
        db.CheckConstraint(categorie.in_(['champstexte_trop_long', 'chatting_error_message', 'erreur_trop_loquace'])),
    )

    user = db.relationship('User', backref=db.backref('anomalies', lazy=True))

    def __repr__(self):
        return f'<Anomalie {self.id_anomalie}, Category: {self.categorie}>'
