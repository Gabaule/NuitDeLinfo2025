-- Extension pour UUID
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================
-- Table USERS
-- ============================================
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    pseudo VARCHAR(100) NOT NULL UNIQUE,
    role VARCHAR(20) NOT NULL DEFAULT 'user' CHECK (role IN ('admin', 'user')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_pseudo ON users(pseudo);
CREATE INDEX idx_users_role ON users(role);

COMMENT ON TABLE users IS 'Utilisateurs du système avec authentification et rôles';
COMMENT ON COLUMN users.password_hash IS 'Hash bcrypt du mot de passe (jamais en clair)';

-- ============================================
-- Table THEMES
-- ============================================
CREATE TABLE themes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_themes_active ON themes(is_active);

COMMENT ON TABLE themes IS 'Liste fixe des thèmes de questions';
COMMENT ON COLUMN themes.is_active IS 'Permet de désactiver un thème sans le supprimer';

-- ============================================
-- Table QUESTIONS
-- ============================================
CREATE TABLE questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    theme_id UUID NOT NULL REFERENCES themes(id) ON DELETE RESTRICT,
    question_type VARCHAR(20) NOT NULL CHECK (question_type IN ('multiple_choice', 'text_input')),
    difficulty VARCHAR(20) NOT NULL CHECK (difficulty IN ('facile', 'moyen', 'difficile')),
    question_text TEXT NOT NULL,
    explanation TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_questions_theme ON questions(theme_id);
CREATE INDEX idx_questions_difficulty ON questions(difficulty);
CREATE INDEX idx_questions_type ON questions(question_type);
CREATE INDEX idx_questions_theme_difficulty ON questions(theme_id, difficulty);

COMMENT ON TABLE questions IS 'Questions du QCM avec type et difficulté';
COMMENT ON COLUMN questions.explanation IS 'Explication de la réponse (affichée après le QCM)';

-- ============================================
-- Table QUESTION_CHOICES (pour QCM à choix multiples)
-- ============================================
CREATE TABLE question_choices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    question_id UUID NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
    choice_text TEXT NOT NULL,
    is_correct BOOLEAN NOT NULL DEFAULT false,
    choice_order INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(question_id, choice_order)
);

CREATE INDEX idx_question_choices_question ON question_choices(question_id);

COMMENT ON TABLE question_choices IS 'Choix de réponses pour questions à choix multiples';
COMMENT ON COLUMN question_choices.is_correct IS 'Indique si ce choix est une bonne réponse';

-- ============================================
-- Table QUESTION_TEXT_ANSWERS (pour questions à texte libre)
-- ============================================
CREATE TABLE question_text_answers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    question_id UUID NOT NULL REFERENCES questions(id) ON DELETE CASCADE UNIQUE,
    correct_answer TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_question_text_answers_question ON question_text_answers(question_id);

COMMENT ON TABLE question_text_answers IS 'Réponses correctes pour questions à texte libre';

-- ============================================
-- Table QCM_SESSIONS (tentatives de QCM)
-- ============================================
CREATE TABLE qcm_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    difficulty VARCHAR(20) NOT NULL CHECK (difficulty IN ('facile', 'moyen', 'difficile')),
    total_score INTEGER NOT NULL DEFAULT 0,
    max_possible_score INTEGER NOT NULL DEFAULT 30,
    is_completed BOOLEAN DEFAULT false,
    started_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_qcm_sessions_user ON qcm_sessions(user_id);
CREATE INDEX idx_qcm_sessions_user_completed ON qcm_sessions(user_id, is_completed);
CREATE INDEX idx_qcm_sessions_user_score ON qcm_sessions(user_id, total_score DESC);

COMMENT ON TABLE qcm_sessions IS 'Tentatives de QCM par utilisateur';
COMMENT ON COLUMN qcm_sessions.total_score IS 'Score total obtenu';
COMMENT ON COLUMN qcm_sessions.max_possible_score IS 'Score maximum possible (généralement 30)';

-- ============================================
-- Table QCM_SESSION_QUESTIONS (questions d'une session spécifique)
-- ============================================
CREATE TABLE qcm_session_questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID NOT NULL REFERENCES qcm_sessions(id) ON DELETE CASCADE,
    question_id UUID NOT NULL REFERENCES questions(id) ON DELETE RESTRICT,
    question_order INTEGER NOT NULL,
    question_score INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(session_id, question_order),
    UNIQUE(session_id, question_id)
);

CREATE INDEX idx_qcm_session_questions_session ON qcm_session_questions(session_id);
CREATE INDEX idx_qcm_session_questions_question ON qcm_session_questions(question_id);

COMMENT ON TABLE qcm_session_questions IS 'Questions présentées dans une session de QCM spécifique';
COMMENT ON COLUMN qcm_session_questions.question_order IS 'Ordre de présentation (1 à 30)';
COMMENT ON COLUMN qcm_session_questions.question_score IS 'Score obtenu pour cette question';

-- ============================================
-- Table USER_ANSWERS (réponses données par l'utilisateur)
-- ============================================
CREATE TABLE user_answers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_question_id UUID NOT NULL REFERENCES qcm_session_questions(id) ON DELETE CASCADE,
    choice_id UUID REFERENCES question_choices(id) ON DELETE SET NULL,
    text_answer TEXT,
    is_correct BOOLEAN,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_user_answers_session_question ON user_answers(session_question_id);
CREATE INDEX idx_user_answers_choice ON user_answers(choice_id);

COMMENT ON TABLE user_answers IS 'Réponses données par les utilisateurs';
COMMENT ON COLUMN user_answers.choice_id IS 'Pour QCM multiples (NULL si question texte)';
COMMENT ON COLUMN user_answers.text_answer IS 'Pour questions à texte libre';

-- ============================================
-- Table CHATBOT_CONVERSATIONS
-- ============================================
CREATE TABLE chatbot_conversations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_chatbot_conversations_user ON chatbot_conversations(user_id);
CREATE INDEX idx_chatbot_conversations_updated ON chatbot_conversations(updated_at DESC);

COMMENT ON TABLE chatbot_conversations IS 'Conversations avec le chatbot par utilisateur';

-- ============================================
-- Table CHATBOT_MESSAGES
-- ============================================
CREATE TABLE chatbot_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL REFERENCES chatbot_conversations(id) ON DELETE CASCADE,
    role VARCHAR(20) NOT NULL CHECK (role IN ('user', 'assistant')),
    content TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_chatbot_messages_conversation ON chatbot_messages(conversation_id);
CREATE INDEX idx_chatbot_messages_created ON chatbot_messages(created_at);

COMMENT ON TABLE chatbot_messages IS 'Messages échangés avec le chatbot';
COMMENT ON COLUMN chatbot_messages.role IS 'user (utilisateur) ou assistant (chatbot)';

-- ============================================
-- TRIGGERS pour updated_at automatique
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_questions_updated_at BEFORE UPDATE ON questions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_chatbot_conversations_updated_at BEFORE UPDATE ON chatbot_conversations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- TRIGGER pour mettre à jour chatbot_conversations.updated_at lors d'un nouveau message
-- ============================================
CREATE OR REPLACE FUNCTION update_conversation_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE chatbot_conversations
    SET updated_at = CURRENT_TIMESTAMP
    WHERE id = NEW.conversation_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_conversation_on_message AFTER INSERT ON chatbot_messages
    FOR EACH ROW EXECUTE FUNCTION update_conversation_timestamp();
