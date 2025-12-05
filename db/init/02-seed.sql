-- ============================================
-- DONNÉES INITIALES
-- ============================================

-- Insertion de l'utilisateur admin par défaut
-- Mot de passe : admin123 (en clair pour simplifier - Nuit de l'Info uniquement)
INSERT INTO users (email, password_hash, pseudo, role) VALUES
('admin@nuitinfo.com', 'admin123', 'admin', 'admin');

-- ============================================
-- INSERTION DES THÈMES FIXES
-- ============================================
INSERT INTO themes (name, description, is_active) VALUES
('Océanographie', 'Questions sur les océans, courants marins, et écosystèmes aquatiques', true),
('Climat', 'Questions sur le changement climatique et la météorologie marine', true),
('Biodiversité marine', 'Questions sur la faune et la flore marine', true),
('Pollution', 'Questions sur la pollution des océans et ses impacts', true),
('Énergies marines', 'Questions sur les énergies renouvelables marines', true),
('Protection des océans', 'Questions sur la conservation et la protection des milieux marins', true);

-- ============================================
-- QUESTIONS EXEMPLES - Océanographie
-- ============================================

-- Question multiple choice FACILE - Océanographie
INSERT INTO questions (theme_id, question_type, difficulty, question_text, explanation)
SELECT id, 'multiple_choice', 'facile',
'Quel pourcentage de la surface de la Terre est couvert par les océans ?',
'Les océans couvrent environ 71% de la surface de la Terre, soit environ 361 millions de km².'
FROM themes WHERE name = 'Océanographie';

-- Récupérer l'ID de la dernière question insérée pour ajouter les choix
DO $$
DECLARE
    question_ocean_id UUID;
BEGIN
    SELECT q.id INTO question_ocean_id
    FROM questions q
    JOIN themes t ON q.theme_id = t.id
    WHERE t.name = 'Océanographie'
    AND q.question_text LIKE 'Quel pourcentage%'
    LIMIT 1;

    INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
    (question_ocean_id, '50%', false, 1),
    (question_ocean_id, '71%', true, 2),
    (question_ocean_id, '85%', false, 3),
    (question_ocean_id, '60%', false, 4);
END $$;

-- Question multiple choice MOYEN - Océanographie
INSERT INTO questions (theme_id, question_type, difficulty, question_text, explanation)
SELECT id, 'multiple_choice', 'moyen',
'Quels sont les principaux courants océaniques ? (plusieurs réponses possibles)',
'Le Gulf Stream, le Kuroshio et le courant circumpolaire antarctique sont parmi les principaux courants océaniques mondiaux.'
FROM themes WHERE name = 'Océanographie';

DO $$
DECLARE
    question_courants_id UUID;
BEGIN
    SELECT q.id INTO question_courants_id
    FROM questions q
    JOIN themes t ON q.theme_id = t.id
    WHERE t.name = 'Océanographie'
    AND q.question_text LIKE 'Quels sont les principaux courants%'
    LIMIT 1;

    INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
    (question_courants_id, 'Gulf Stream', true, 1),
    (question_courants_id, 'Kuroshio', true, 2),
    (question_courants_id, 'Courant circumpolaire antarctique', true, 3),
    (question_courants_id, 'Courant du Mississippi', false, 4);
END $$;

-- Question DIFFICILE - Océanographie
INSERT INTO questions (theme_id, question_type, difficulty, question_text, explanation)
SELECT id, 'multiple_choice', 'difficile',
'Quelle est la profondeur moyenne des océans ?',
'La profondeur moyenne des océans est d''environ 3 800 mètres.'
FROM themes WHERE name = 'Océanographie';

DO $$
DECLARE
    question_profondeur_id UUID;
BEGIN
    SELECT q.id INTO question_profondeur_id
    FROM questions q
    JOIN themes t ON q.theme_id = t.id
    WHERE t.name = 'Océanographie'
    AND q.question_text LIKE 'Quelle est la profondeur moyenne%'
    LIMIT 1;

    INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
    (question_profondeur_id, '1 500 mètres', false, 1),
    (question_profondeur_id, '3 800 mètres', true, 2),
    (question_profondeur_id, '6 000 mètres', false, 3),
    (question_profondeur_id, '10 000 mètres', false, 4);
END $$;

-- ============================================
-- QUESTIONS EXEMPLES - Climat
-- ============================================

-- Question texte FACILE - Climat
INSERT INTO questions (theme_id, question_type, difficulty, question_text, explanation)
SELECT id, 'text_input', 'facile',
'Quel gaz à effet de serre est principalement absorbé par les océans ? (répondre en 3 lettres)',
'Le CO2 (dioxyde de carbone) est le principal gaz à effet de serre absorbé par les océans, ce qui contribue à leur acidification.'
FROM themes WHERE name = 'Climat';

DO $$
DECLARE
    question_co2_id UUID;
BEGIN
    SELECT q.id INTO question_co2_id
    FROM questions q
    JOIN themes t ON q.theme_id = t.id
    WHERE t.name = 'Climat'
    AND q.question_text LIKE 'Quel gaz%'
    LIMIT 1;

    INSERT INTO question_text_answers (question_id, correct_answer) VALUES
    (question_co2_id, 'CO2');
END $$;

-- Question MOYEN - Climat
INSERT INTO questions (theme_id, question_type, difficulty, question_text, explanation)
SELECT id, 'multiple_choice', 'moyen',
'Quel phénomène climatique est causé par le réchauffement des eaux du Pacifique ?',
'El Niño est un phénomène climatique causé par le réchauffement anormal des eaux du Pacifique équatorial.'
FROM themes WHERE name = 'Climat';

DO $$
DECLARE
    question_elnino_id UUID;
BEGIN
    SELECT q.id INTO question_elnino_id
    FROM questions q
    JOIN themes t ON q.theme_id = t.id
    WHERE t.name = 'Climat'
    AND q.question_text LIKE 'Quel phénomène climatique%'
    LIMIT 1;

    INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
    (question_elnino_id, 'El Niño', true, 1),
    (question_elnino_id, 'La Niña', false, 2),
    (question_elnino_id, 'Mousson', false, 3),
    (question_elnino_id, 'Cyclone', false, 4);
END $$;

-- ============================================
-- QUESTIONS EXEMPLES - Biodiversité marine
-- ============================================

-- Question MOYEN - Biodiversité
INSERT INTO questions (theme_id, question_type, difficulty, question_text, explanation)
SELECT id, 'multiple_choice', 'moyen',
'Quels animaux marins sont menacés d''extinction ? (plusieurs réponses possibles)',
'Les tortues marines, les baleines bleues et de nombreuses espèces de requins sont menacés d''extinction.'
FROM themes WHERE name = 'Biodiversité marine';

DO $$
DECLARE
    question_menaces_id UUID;
BEGIN
    SELECT q.id INTO question_menaces_id
    FROM questions q
    JOIN themes t ON q.theme_id = t.id
    WHERE t.name = 'Biodiversité marine'
    AND q.question_text LIKE 'Quels animaux marins%'
    LIMIT 1;

    INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
    (question_menaces_id, 'Tortues marines', true, 1),
    (question_menaces_id, 'Méduses', false, 2),
    (question_menaces_id, 'Baleines bleues', true, 3),
    (question_menaces_id, 'Requins', true, 4);
END $$;

-- Question FACILE - Biodiversité
INSERT INTO questions (theme_id, question_type, difficulty, question_text, explanation)
SELECT id, 'multiple_choice', 'facile',
'Quel est le plus grand animal vivant sur Terre ?',
'La baleine bleue est le plus grand animal ayant jamais existé sur Terre, pouvant atteindre 30 mètres et peser jusqu''à 200 tonnes.'
FROM themes WHERE name = 'Biodiversité marine';

DO $$
DECLARE
    question_baleine_id UUID;
BEGIN
    SELECT q.id INTO question_baleine_id
    FROM questions q
    JOIN themes t ON q.theme_id = t.id
    WHERE t.name = 'Biodiversité marine'
    AND q.question_text LIKE 'Quel est le plus grand animal%'
    LIMIT 1;

    INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
    (question_baleine_id, 'Éléphant', false, 1),
    (question_baleine_id, 'Baleine bleue', true, 2),
    (question_baleine_id, 'Requin baleine', false, 3),
    (question_baleine_id, 'Dinosaure', false, 4);
END $$;

-- ============================================
-- QUESTIONS EXEMPLES - Pollution
-- ============================================

-- Question DIFFICILE - Pollution
INSERT INTO questions (theme_id, question_type, difficulty, question_text, explanation)
SELECT id, 'multiple_choice', 'difficile',
'Quels types de plastiques sont les plus retrouvés dans les océans ? (plusieurs réponses)',
'Le polyéthylène (PE) et le polypropylène (PP) représentent environ 60% des plastiques océaniques.'
FROM themes WHERE name = 'Pollution';

DO $$
DECLARE
    question_plastique_id UUID;
BEGIN
    SELECT q.id INTO question_plastique_id
    FROM questions q
    JOIN themes t ON q.theme_id = t.id
    WHERE t.name = 'Pollution'
    AND q.question_text LIKE 'Quels types de plastiques%'
    LIMIT 1;

    INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
    (question_plastique_id, 'Polyéthylène (PE)', true, 1),
    (question_plastique_id, 'Polystyrène (PS)', false, 2),
    (question_plastique_id, 'Polypropylène (PP)', true, 3),
    (question_plastique_id, 'PVC', false, 4);
END $$;

-- Question texte MOYEN - Pollution
INSERT INTO questions (theme_id, question_type, difficulty, question_text, explanation)
SELECT id, 'text_input', 'moyen',
'Combien de temps met un sac plastique à se décomposer dans l''océan ? (répondre en années)',
'Un sac plastique met environ 400 ans à se décomposer dans l''océan.'
FROM themes WHERE name = 'Pollution';

DO $$
DECLARE
    question_decomposition_id UUID;
BEGIN
    SELECT q.id INTO question_decomposition_id
    FROM questions q
    JOIN themes t ON q.theme_id = t.id
    WHERE t.name = 'Pollution'
    AND q.question_text LIKE 'Combien de temps met%'
    LIMIT 1;

    INSERT INTO question_text_answers (question_id, correct_answer) VALUES
    (question_decomposition_id, '400');
END $$;

-- ============================================
-- QUESTIONS EXEMPLES - Énergies marines
-- ============================================

-- Question FACILE - Énergies marines
INSERT INTO questions (theme_id, question_type, difficulty, question_text, explanation)
SELECT id, 'multiple_choice', 'facile',
'Quelle source d''énergie marine utilise la force des marées ?',
'L''énergie marémotrice exploite la force des marées pour produire de l''électricité.'
FROM themes WHERE name = 'Énergies marines';

DO $$
DECLARE
    question_energie_id UUID;
BEGIN
    SELECT q.id INTO question_energie_id
    FROM questions q
    JOIN themes t ON q.theme_id = t.id
    WHERE t.name = 'Énergies marines'
    AND q.question_text LIKE 'Quelle source d''énergie%'
    LIMIT 1;

    INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
    (question_energie_id, 'Énergie marémotrice', true, 1),
    (question_energie_id, 'Énergie solaire', false, 2),
    (question_energie_id, 'Énergie éolienne', false, 3),
    (question_energie_id, 'Énergie nucléaire', false, 4);
END $$;

-- ============================================
-- QUESTIONS EXEMPLES - Protection des océans
-- ============================================

-- Question MOYEN - Protection
INSERT INTO questions (theme_id, question_type, difficulty, question_text, explanation)
SELECT id, 'multiple_choice', 'moyen',
'Quel pourcentage des océans devrait être protégé selon l''ONU d''ici 2030 ?',
'L''objectif de l''ONU est de protéger 30% des océans d''ici 2030.'
FROM themes WHERE name = 'Protection des océans';

DO $$
DECLARE
    question_protection_id UUID;
BEGIN
    SELECT q.id INTO question_protection_id
    FROM questions q
    JOIN themes t ON q.theme_id = t.id
    WHERE t.name = 'Protection des océans'
    AND q.question_text LIKE 'Quel pourcentage des océans%'
    LIMIT 1;

    INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
    (question_protection_id, '10%', false, 1),
    (question_protection_id, '20%', false, 2),
    (question_protection_id, '30%', true, 3),
    (question_protection_id, '50%', false, 4);
END $$;

-- Question texte FACILE - Protection
INSERT INTO questions (theme_id, question_type, difficulty, question_text, explanation)
SELECT id, 'text_input', 'facile',
'Comment appelle-t-on une zone marine protégée ? (3 lettres)',
'Une AMP (Aire Marine Protégée) est une zone délimitée en mer où la faune et la flore sont protégées.'
FROM themes WHERE name = 'Protection des océans';

DO $$
DECLARE
    question_amp_id UUID;
BEGIN
    SELECT q.id INTO question_amp_id
    FROM questions q
    JOIN themes t ON q.theme_id = t.id
    WHERE t.name = 'Protection des océans'
    AND q.question_text LIKE 'Comment appelle-t-on une zone%'
    LIMIT 1;

    INSERT INTO question_text_answers (question_id, correct_answer) VALUES
    (question_amp_id, 'AMP');
END $$;

-- Message de confirmation
DO $$
BEGIN
    RAISE NOTICE 'Base de données initialisée avec succès !';
    RAISE NOTICE '- 1 utilisateur admin créé (email: admin@nuitinfo.com, password: admin123)';
    RAISE NOTICE '- 6 thèmes créés';
    RAISE NOTICE '- % questions exemples créées', (SELECT COUNT(*) FROM questions);
END $$;
