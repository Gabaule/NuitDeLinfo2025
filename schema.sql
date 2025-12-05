-- Table USER : stocke les utilisateurs
CREATE TABLE "user" (
    id_user SERIAL PRIMARY KEY,
    pseudo VARCHAR(50) NOT NULL UNIQUE,
    mail VARCHAR(100) NOT NULL UNIQUE,
    mdp VARCHAR(255) NOT NULL,  -- Toujours stocker un hash, jamais le mot de passe en clair !
    date_inscription TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    role VARCHAR(20) CHECK (role IN ('admin', 'participant', 'visiteur'))
);

-- Table QUESTION : stocke les questions du quizz
CREATE TABLE question (
    id_question SERIAL PRIMARY KEY,
    texte TEXT NOT NULL,  -- TEXT pour un "varchar infini"
    difficulte INTEGER CHECK (difficulte BETWEEN 1 AND 5)  -- Ex: 1=facile, 5=difficile
);

-- Table REPONSE : stocke les réponses liées aux questions
CREATE TABLE reponse (
    id_reponse SERIAL PRIMARY KEY,
    texte TEXT NOT NULL,
    est_correcte BOOLEAN NOT NULL DEFAULT FALSE,
    question_id INTEGER NOT NULL,
    FOREIGN KEY (question_id) REFERENCES question(id_question) ON DELETE CASCADE  -- Lien vers QUESTION
);

-- Table RESULTAT_QUIZZ : stocke les scores des utilisateurs
CREATE TABLE resultat_quizz (
    id_resultat SERIAL PRIMARY KEY,
    score INTEGER NOT NULL CHECK (score >= 0),
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_user INTEGER NOT NULL,
    FOREIGN KEY (id_user) REFERENCES "user"(id_user) ON DELETE CASCADE  -- Lien vers USER
);

-- Table ANOMALIE : stocke les anomalies déclenchées par les utilisateurs
CREATE TABLE anomalie (
    id_anomalie SERIAL PRIMARY KEY,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_user INTEGER NOT NULL,
    categorie VARCHAR(50) CHECK (categorie IN ('champstexte_trop_long', 'chatting_error_message', 'erreur_trop_loquace')),
    FOREIGN KEY (id_user) REFERENCES "user"(id_user) ON DELETE CASCADE  -- Lien vers USER
);