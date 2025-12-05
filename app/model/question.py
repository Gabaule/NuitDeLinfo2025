import json
import os
from app import db


# -------------------------------------------------------------
# Modèles SQLAlchemy correspondant EXACTEMENT aux tables SQL
# -------------------------------------------------------------

class Question(db.Model):
    __tablename__ = "question"

    id_question = db.Column(db.Integer, primary_key=True)
    texte = db.Column(db.Text, nullable=False)
    difficulte = db.Column(db.Integer, nullable=False)

    # Relation : une question possède plusieurs réponses
    reponses = db.relationship("Reponse", backref="question", cascade="all, delete-orphan")

    def __repr__(self):
        return f"<Question id={self.id_question} diff={self.difficulte}>"


class Reponse(db.Model):
    __tablename__ = "reponse"

    id_reponse = db.Column(db.Integer, primary_key=True)
    texte = db.Column(db.Text, nullable=False)
    est_correcte = db.Column(db.Boolean, default=False)
    question_id = db.Column(db.Integer, db.ForeignKey("question.id_question"), nullable=False)

    def __repr__(self):
        return f"<Reponse Q{self.question_id} correct={self.est_correcte}>"


# -------------------------------------------------------------
# Fonction d'importation depuis les fichiers JSON
# -------------------------------------------------------------

def import_questions_from_json():
    """
    Importation des fichiers JSON de niveaux 1, 2 et 3
    et insertion dans les tables 'question' et 'reponse'.
    """

    base_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "db-init"))

    fichiers = {
        1: "quiz_question_lvl1.json",
        2: "quiz_question_lvl2.json",
        3: "quiz_question_lvl3.json"
    }

    total = 0

    for difficulte, filename in fichiers.items():

        file_path = os.path.join(base_path, filename)

        if not os.path.exists(file_path):
            print(f"⚠️ Fichier JSON introuvable : {file_path}")
            continue

        print(f"📥 Importation : {file_path}")

        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f)

        for q in data.get("questionnaire", []):

            # -----------------------------
            # Insertion dans la table question
            # -----------------------------
            question = Question(
                texte=q["question"],
                difficulte=difficulte
            )
            db.session.add(question)
            db.session.flush()  # récupère question.id_question

            # -----------------------------
            # Insertion des réponses (options)
            # -----------------------------
            bonnes_reponses = q["reponse_correcte"]

            for opt in q["options"]:
                reponse = Reponse(
                    texte=f"{opt['id']}. {opt['text']}",
                    est_correcte=(opt["id"] in bonnes_reponses),
                    question_id=question.id_question
                )
                db.session.add(reponse)

            total += 1

        db.session.commit()

    print(f"🎉 Import terminé : {total} questions ajoutées dans la base.")


__all__ = ["Question", "Reponse", "import_questions_from_json"]