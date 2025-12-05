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
-- ============================================
-- THÈME : Numérique Responsable
-- ============================================
INSERT INTO themes (id, name, description, is_active) VALUES
('3a867926-6863-4208-a579-0021d6418861', 'Numérique Responsable', 'Questions sur l''impact environnemental et social du numérique, et les bonnes pratiques.', true);

-- Fichier: quiz_question.txt (facile)
-- Found 25 questions in quiz_question.txt
INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('a85a04b5-7ee1-4e24-adec-0a3d42a74f81', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Qu''est-ce qui caractérise principalement un logiciel libre ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('a85a04b5-7ee1-4e24-adec-0a3d42a74f81', 'Il est toujours gratuit.', false, 1),
('a85a04b5-7ee1-4e24-adec-0a3d42a74f81', 'On peut l''utiliser, le modifier et le partager librement.', true, 2),
('a85a04b5-7ee1-4e24-adec-0a3d42a74f81', 'Il est développé par une seule personne.', false, 3),
('a85a04b5-7ee1-4e24-adec-0a3d42a74f81', 'Il ne fonctionne que sur le système d''exploitation Linux.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('aca6a75e-bb7f-4c19-b4e4-b15c3907d0a0', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Parmi les logiciels suivants, lesquels sont des exemples de logiciels libres ou open-source que tu peux utiliser au lycée ?', 'Réponse correcte : B, C, E');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('aca6a75e-bb7f-4c19-b4e4-b15c3907d0a0', 'Microsoft Word', false, 1),
('aca6a75e-bb7f-4c19-b4e4-b15c3907d0a0', 'LibreOffice', true, 2),
('aca6a75e-bb7f-4c19-b4e4-b15c3907d0a0', 'VLC media player', true, 3),
('aca6a75e-bb7f-4c19-b4e4-b15c3907d0a0', 'Adobe Photoshop', false, 4),
('aca6a75e-bb7f-4c19-b4e4-b15c3907d0a0', 'GIMP', true, 5);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('4d5a8603-7541-4cd8-9ab7-a3c2aa0469b2', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Quelle est la principale différence entre un logiciel libre et un ''freeware'' (gratuiciel) ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('4d5a8603-7541-4cd8-9ab7-a3c2aa0469b2', 'Il n''y a aucune différence, les deux sont gratuits.', false, 1),
('4d5a8603-7541-4cd8-9ab7-a3c2aa0469b2', 'Le logiciel libre te donne des libertés comme la modification.', true, 2),
('4d5a8603-7541-4cd8-9ab7-a3c2aa0469b2', 'Les freewares sont plus sécurisés.', false, 3),
('4d5a8603-7541-4cd8-9ab7-a3c2aa0469b2', 'Les logiciels libres n''ont jamais de support technique.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('97cdd09e-b283-4333-a379-790f9af16c8f', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Que signifie l''acronyme GAFAM ?', 'Réponse correcte : A');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('97cdd09e-b283-4333-a379-790f9af16c8f', 'Google, Apple, Facebook, Amazon, Microsoft', true, 1),
('97cdd09e-b283-4333-a379-790f9af16c8f', 'Générateurs Automatisés de Fichiers et d''Applications Modernes', false, 2),
('97cdd09e-b283-4333-a379-790f9af16c8f', 'Global Alliance for Free and Accessible Media', false, 3),
('97cdd09e-b283-4333-a379-790f9af16c8f', 'Google, Adobe, Fujitsu, Apple, Microsoft', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('3e6b6416-9977-4b06-b90b-177a2fc6b9ce', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Pourquoi dit-on que les GAFAM dominent le marché du numérique ?', 'Réponse correcte : B, C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('3e6b6416-9977-4b06-b90b-177a2fc6b9ce', 'Parce qu''ils créent des ordinateurs plus rapides que les autres.', false, 1),
('3e6b6416-9977-4b06-b90b-177a2fc6b9ce', 'Car leurs services sont utilisés par des milliards de personnes.', true, 2),
('3e6b6416-9977-4b06-b90b-177a2fc6b9ce', 'Leurs produits sont conçus pour fonctionner ensemble, ce qui rend difficile d''utiliser des services concurrents.', true, 3),
('3e6b6416-9977-4b06-b90b-177a2fc6b9ce', 'Leurs fondateurs sont les personnes les plus riches du monde.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('b9381408-be0b-4df3-b233-95b8baf87ed8', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Quelles sont les alternatives possibles pour se détacher des services des GAFAM ?', 'Réponse correcte : A, B, C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('b9381408-be0b-4df3-b233-95b8baf87ed8', 'Utiliser le moteur de recherche Qwant ou DuckDuckGo à la place de Google.', true, 1),
('b9381408-be0b-4df3-b233-95b8baf87ed8', 'Utiliser une adresse email chez un fournisseur comme ProtonMail.', true, 2),
('b9381408-be0b-4df3-b233-95b8baf87ed8', 'Utiliser le système d''exploitation Linux sur son ordinateur.', true, 3),
('b9381408-be0b-4df3-b233-95b8baf87ed8', 'Ne plus jamais utiliser Internet.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('93e9b37b-2145-48c3-8735-29c38a19dd24', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'L''association Framasoft propose un projet appelé ''Dégooglisons Internet''. Quel est son but ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('93e9b37b-2145-48c3-8735-29c38a19dd24', 'Prouver que les services de Google sont les meilleurs.', false, 1),
('93e9b37b-2145-48c3-8735-29c38a19dd24', 'Proposer des alternatives libres, éthiques et décentralisées face aux GAFAM.', true, 2),
('93e9b37b-2145-48c3-8735-29c38a19dd24', 'Traduire toutes les pages de Google en français.', false, 3),
('93e9b37b-2145-48c3-8735-29c38a19dd24', 'Créer un nouveau moteur de recherche plus puissant que Google.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('a7ac5415-f369-44da-8c70-052a39c10c1a', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Qu''est-ce que Linux ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('a7ac5415-f369-44da-8c70-052a39c10c1a', 'Un antivirus très puissant.', false, 1),
('a7ac5415-f369-44da-8c70-052a39c10c1a', 'Un système d''exploitation.', true, 2),
('a7ac5415-f369-44da-8c70-052a39c10c1a', 'Un logiciel de traitement de texte.', false, 3),
('a7ac5415-f369-44da-8c70-052a39c10c1a', 'Une marque d''ordinateur.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('cd78840a-9018-45cb-8420-1dbc6dfc6cf4', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Quels sont les avantages de Linux souvent cités ?', 'Réponse correcte : A, B, C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('cd78840a-9018-45cb-8420-1dbc6dfc6cf4', 'Il est gratuit.', true, 1),
('cd78840a-9018-45cb-8420-1dbc6dfc6cf4', 'Il est moins ciblé par les pirates.', true, 2),
('cd78840a-9018-45cb-8420-1dbc6dfc6cf4', 'Il est très personnalisable.', true, 3),
('cd78840a-9018-45cb-8420-1dbc6dfc6cf4', 'Tous les jeux vidéo fonctionnent dessus sans problème.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('35348ce9-a895-4c57-9264-4cab0ada2569', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Qu''est-ce qu''une ''distribution'' Linux ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('35348ce9-a895-4c57-9264-4cab0ada2569', 'C''est un magasin où l''on vend des produits Linux.', false, 1),
('35348ce9-a895-4c57-9264-4cab0ada2569', 'C''est une version de Linux prête à l''emploi.', true, 2),
('35348ce9-a895-4c57-9264-4cab0ada2569', 'C''est la mise à jour annuelle de Linux.', false, 3),
('35348ce9-a895-4c57-9264-4cab0ada2569', 'C''est le nom du code source de Linux.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('a0fd4b8b-977f-4855-8e36-de3eec9c17eb', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Pourquoi Linux est-il souvent utilisé dans le milieu de l''éducation ?', 'Réponse correcte : B, C, D');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('a0fd4b8b-977f-4855-8e36-de3eec9c17eb', 'Parce qu''il est impossible d''aller sur les réseaux sociaux avec.', false, 1),
('a0fd4b8b-977f-4855-8e36-de3eec9c17eb', 'Pour réduire les coûts liés aux licences des logiciels.', true, 2),
('a0fd4b8b-977f-4855-8e36-de3eec9c17eb', 'Pour donner une seconde vie à du matériel informatique ancien.', true, 3),
('a0fd4b8b-977f-4855-8e36-de3eec9c17eb', 'Pour initier les élèves aux technologies ouvertes et au partage.', true, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('06e999f9-3ebf-4676-aa96-7e6c28603e69', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Quelles sont les bonnes pratiques pour protéger ta vie privée sur les réseaux sociaux ?', 'Réponse correcte : C, D');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('06e999f9-3ebf-4676-aa96-7e6c28603e69', 'Accepter toutes les demandes d''amis, même les inconnus.', false, 1),
('06e999f9-3ebf-4676-aa96-7e6c28603e69', 'Mettre son profil en ''public'' pour avoir plus de ''likes''.', false, 2),
('06e999f9-3ebf-4676-aa96-7e6c28603e69', 'Réfléchir avant de publier une photo ou une opinion.', true, 3),
('06e999f9-3ebf-4676-aa96-7e6c28603e69', 'Bien paramétrer ses comptes pour contrôler qui voit ses publications.', true, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('bcbf8e93-ab9d-4427-9142-13690eccb5ce', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Comment créer un mot de passe sécurisé ?', 'Réponse correcte : C, D');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('bcbf8e93-ab9d-4427-9142-13690eccb5ce', 'En utilisant sa date de naissance ou le nom de son animal de compagnie.', false, 1),
('bcbf8e93-ab9d-4427-9142-13690eccb5ce', 'En utilisant le même mot de passe pour tous les sites.', false, 2),
('bcbf8e93-ab9d-4427-9142-13690eccb5ce', 'En mélangeant des lettres, des chiffres et des symboles.', true, 3),
('bcbf8e93-ab9d-4427-9142-13690eccb5ce', 'En utilisant une phrase longue et facile à retenir pour soi, mais difficile à deviner pour les autres.', true, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('570ed51c-e050-4a37-82b1-47272ba7eb62', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Pourquoi est-il conseillé d''utiliser plusieurs adresses e-mail différentes ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('570ed51c-e050-4a37-82b1-47272ba7eb62', 'Pour ne pas recevoir de spam.', false, 1),
('570ed51c-e050-4a37-82b1-47272ba7eb62', 'Pour séparer ses activités (perso, école, jeux, etc.) et limiter les risques en cas de piratage d''un compte.', true, 2),
('570ed51c-e050-4a37-82b1-47272ba7eb62', 'C''est plus cher d''avoir une seule adresse e-mail.', false, 3),
('570ed51c-e050-4a37-82b1-47272ba7eb62', 'Pour avoir l''air plus important.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('e795f6ed-d065-4cab-9e7f-d35dd15aec57', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Une fois qu''une information (photo, commentaire) est publiée sur Internet...', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('e795f6ed-d065-4cab-9e7f-d35dd15aec57', 'On peut la supprimer définitivement en un clic.', false, 1),
('e795f6ed-d065-4cab-9e7f-d35dd15aec57', 'Sa diffusion devient incontrôlable et il est très difficile de la faire disparaître complètement.', true, 2),
('e795f6ed-d065-4cab-9e7f-d35dd15aec57', 'Seuls mes amis peuvent la voir.', false, 3),
('e795f6ed-d065-4cab-9e7f-d35dd15aec57', 'Elle est automatiquement effacée au bout de 24 heures.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('860e58ba-e62f-4532-91f4-551964ab8434', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Qu''est-ce que la démarche NIRD ?', 'Réponse correcte : C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('860e58ba-e62f-4532-91f4-551964ab8434', 'Une nouvelle méthode pour apprendre à coder plus vite.', false, 1),
('860e58ba-e62f-4532-91f4-551964ab8434', 'Une façon de construire des ordinateurs écologiques.', false, 2),
('860e58ba-e62f-4532-91f4-551964ab8434', 'Une démarche pour un Numérique Inclusif, Responsable et Durable.', true, 3),
('860e58ba-e62f-4532-91f4-551964ab8434', 'Un réseau social réservé aux lycéens.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('93d89134-6430-48c7-a810-edc1c1b3da49', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Quels sont les objectifs de l''axe ''Inclusif'' de la démarche NIRD ?', 'Réponse correcte : B, C, D');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('93d89134-6430-48c7-a810-edc1c1b3da49', 'Vendre des ordinateurs neufs à tous les élèves.', false, 1),
('93d89134-6430-48c7-a810-edc1c1b3da49', 'Lutter contre la fracture numérique en fournissant du matériel reconditionné à ceux qui n''en ont pas.', true, 2),
('93d89134-6430-48c7-a810-edc1c1b3da49', 'Rendre Internet accessible à tous, y compris les personnes en situation de handicap.', true, 3),
('93d89134-6430-48c7-a810-edc1c1b3da49', 'S''assurer que chaque élève est un citoyen numérique acteur et pas seulement un consommateur.', true, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('07e7588d-b6df-4162-afd5-d6c7d1ea0a1e', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'L''axe ''Responsable'' de la démarche NIRD encourage à...', 'Réponse correcte : B, C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('07e7588d-b6df-4162-afd5-d6c7d1ea0a1e', 'Utiliser principalement les logiciels des GAFAM car ils sont plus performants.', false, 1),
('07e7588d-b6df-4162-afd5-d6c7d1ea0a1e', 'Sortir de la dépendance aux géants du numérique en privilégiant les logiciels libres.', true, 2),
('07e7588d-b6df-4162-afd5-d6c7d1ea0a1e', 'Promouvoir l''autonomie et l''esprit critique face au numérique.', true, 3),
('07e7588d-b6df-4162-afd5-d6c7d1ea0a1e', 'Ne jamais mettre à jour ses logiciels pour économiser de l''énergie.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('dedfbf6e-fb48-44b6-a457-82f136711ba9', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Comment la démarche NIRD aborde-t-elle l''aspect ''Durable'' ?', 'Réponse correcte : B, C, D');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('dedfbf6e-fb48-44b6-a457-82f136711ba9', 'En changeant d''ordinateur et de smartphone tous les ans pour avoir le matériel le plus récent.', false, 1),
('dedfbf6e-fb48-44b6-a457-82f136711ba9', 'En prolongeant la durée de vie des équipements informatiques.', true, 2),
('dedfbf6e-fb48-44b6-a457-82f136711ba9', 'En favorisant la réparation et le reconditionnement du matériel.', true, 3),
('dedfbf6e-fb48-44b6-a457-82f136711ba9', 'En sensibilisant à l''impact environnemental du numérique.', true, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('b49a7479-224a-450e-84b8-b1b7b1dd65a4', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Quel geste simple contribue à un numérique plus responsable ?', 'Réponse correcte : C, D');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('b49a7479-224a-450e-84b8-b1b7b1dd65a4', 'Laisser son ordinateur allumé 24h/24.', false, 1),
('b49a7479-224a-450e-84b8-b1b7b1dd65a4', 'Regarder des vidéos en streaming en très haute définition en permanence.', false, 2),
('b49a7479-224a-450e-84b8-b1b7b1dd65a4', 'Trier et supprimer régulièrement ses e-mails et fichiers inutiles.', true, 3),
('b49a7479-224a-450e-84b8-b1b7b1dd65a4', 'Utiliser un moteur de recherche éco-responsable.', true, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('aa61a98e-835c-48b7-9a81-13811d158753', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Le terme ''Open Source'' est-il un synonyme exact de ''Logiciel Libre'' ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('aa61a98e-835c-48b7-9a81-13811d158753', 'Oui, c''est exactement la même chose.', false, 1),
('aa61a98e-835c-48b7-9a81-13811d158753', 'Non, ''Logiciel Libre'' est un mouvement social qui met l''accent sur les libertés des utilisateurs, tandis que l''Open Source se concentre plus sur les avantages de sa méthode de développement.', true, 2),
('aa61a98e-835c-48b7-9a81-13811d158753', 'Non, les logiciels Open Source sont toujours payants, contrairement aux logiciels libres.', false, 3);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('970941e0-89bb-4106-abb3-dc1d19a5c0f8', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Quel est le principal modèle économique des GAFAM qui pose question pour la vie privée ?', 'Réponse correcte : C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('970941e0-89bb-4106-abb3-dc1d19a5c0f8', 'La vente d''ordinateurs et de téléphones.', false, 1),
('970941e0-89bb-4106-abb3-dc1d19a5c0f8', 'Les abonnements payants à leurs services.', false, 2),
('970941e0-89bb-4106-abb3-dc1d19a5c0f8', 'L''exploitation des données personnelles des utilisateurs, notamment pour la publicité ciblée.', true, 3),
('970941e0-89bb-4106-abb3-dc1d19a5c0f8', 'La facturation de l''accès à Internet.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('44605fdd-7af2-43f2-8ece-c066f8cf0f97', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Installer Linux sur un vieil ordinateur est une bonne idée car...', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('44605fdd-7af2-43f2-8ece-c066f8cf0f97', 'Cela le transforme en ordinateur de la marque Apple.', false, 1),
('44605fdd-7af2-43f2-8ece-c066f8cf0f97', 'Certaines distributions Linux sont ''légères'' et fonctionnent bien sur des machines peu puissantes.', true, 2),
('44605fdd-7af2-43f2-8ece-c066f8cf0f97', 'C''est la seule façon de le revendre à un bon prix.', false, 3),
('44605fdd-7af2-43f2-8ece-c066f8cf0f97', 'Cela installe automatiquement tous les logiciels Windows.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('3caeaba5-3607-4ed6-92af-90fcc8c6ca9c', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Qu''est-ce que l''e-réputation (ou réputation en ligne) ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('3caeaba5-3607-4ed6-92af-90fcc8c6ca9c', 'Le nombre d''amis que tu as sur les réseaux sociaux.', false, 1),
('3caeaba5-3607-4ed6-92af-90fcc8c6ca9c', 'L''image de toi qui se forme à partir de tout ce qui te concerne en ligne (publications, photos, commentaires...).', true, 2),
('3caeaba5-3607-4ed6-92af-90fcc8c6ca9c', 'Ton score dans les jeux vidéo en ligne.', false, 3),
('3caeaba5-3607-4ed6-92af-90fcc8c6ca9c', 'La vitesse de ta connexion Internet.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('d0d2aa85-c91a-44c6-8869-c826ea21952a', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Dans le cadre d''un numérique durable, pourquoi est-il important de faire durer ses équipements (smartphone, ordinateur) le plus longtemps possible ?', 'Réponse correcte : C, D');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('d0d2aa85-c91a-44c6-8869-c826ea21952a', 'Pour ne pas avoir à apprendre à se servir d''un nouvel appareil.', false, 1),
('d0d2aa85-c91a-44c6-8869-c826ea21952a', 'Parce que les nouveaux modèles sont toujours moins bien.', false, 2),
('d0d2aa85-c91a-44c6-8869-c826ea21952a', 'Car la fabrication des équipements neufs est la phase qui pollue le plus et consomme le plus de ressources.', true, 3),
('d0d2aa85-c91a-44c6-8869-c826ea21952a', 'Pour faire des économies.', true, 4);

-- Fichier: quiz_question2.txt (facile)
-- Found 25 questions in quiz_question2.txt
INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('5abb2582-ce67-4271-a3b4-b49822c633a3', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Qu''est-ce que le ''code source'' d''un logiciel ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('5abb2582-ce67-4271-a3b4-b49822c633a3', 'Le nom du créateur du logiciel.', false, 1),
('5abb2582-ce67-4271-a3b4-b49822c633a3', 'L''ensemble des instructions écrites par les programmeurs.', true, 2),
('5abb2582-ce67-4271-a3b4-b49822c633a3', 'La clé d''activation nécessaire pour installer le logiciel.', false, 3),
('5abb2582-ce67-4271-a3b4-b49822c633a3', 'Un code secret pour débloquer des fonctionnalités.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('77bc89e7-ae68-48ad-b7b7-7ddcf5a2e4e7', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Parmi ces navigateurs web, lesquels sont open-source ?', 'Réponse correcte : A, D');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('77bc89e7-ae68-48ad-b7b7-7ddcf5a2e4e7', 'Mozilla Firefox', true, 1),
('77bc89e7-ae68-48ad-b7b7-7ddcf5a2e4e7', 'Google Chrome', false, 2),
('77bc89e7-ae68-48ad-b7b7-7ddcf5a2e4e7', 'Microsoft Edge', false, 3),
('77bc89e7-ae68-48ad-b7b7-7ddcf5a2e4e7', 'Chromium', true, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('fe099a56-4d58-4d80-a2e0-b5d2ad5373fb', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Qui est une figure emblématique du mouvement du logiciel libre, initiateur du projet GNU ?', 'Réponse correcte : C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('fe099a56-4d58-4d80-a2e0-b5d2ad5373fb', 'Bill Gates', false, 1),
('fe099a56-4d58-4d80-a2e0-b5d2ad5373fb', 'Steve Jobs', false, 2),
('fe099a56-4d58-4d80-a2e0-b5d2ad5373fb', 'Richard Stallman', true, 3),
('fe099a56-4d58-4d80-a2e0-b5d2ad5373fb', 'Mark Zuckerberg', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('cba6cd94-f689-4e0f-b685-b98291fae9f7', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Quel est l''avantage pour une communauté de pouvoir accéder au code source d''un logiciel ?', 'Réponse correcte : A, C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('cba6cd94-f689-4e0f-b685-b98291fae9f7', 'Cela permet de vérifier qu''il ne contient pas de fonction cachée qui t''espionne.', true, 1),
('cba6cd94-f689-4e0f-b685-b98291fae9f7', 'Cela permet qu''aucune personne ne peut le copier ni le télécharger.', false, 2),
('cba6cd94-f689-4e0f-b685-b98291fae9f7', 'Cela permet à n''importe qui de l''améliorer ou de corriger des bugs.', true, 3),
('cba6cd94-f689-4e0f-b685-b98291fae9f7', 'Cela permet de le rendre compatible avec tous les ordinateurs.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('b986d988-6174-46dc-bc83-84cb2f53c51b', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'L''expression ''Si c''est gratuit, c''est que vous êtes le produit'' s''applique souvent aux services des GAFAM. Qu''est-ce que cela signifie ?', 'Réponse correcte : D');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('b986d988-6174-46dc-bc83-84cb2f53c51b', 'Les services sont souvent selon les experts de très mauvaise qualité.', false, 1),
('b986d988-6174-46dc-bc83-84cb2f53c51b', 'Les utilisateurs sont obligés de regarder beaucoup de publicités pour pouvoir utiliser le service.', false, 2),
('b986d988-6174-46dc-bc83-84cb2f53c51b', 'Les entreprises ont tendance à introduire des frais cachés à régler plus tard.', false, 3),
('b986d988-6174-46dc-bc83-84cb2f53c51b', 'Les entreprises gagnent de l''argent en vendant tes données personnelles à des publicitaires.', true, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('4dac6626-0a44-42f6-91a9-4a9305856b81', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Qu''est-ce qu''un ''écosystème numérique'' créé par un GAFAM ?', 'Réponse correcte : C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('4dac6626-0a44-42f6-91a9-4a9305856b81', 'Un groupe de discussion sur l''environnement rassemblant des programmeurs, des spécialites de la transition numérique et des utilisateurs.', false, 1),
('4dac6626-0a44-42f6-91a9-4a9305856b81', 'Un service d''après vente conçu pour recycler les vieux appareils électroniques et de les rendre de nouveau fonctionnels.', false, 2),
('4dac6626-0a44-42f6-91a9-4a9305856b81', 'Un ensemble de services et de produits (email, cloud, smartphone, etc.) conçus pour fonctionner parfaitement ensemble et te garder captif.', true, 3),
('4dac6626-0a44-42f6-91a9-4a9305856b81', 'Une méthodologie propre à l''entreprise pour permettre les communications entre utilisateurs de plusieurs continents.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('527ffe88-d5d5-4da4-8bcc-7bba02d242c6', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Pour stocker tes fichiers en ligne, quelles sont les alternatives libres à Google Drive ou Microsoft OneDrive ?', 'Réponse correcte : A, C, D');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('527ffe88-d5d5-4da4-8bcc-7bba02d242c6', 'Nextcloud', true, 1),
('527ffe88-d5d5-4da4-8bcc-7bba02d242c6', 'Dropbox', false, 2),
('527ffe88-d5d5-4da4-8bcc-7bba02d242c6', 'KDrive', true, 3),
('527ffe88-d5d5-4da4-8bcc-7bba02d242c6', 'Cozy Drive', true, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('c62d5dfa-f974-4173-9f03-9bb23a9b61d6', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Qu''est-ce qu''un réseau social ''fédéré'' comme Mastodon, alternative à Twitter (X) ?', 'Réponse correcte : A');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('c62d5dfa-f974-4173-9f03-9bb23a9b61d6', 'Un réseau composé de multiples serveurs indépendants qui peuvent communiquer entre eux.', true, 1),
('c62d5dfa-f974-4173-9f03-9bb23a9b61d6', 'Un réseau social où toutes les données sont stockées au même endroit pour plus de sécurité.', false, 2),
('c62d5dfa-f974-4173-9f03-9bb23a9b61d6', 'Un réseau social géré par le gouvernement.', false, 3),
('c62d5dfa-f974-4173-9f03-9bb23a9b61d6', 'Un réseau social payant et sans publicité.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('6a90ec6c-5ed9-4380-bacb-9a6f662a1c57', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Qui a créé le noyau (le cœur) de Linux ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('6a90ec6c-5ed9-4380-bacb-9a6f662a1c57', 'Bill Gates', false, 1),
('6a90ec6c-5ed9-4380-bacb-9a6f662a1c57', 'Linus Torvalds', true, 2),
('6a90ec6c-5ed9-4380-bacb-9a6f662a1c57', 'L''armée américaine', false, 3),
('6a90ec6c-5ed9-4380-bacb-9a6f662a1c57', 'Richard Stallman', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('dc78356c-a6c3-4011-8664-4c2aeec45284', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Quelle est la mascotte officielle de Linux ?', 'Réponse correcte : D');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('dc78356c-a6c3-4011-8664-4c2aeec45284', 'Un renard nommé Foxy', false, 1),
('dc78356c-a6c3-4011-8664-4c2aeec45284', 'Un fantôme nommé Boux', false, 2),
('dc78356c-a6c3-4011-8664-4c2aeec45284', 'Un robot nommé Linus', false, 3),
('dc78356c-a6c3-4011-8664-4c2aeec45284', 'Un manchot nommé Tux', true, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('8748c101-ad73-4ade-b931-1168f5195582', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Pourquoi Linux est-il massivement utilisé pour faire fonctionner les serveurs web dans le monde ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('8748c101-ad73-4ade-b931-1168f5195582', 'Parce qu''il est le seul système d''exploitation capable de se connecter à Internet.', false, 1),
('8748c101-ad73-4ade-b931-1168f5195582', 'Pour sa stabilité, sa sécurité et sa gratuité.', true, 2),
('8748c101-ad73-4ade-b931-1168f5195582', 'Parce qu''il est plus joli que Windows.', false, 3),
('8748c101-ad73-4ade-b931-1168f5195582', 'Parce qu''il a été créé spécialement pour ça.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('04457013-8598-48dd-8580-8286095c0951', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Sur Linux, qu''est-ce qu''un ''environnement de bureau'' ?', 'Réponse correcte : C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('04457013-8598-48dd-8580-8286095c0951', 'Le nom de l''écran de l''ordinateur.', false, 1),
('04457013-8598-48dd-8580-8286095c0951', 'Un logiciel pour organiser tes fournitures scolaires.', false, 2),
('04457013-8598-48dd-8580-8286095c0951', 'L''interface graphique (menus, icônes, fenêtres) que tu utilises.', true, 3),
('04457013-8598-48dd-8580-8286095c0951', 'Le fond d''écran par défaut.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('8f935584-0c72-49ba-a435-2a21e12a3717', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Qu''est-ce qu''un ''cookie'' sur un site internet ?', 'Réponse correcte : C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('8f935584-0c72-49ba-a435-2a21e12a3717', 'Un petit cadeau virtuel offert quand tu visites un site pour la première fois.', false, 1),
('8f935584-0c72-49ba-a435-2a21e12a3717', 'Un virus qui ralentit ta connexion et qui demande à effacer régulièrement les données de son navigateur.', false, 2),
('8f935584-0c72-49ba-a435-2a21e12a3717', 'Un petit fichier texte stocké sur ton ordinateur qui peut servir à te reconnaître et à te suivre sur internet.', true, 3),
('8f935584-0c72-49ba-a435-2a21e12a3717', 'Le score de popularité d''un site web.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('aa60b151-80c9-464c-b36b-daeda06d2879', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Qu''est-ce que le ''hameçonnage'' (phishing) ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('aa60b151-80c9-464c-b36b-daeda06d2879', 'Une technique pour pêcher des poissons rares grâce à internet.', false, 1),
('aa60b151-80c9-464c-b36b-daeda06d2879', 'Une technique de vol d''informations où un pirate imite une entreprise.', true, 2),
('aa60b151-80c9-464c-b36b-daeda06d2879', 'Le ciblage de personnes par les entreprises et leurs suivis par des hameçons numériquessss.', false, 3),
('aa60b151-80c9-464c-b36b-daeda06d2879', 'Un moyen de sécuriser sa boite mail.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('8596d32d-4eec-4b81-9fc6-cff78e42f057', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'À quoi sert un VPN (Réseau Privé Virtuel) ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('8596d32d-4eec-4b81-9fc6-cff78e42f057', 'À augmenter la vitesse de ta connexion internet.', false, 1),
('8596d32d-4eec-4b81-9fc6-cff78e42f057', 'À chiffrer ta connexion internet pour la rendre plus sécurisée.', true, 2),
('8596d32d-4eec-4b81-9fc6-cff78e42f057', 'À installer des jeux gratuitement.', false, 3),
('8596d32d-4eec-4b81-9fc6-cff78e42f057', 'À nettoyer les virus de ton ordinateur.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('b1e48bc6-00d7-4098-9d30-4b29b80ae68a', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'L''authentification à deux facteurs (2FA) est une mesure de sécurité qui consiste à...', 'Réponse correcte : C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('b1e48bc6-00d7-4098-9d30-4b29b80ae68a', 'Utiliser deux mots de passe différents pour le même compte.', false, 1),
('b1e48bc6-00d7-4098-9d30-4b29b80ae68a', 'Valider ta connexion avec deux appareils différents.', false, 2),
('b1e48bc6-00d7-4098-9d30-4b29b80ae68a', 'Confirmer ton identité via deux moyens différents.', true, 3),
('b1e48bc6-00d7-4098-9d30-4b29b80ae68a', 'Changer son mot de passe deux fois par an.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('961da8b6-13e5-44b3-b5b9-1753441a3dec', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Dans la démarche NIRD, que signifie le concept de ''sobriété numérique'' ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('961da8b6-13e5-44b3-b5b9-1753441a3dec', 'Ne plus jamais utiliser d''appareils numériques.', false, 1),
('961da8b6-13e5-44b3-b5b9-1753441a3dec', 'Utiliser le numérique de manière plus modérée et réfléchie pour en réduire l''impact environnemental et social.', true, 2),
('961da8b6-13e5-44b3-b5b9-1753441a3dec', 'Acheter uniquement des appareils numériques de couleur sobre (noir, gris).', false, 3),
('961da8b6-13e5-44b3-b5b9-1753441a3dec', 'Ne naviguer sur internet qu''une heure par jour.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('c3cd24b8-5487-49ba-8208-a73359ffa3ac', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'En quoi l''utilisation de matériel informatique reconditionné s''inscrit-elle dans l''axe ''Durable'' de la démarche NIRD ?', 'Réponse correcte : B, C, D');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('c3cd24b8-5487-49ba-8208-a73359ffa3ac', 'Le matériel reconditionné est plus performant que le neuf.', false, 1),
('c3cd24b8-5487-49ba-8208-a73359ffa3ac', 'Cela permet d''allonger la durée de vie des équipements et de réduire la production de déchets électroniques.', true, 2),
('c3cd24b8-5487-49ba-8208-a73359ffa3ac', 'Cela coûte moins cher.', true, 3),
('c3cd24b8-5487-49ba-8208-a73359ffa3ac', 'Cela évite l''épuisement des ressources nécessaires à la fabrication d''appareils neufs.', true, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('e25fc733-6ec1-447d-ba35-8744a1e9f919', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Que cherche à combattre l''axe ''Inclusif'' de la démarche NIRD ?', 'Réponse correcte : B, C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('e25fc733-6ec1-447d-ba35-8744a1e9f919', 'L''utilisation excessive des réseaux sociaux.', false, 1),
('e25fc733-6ec1-447d-ba35-8744a1e9f919', 'L''illettrisme numérique (l''illectronisme), c''est-à-dire la difficulté à utiliser les outils numériques.', true, 2),
('e25fc733-6ec1-447d-ba35-8744a1e9f919', 'La fracture numérique, où certaines personnes n''ont pas accès à internet ou au matériel.', true, 3),
('e25fc733-6ec1-447d-ba35-8744a1e9f919', 'Le piratage informatique.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('47492927-6d1b-49b2-b943-c32be057ae49', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Comment le fait d''apprendre à coder avec des outils open-source comme Python ou Scratch correspond à l''axe ''Responsable'' de la démarche NIRD ?', 'Réponse correcte : A, C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('47492927-6d1b-49b2-b943-c32be057ae49', 'Cela te donne les clés pour comprendre comment fonctionne le numérique, et ne plus être un simple consommateur.', true, 1),
('47492927-6d1b-49b2-b943-c32be057ae49', 'Cela te rend dépendant des grosses entreprises qui créent ces langages.', false, 2),
('47492927-6d1b-49b2-b943-c32be057ae49', 'Cela favorise le partage des connaissances et la collaboration.', true, 3),
('47492927-6d1b-49b2-b943-c32be057ae49', 'Cela garantit que tu auras un bon salaire plus tard.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('93e997d3-20d5-4f70-8af0-6bf14a0396e3', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Qu''est-ce qu''un logiciel ''propriétaire'' ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('93e997d3-20d5-4f70-8af0-6bf14a0396e3', 'Un logiciel qui appartient à l''État.', false, 1),
('93e997d3-20d5-4f70-8af0-6bf14a0396e3', 'Un logiciel dont nous ne pouvons pas partager ni réutiliser librement.', true, 2),
('93e997d3-20d5-4f70-8af0-6bf14a0396e3', 'Un logiciel développé par le propriétaire d''un ordinateur.', false, 3),
('93e997d3-20d5-4f70-8af0-6bf14a0396e3', 'Un logiciel qui n''a pas besoin d''être installé.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('e11faade-3f72-4a95-85d6-870e51b14a75', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Pourquoi l''utilisation d''un Wi-Fi public (gare, aéroport, restaurant) peut-elle être risquée pour tes données personnelles ?', 'Réponse correcte : B, C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('e11faade-3f72-4a95-85d6-870e51b14a75', 'La connexion est souvent très lente.', false, 1),
('e11faade-3f72-4a95-85d6-870e51b14a75', 'Le réseau est souvent peu ou pas sécurisé, ce qui permet à des personnes malintentionnées d''intercepter ce que tu fais.', true, 2),
('e11faade-3f72-4a95-85d6-870e51b14a75', 'Il faut souvent donner son adresse e-mail pour s''y connecter.', true, 3),
('e11faade-3f72-4a95-85d6-870e51b14a75', 'C''est toujours payant.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('4d62ba3f-f920-4827-92eb-f07b2b81816a', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Android, le système d''exploitation de la majorité des smartphones, est basé sur le noyau Linux. Est-ce que cela en fait un système totalement ''libre'' et respectueux de la vie privée ?', 'Réponse correcte : B, C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('4d62ba3f-f920-4827-92eb-f07b2b81816a', 'Oui, comme c''est basé sur Linux, c''est forcément un système ouvert et sûr.', false, 1),
('4d62ba3f-f920-4827-92eb-f07b2b81816a', 'Non, car la version utilisée par les fabricants intègre de nombreux services Google non-libres qui collectent beaucoup de données.', true, 2),
('4d62ba3f-f920-4827-92eb-f07b2b81816a', 'Non, il existe des versions d''Android sans les services Google qui sont plus respectueuses de la vie privée.', true, 3);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('81f9169f-b198-42d0-bb86-0af1361ff441', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Quelle action concrète ton lycée pourrait-il mettre en place pour appliquer la démarche NIRD ?', 'Réponse correcte : B, C, E');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('81f9169f-b198-42d0-bb86-0af1361ff441', 'Remplacer tous les ordinateurs par des modèles neufs chaque année.', false, 1),
('81f9169f-b198-42d0-bb86-0af1361ff441', 'Organiser une collecte de vieux matériel informatique pour le faire reconditionner ou le recycler correctement.', true, 2),
('81f9169f-b198-42d0-bb86-0af1361ff441', 'Installer une distribution Linux sur les ordinateurs des salles informatiques.', true, 3),
('81f9169f-b198-42d0-bb86-0af1361ff441', 'Interdire l''accès à internet pour réduire la consommation d''énergie.', false, 4),
('81f9169f-b198-42d0-bb86-0af1361ff441', 'Proposer des ateliers pour apprendre à mieux protéger ses données personnelles en ligne.', true, 5);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('499709d0-253a-4123-a97d-378e1547e0b1', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'facile', 'Quel est l''impact environnemental principal du visionnage de vidéos en streaming (YouTube, Netflix, etc.) ?', 'Réponse correcte : C, D');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('499709d0-253a-4123-a97d-378e1547e0b1', 'Aucun, car tout est dématérialisé.', false, 1),
('499709d0-253a-4123-a97d-378e1547e0b1', 'L''usure de l''écran de ton appareil.', false, 2),
('499709d0-253a-4123-a97d-378e1547e0b1', 'La consommation d''électricité des centres de données qui distribuent ces vidéos.', true, 3),
('499709d0-253a-4123-a97d-378e1547e0b1', 'Le fait de baisser la qualité vidéo peut réduire cet impact.', true, 4);

-- Fichier: quiz_question2_lvl2.txt (moyen)
-- Found 25 questions in quiz_question2_lvl2.txt
INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('2fb25a37-21e1-4566-9976-a6e9ab7e5124', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Quelle est la principale différence entre une licence open-source ''permissive'' (comme MIT ou Apache) et une licence ''copyleft'' (comme la GNU GPL) ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('2fb25a37-21e1-4566-9976-a6e9ab7e5124', 'Les licences permissives sont payantes, les licences copyleft sont gratuites.', false, 1),
('2fb25a37-21e1-4566-9976-a6e9ab7e5124', 'Les licences copyleft obligent les œuvres dérivées à être publiées sous la même licence.', true, 2),
('2fb25a37-21e1-4566-9976-a6e9ab7e5124', 'Seules les licences permissives autorisent l''utilisation commerciale du code.', false, 3),
('2fb25a37-21e1-4566-9976-a6e9ab7e5124', 'Le copyleft est un terme légal américain, tandis que permissif est européen.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('5fe7adf8-9d81-4412-a1a3-7e0c634f7361', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Qu''est-ce qu''un ''format ouvert'' (par exemple ODT pour le texte ou FLAC pour l''audio) ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('5fe7adf8-9d81-4412-a1a3-7e0c634f7361', 'Un format de fichier qui ne peut être lu que par des logiciels open-source.', false, 1),
('5fe7adf8-9d81-4412-a1a3-7e0c634f7361', 'Un format de fichier dont les spécifications techniques sont publiques et libres de droits.', true, 2),
('5fe7adf8-9d81-4412-a1a3-7e0c634f7361', 'Un format qui n''a pas encore été finalisé et qui est ouvert aux suggestions.', false, 3),
('5fe7adf8-9d81-4412-a1a3-7e0c634f7361', 'Un format qui ne prend pas en charge la protection par mot de passe.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('6c521fa8-76d1-4b73-b928-4b0ca0971aed', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Quel est le rôle principal d''une fondation comme la ''Apache Software Foundation'' ou la ''Linux Foundation'' ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('6c521fa8-76d1-4b73-b928-4b0ca0971aed', 'Vendre des logiciels et des services basés sur des projets open-source.', false, 1),
('6c521fa8-76d1-4b73-b928-4b0ca0971aed', 'Fournir un cadre juridique, organisationnel et financier pour protéger et soutenir l''open-source.', true, 2),
('6c521fa8-76d1-4b73-b928-4b0ca0971aed', 'Développer des systèmes d''exploitation concurrents à Microsoft et Apple.', false, 3),
('6c521fa8-76d1-4b73-b928-4b0ca0971aed', 'Définir les prix des logiciels open-source sur le marché mondial.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('31dd7120-3cbc-45e1-b978-a4d6d34ca339', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Le terme ''écosystème fermé'' ou ''walled garden'' est souvent utilisé pour critiquer les GAFAM. Qu''est-ce que cela signifie ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('31dd7120-3cbc-45e1-b978-a4d6d34ca339', 'Un système où la sécurité est si forte que les virus ne peuvent pas entrer.', false, 1),
('31dd7120-3cbc-45e1-b978-a4d6d34ca339', 'Un environnement technologique où un fournisseur contrôle tout.', true, 2),
('31dd7120-3cbc-45e1-b978-a4d6d34ca339', 'Un réseau social qui n''est accessible que sur invitation.', false, 3),
('31dd7120-3cbc-45e1-b978-a4d6d34ca339', 'Un service cloud qui stocke les données dans un seul pays.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('a6732479-9630-4e80-9d87-d0fc3b9945f6', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Quelle est la finalité principale du ''Digital Markets Act'' (DMA) de l''Union Européenne ?', 'Réponse correcte : D');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('a6732479-9630-4e80-9d87-d0fc3b9945f6', 'Créer une taxe sur tous les produits numériques vendus en Europe.', false, 1),
('a6732479-9630-4e80-9d87-d0fc3b9945f6', 'Interdire l''utilisation des réseaux sociaux pour les moins de 16 ans.', false, 2),
('a6732479-9630-4e80-9d87-d0fc3b9945f6', 'Lutter contre le cyberharcèlement en ligne.', false, 3),
('a6732479-9630-4e80-9d87-d0fc3b9945f6', 'Imposer des règles aux géants du numérique pour garantir une concurrence plus juste et donner plus de choix aux utilisateurs.', true, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('76e5c46f-d30e-4d9a-89d3-05b695149547', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Quelles sont les alternatives ''libres'' et auto-hébergeables à des services comme Google Drive ou Microsoft 365 ?', 'Réponse correcte : B, D');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('76e5c46f-d30e-4d9a-89d3-05b695149547', 'Dropbox', false, 1),
('76e5c46f-d30e-4d9a-89d3-05b695149547', 'Nextcloud', true, 2),
('76e5c46f-d30e-4d9a-89d3-05b695149547', 'iCloud', false, 3),
('76e5c46f-d30e-4d9a-89d3-05b695149547', 'CryptPad', true, 4),
('76e5c46f-d30e-4d9a-89d3-05b695149547', 'WhatsApp', false, 5);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('362c3fe0-134f-4133-a6bd-925bf655caa8', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Qu''est-ce qu''un ''dark pattern'' sur un site web ou une application ?', 'Réponse correcte : C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('362c3fe0-134f-4133-a6bd-925bf655caa8', 'Un mode d''affichage sombre pour économiser la batterie.', false, 1),
('362c3fe0-134f-4133-a6bd-925bf655caa8', 'Une faille de sécurité non divulguée par les développeurs.', false, 2),
('362c3fe0-134f-4133-a6bd-925bf655caa8', 'Une interface utilisateur conçue pour tromper l''utilisateur et lui faire faire des actions qu''il ne souhaitait pas.', true, 3),
('362c3fe0-134f-4133-a6bd-925bf655caa8', 'Un thème graphique utilisé par les hackers.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('781b0666-9324-4e37-83e0-916d68d4b362', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Sous Linux, qu''est-ce qu''un ''environnement de bureau'' (Desktop Environment) ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('781b0666-9324-4e37-83e0-916d68d4b362', 'Le nom de la version du noyau Linux.', false, 1),
('781b0666-9324-4e37-83e0-916d68d4b362', 'L''ensemble de l''interface graphique utilisateur (menus, icônes, fenêtres).', true, 2),
('781b0666-9324-4e37-83e0-916d68d4b362', 'Un logiciel de virtualisation pour exécuter Windows dans Linux.', false, 3),
('781b0666-9324-4e37-83e0-916d68d4b362', 'Le dossier où sont stockés les fichiers de l''utilisateur.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('530d7aa7-c7fc-49c4-b6ce-d5a8cd55b154', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Pourquoi la ligne de commande (terminal) est-elle si importante et puissante sous Linux ?', 'Réponse correcte : B, C, D');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('530d7aa7-c7fc-49c4-b6ce-d5a8cd55b154', 'Parce qu''il n''existe pas d''interface graphique pour la plupart des tâches.', false, 1),
('530d7aa7-c7fc-49c4-b6ce-d5a8cd55b154', 'Elle permet d''automatiser des tâches répétitives via des scripts.', true, 2),
('530d7aa7-c7fc-49c4-b6ce-d5a8cd55b154', 'Elle offre un contrôle plus fin et direct sur le système.', true, 3),
('530d7aa7-c7fc-49c4-b6ce-d5a8cd55b154', 'Elle consomme moins de ressources que les interfaces graphiques.', true, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('409446d1-cfd1-48e1-81b3-2481dab3fee8', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Qu''est-ce qu''un ''gestionnaire de paquets'' (comme APT, DNF ou Pacman) sous Linux ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('409446d1-cfd1-48e1-81b3-2481dab3fee8', 'Un service de livraison de colis pour les produits Linux.', false, 1),
('409446d1-cfd1-48e1-81b3-2481dab3fee8', 'Un outil qui automatise l''installation et la mise à jour de logiciels.', true, 2),
('409446d1-cfd1-48e1-81b3-2481dab3fee8', 'Un logiciel de compression de fichiers, comme WinZip ou 7-Zip.', false, 3),
('409446d1-cfd1-48e1-81b3-2481dab3fee8', 'L''explorateur de fichiers de la distribution.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('daae2912-1a0e-4fd2-820f-93ba9120520c', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Pourquoi une distribution comme Kali Linux est-elle particulièrement utilisée dans le domaine de la cybersécurité ?', 'Réponse correcte : C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('daae2912-1a0e-4fd2-820f-93ba9120520c', 'Car elle est visuellement plus belle que les autres distributions.', false, 1),
('daae2912-1a0e-4fd2-820f-93ba9120520c', 'Car elle est impossible à pirater.', false, 2),
('daae2912-1a0e-4fd2-820f-93ba9120520c', 'Car elle intègre une très grande collection d''outils pour les tests de sécurité.', true, 3),
('daae2912-1a0e-4fd2-820f-93ba9120520c', 'Car elle a été développée par le GIGN.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('2305c805-aa54-41c9-a533-cd18cede59e3', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Qu''est-ce que l''''empreinte digitale du navigateur'' (browser fingerprinting) ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('2305c805-aa54-41c9-a533-cd18cede59e3', 'L''utilisation de son empreinte digitale pour déverrouiller le navigateur.', false, 1),
('2305c805-aa54-41c9-a533-cd18cede59e3', 'Une technique de pistage qui identifie un utilisateur en collectant des informations sur sa configuration.', true, 2),
('2305c805-aa54-41c9-a533-cd18cede59e3', 'Une signature numérique qui prouve que le navigateur est authentique.', false, 3),
('2305c805-aa54-41c9-a533-cd18cede59e3', 'Une mesure de la vitesse de chargement des pages web.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('a36d38e6-037d-4a8e-b7dd-b0643685e5cf', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Quelle est la différence entre l''anonymat et le pseudonymat en ligne ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('a36d38e6-037d-4a8e-b7dd-b0643685e5cf', 'Il n''y a aucune différence, les deux termes sont interchangeables.', false, 1),
('a36d38e6-037d-4a8e-b7dd-b0643685e5cf', 'L''anonymat, c''est ne pas avoir d''identité ; le pseudonymat, c''est avoir une fausse identité.', true, 2),
('a36d38e6-037d-4a8e-b7dd-b0643685e5cf', 'L''anonymat est légal, mais le pseudonymat est illégal.', false, 3),
('a36d38e6-037d-4a8e-b7dd-b0643685e5cf', 'Le pseudonymat ne protège pas du tout la vie privée, contrairement à l''anonymat.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('70d19b2f-0e76-401b-a8ce-ddced0e64930', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Que sont les ''métadonnées'' d''une photo numérique que vous postez en ligne ?', 'Réponse correcte : C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('70d19b2f-0e76-401b-a8ce-ddced0e64930', 'Les pixels qui composent l''image.', false, 1),
('70d19b2f-0e76-401b-a8ce-ddced0e64930', 'Un filigrane invisible pour prouver que vous êtes l''auteur.', false, 2),
('70d19b2f-0e76-401b-a8ce-ddced0e64930', 'Des informations cachées dans le fichier sur l''appareil ou la position.', true, 3),
('70d19b2f-0e76-401b-a8ce-ddced0e64930', 'La description textuelle que vous ajoutez en dessous de la photo.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('fffec537-bfcf-4079-ac9c-cfa96a0a529a', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'En quoi le protocole ''DNS over HTTPS'' (DoH) améliore-t-il la protection de la vie privée ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('fffec537-bfcf-4079-ac9c-cfa96a0a529a', 'Il rend la connexion internet plus rapide.', false, 1),
('fffec537-bfcf-4079-ac9c-cfa96a0a529a', 'Il chiffre les requêtes DNS, empêchant votre fournisseur d''accès à Internet de voir facilement les sites que vous consultez.', true, 2),
('fffec537-bfcf-4079-ac9c-cfa96a0a529a', 'Il bloque automatiquement tous les sites web malveillants.', false, 3),
('fffec537-bfcf-4079-ac9c-cfa96a0a529a', 'Il supprime toutes les publicités des pages web.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('319d0634-8f1d-4a58-b961-ff8c6a869fdc', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Dans la démarche NIRD, à quoi fait référence le concept de ''communs numériques'' ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('319d0634-8f1d-4a58-b961-ff8c6a869fdc', 'Les ordinateurs partagés dans une salle de classe.', false, 1),
('319d0634-8f1d-4a58-b961-ff8c6a869fdc', 'Des ressources numériques gérées et entretenues collectivement par une communauté.', true, 2),
('319d0634-8f1d-4a58-b961-ff8c6a869fdc', 'Une offre internet de base proposée par le gouvernement.', false, 3),
('319d0634-8f1d-4a58-b961-ff8c6a869fdc', 'Les standards de communication comme le Wi-Fi ou le Bluetooth.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('20944d1e-d804-4d01-9887-56def788804c', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Quel est l''un des principaux impacts environnementaux des data centers ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('20944d1e-d804-4d01-9887-56def788804c', 'La pollution sonore pour les riverains.', false, 1),
('20944d1e-d804-4d01-9887-56def788804c', 'La consommation très élevée d''électricité et d''eau.', true, 2),
('20944d1e-d804-4d01-9887-56def788804c', 'La dégradation des sols sur lesquels ils sont construits.', false, 3),
('20944d1e-d804-4d01-9887-56def788804c', 'L''émission d''ondes radio qui perturbent les communications.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('be8e5976-8ced-4b73-b97b-45a14684a782', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'La démarche ''low-tech'' appliquée au numérique durable consiste à...', 'Réponse correcte : C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('be8e5976-8ced-4b73-b97b-45a14684a782', 'Revenir à des technologies d''avant l''invention d''internet.', false, 1),
('be8e5976-8ced-4b73-b97b-45a14684a782', 'Utiliser des ordinateurs moins puissants pour économiser de l''argent.', false, 2),
('be8e5976-8ced-4b73-b97b-45a14684a782', 'Privilégier des technologies plus simples, plus robustes, réparables et moins gourmandes en ressources.', true, 3),
('be8e5976-8ced-4b73-b97b-45a14684a782', 'Concevoir des logiciels avec une interface graphique de basse qualité.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('9a77af82-f857-4f8b-a829-f9d9c5316d1f', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Que signifie rendre un site web ''accessible'' dans le pilier ''Numérique Inclusif'' de la démarche NIRD ?', 'Réponse correcte : C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('9a77af82-f857-4f8b-a829-f9d9c5316d1f', 'Qu''il soit disponible dans toutes les langues.', false, 1),
('9a77af82-f857-4f8b-a829-f9d9c5316d1f', 'Qu''il soit gratuit.', false, 2),
('9a77af82-f857-4f8b-a829-f9d9c5316d1f', 'Qu''il puisse être consulté et utilisé par tous, y compris les personnes en situation de handicap.', true, 3),
('9a77af82-f857-4f8b-a829-f9d9c5316d1f', 'Qu''il soit compatible avec tous les navigateurs web.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('5451f739-523a-43de-a739-f2125d2df62f', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Comment le choix d''un service de streaming vidéo peut-il être lié à un numérique plus responsable ?', 'Réponse correcte : A, B, C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('5451f739-523a-43de-a739-f2125d2df62f', 'En choisissant une plateforme qui finance la plantation d''arbres.', true, 1),
('5451f739-523a-43de-a739-f2125d2df62f', 'En regardant des vidéos uniquement en basse définition pour réduire la consommation de données et d''énergie.', true, 2),
('5451f739-523a-43de-a739-f2125d2df62f', 'En privilégiant des plateformes alternatives et fédérées comme PeerTube qui utilisent le pair-à-pair pour la diffusion.', true, 3),
('5451f739-523a-43de-a739-f2125d2df62f', 'En ne regardant que des documentaires sur l''écologie.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('532e65d3-d7b8-427c-b045-8a7d0ce196ff', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Qui est le créateur initial du noyau Linux ?', 'Réponse correcte : D');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('532e65d3-d7b8-427c-b045-8a7d0ce196ff', 'Richard Stallman', false, 1),
('532e65d3-d7b8-427c-b045-8a7d0ce196ff', 'Bill Gates', false, 2),
('532e65d3-d7b8-427c-b045-8a7d0ce196ff', 'Steve Jobs', false, 3),
('532e65d3-d7b8-427c-b045-8a7d0ce196ff', 'Linus Torvalds', true, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('1c783f71-d425-4cd3-bc9c-0433f880e5df', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Le principe de ''minimisation des données'', inscrit dans le RGPD, implique que...', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('1c783f71-d425-4cd3-bc9c-0433f880e5df', 'Les entreprises doivent compresser les données pour qu''elles prennent moins de place.', false, 1),
('1c783f71-d425-4cd3-bc9c-0433f880e5df', 'Les entreprises ne doivent collecter et traiter que les données personnelles qui sont strictement nécessaires à la finalité de leur service.', true, 2),
('1c783f71-d425-4cd3-bc9c-0433f880e5df', 'Les utilisateurs doivent donner le moins d''informations possibles lors de leur inscription.', false, 3),
('1c783f71-d425-4cd3-bc9c-0433f880e5df', 'Les mots de passe doivent avoir une longueur minimale.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('4dc5adfe-060a-48a5-b84a-27cdf4c8a745', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Lequel de ces services n''appartient PAS à Meta (anciennement Facebook) ?', 'Réponse correcte : C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('4dc5adfe-060a-48a5-b84a-27cdf4c8a745', 'Instagram', false, 1),
('4dc5adfe-060a-48a5-b84a-27cdf4c8a745', 'WhatsApp', false, 2),
('4dc5adfe-060a-48a5-b84a-27cdf4c8a745', 'TikTok', true, 3),
('4dc5adfe-060a-48a5-b84a-27cdf4c8a745', 'Oculus VR', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('960f0894-f7cd-4ae7-a195-15fa0141bbb4', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Parmi ces actions, lesquelles relèvent de la ''sobriété numérique'' ?', 'Réponse correcte : A, C, D');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('960f0894-f7cd-4ae7-a195-15fa0141bbb4', 'Désactiver la lecture automatique des vidéos sur les réseaux sociaux.', true, 1),
('960f0894-f7cd-4ae7-a195-15fa0141bbb4', 'Stocker tous ses fichiers sur plusieurs services cloud ''au cas où''.', false, 2),
('960f0894-f7cd-4ae7-a195-15fa0141bbb4', 'Préférer une connexion filaire (Ethernet) au Wi-Fi lorsque c''est possible.', true, 3),
('960f0894-f7cd-4ae7-a195-15fa0141bbb4', 'Conserver son smartphone le plus longtemps possible et le faire réparer.', true, 4),
('960f0894-f7cd-4ae7-a195-15fa0141bbb4', 'Laisser tous ses onglets de navigateur ouverts en permanence.', false, 5);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('747babd1-d12f-443f-b1b8-c0e6b2bdb04a', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Quel est le modèle animal et le nom de la mascotte officielle de Linux ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('747babd1-d12f-443f-b1b8-c0e6b2bdb04a', 'Un gnou nommé ''Gnu''.', false, 1),
('747babd1-d12f-443f-b1b8-c0e6b2bdb04a', 'Un manchot nommé ''Tux''.', true, 2),
('747babd1-d12f-443f-b1b8-c0e6b2bdb04a', 'Un renard nommé ''Firefox''.', false, 3),
('747babd1-d12f-443f-b1b8-c0e6b2bdb04a', 'Un éléphant nommé ''Hadoop''.', false, 4);

-- Fichier: quiz_question2_lvl3.txt (difficile)
-- Found 25 questions in quiz_question2_lvl3.txt
INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('0c5a7fa4-5a3a-4aa7-a99a-ee9b15ab5e95', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Quelle est la particularité principale de la licence ''Affero General Public License'' (AGPL) par rapport à la licence GPL classique ?', 'Réponse correcte : C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('0c5a7fa4-5a3a-4aa7-a99a-ee9b15ab5e95', 'Elle est plus permissive et autorise l''intégration dans des projets propriétaires.', false, 1),
('0c5a7fa4-5a3a-4aa7-a99a-ee9b15ab5e95', 'Elle a été spécifiquement conçue pour les bibliothèques logicielles et non pour les applications complètes.', false, 2),
('0c5a7fa4-5a3a-4aa7-a99a-ee9b15ab5e95', 'Elle étend l''exigence du copyleft aux logiciels qui sont utilisés via un réseau, obligeant à partager le code source même si le logiciel n''est pas distribué directement à l''utilisateur.', true, 3),
('0c5a7fa4-5a3a-4aa7-a99a-ee9b15ab5e95', 'Elle est la seule licence reconnue par la législation américaine sur le droit d''auteur.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('460fab91-cefb-47b9-8f99-71ecbb2fabfd', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Qu''est-ce qu''un Contributor License Agreement (CLA) dans un projet open-source ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('460fab91-cefb-47b9-8f99-71ecbb2fabfd', 'Un document qui garantit que le contributeur sera rémunéré pour son travail.', false, 1),
('460fab91-cefb-47b9-8f99-71ecbb2fabfd', 'Un accord juridique par lequel un contributeur accorde à l''entité qui gère le projet des droits sur ses contributions, souvent pour permettre un changement de licence futur ou une distribution sous d''autres termes.', true, 2),
('460fab91-cefb-47b9-8f99-71ecbb2fabfd', 'La licence sous laquelle le projet est publié.', false, 3),
('460fab91-cefb-47b9-8f99-71ecbb2fabfd', 'Un simple certificat d''origine du code, similaire au Developer Certificate of Origin (DCO).', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('3b2ff489-8284-4c54-b775-3a2c7f45ebba', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Le modèle économique ''open core'' est souvent utilisé par les entreprises de l''open source. En quoi consiste-t-il ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('3b2ff489-8284-4c54-b775-3a2c7f45ebba', 'À fournir un logiciel entièrement libre, mais en faisant payer le support technique.', false, 1),
('3b2ff489-8284-4c54-b775-3a2c7f45ebba', 'À proposer un ''noyau'' du logiciel en open-source, tout en vendant des fonctionnalités avancées, des extensions ou des versions ''entreprise'' sous une licence propriétaire.', true, 2),
('3b2ff489-8284-4c54-b775-3a2c7f45ebba', 'À développer le logiciel de manière fermée, puis à le publier en open-source une fois qu''il est obsolète.', false, 3),
('3b2ff489-8284-4c54-b775-3a2c7f45ebba', 'À financer le développement exclusivement par des dons de la communauté.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('8df35fd7-e62a-499f-bb77-e5b78d4b5589', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Qu''est-ce qu''un ''data moat'' (fossé de données) dans le contexte de l''avantage concurrentiel des GAFAM ?', 'Réponse correcte : C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('8df35fd7-e62a-499f-bb77-e5b78d4b5589', 'Une technique de chiffrement des données pour les protéger des cyberattaques.', false, 1),
('8df35fd7-e62a-499f-bb77-e5b78d4b5589', 'Une obligation légale de stocker les données sur le territoire national.', false, 2),
('8df35fd7-e62a-499f-bb77-e5b78d4b5589', 'Un avantage concurrentiel difficile à surmonter, créé par la possession d''une quantité massive et exclusive de données utilisateurs, qui permet d''améliorer les services (notamment l''IA) et d''empêcher les nouveaux entrants de rivaliser.', true, 3),
('8df35fd7-e62a-499f-bb77-e5b78d4b5589', 'Une base de données open-source conçue pour être très sécurisée.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('92921bef-cb8d-408b-b0ed-d90d9a48d033', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Quel est le rôle du protocole ActivityPub dans l''écosystème du ''Fediverse'' (Mastodon, PeerTube, etc.) ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('92921bef-cb8d-408b-b0ed-d90d9a48d033', 'C''est un protocole de chiffrement des communications.', false, 1),
('92921bef-cb8d-408b-b0ed-d90d9a48d033', 'C''est un standard du W3C qui permet l''interopérabilité entre différents réseaux sociaux décentralisés, leur permettant de communiquer et d''échanger du contenu entre eux.', true, 2),
('92921bef-cb8d-408b-b0ed-d90d9a48d033', 'C''est un algorithme de modération de contenu.', false, 3),
('92921bef-cb8d-408b-b0ed-d90d9a48d033', 'C''est une cryptomonnaie utilisée pour récompenser les créateurs de contenu.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('e0bc0f89-7e85-4c97-aecb-34227ed5a0c7', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'En quoi l''obligation d''interopérabilité, promue par des régulations comme le DMA, peut-elle réduire la domination des géants du numérique ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('e0bc0f89-7e85-4c97-aecb-34227ed5a0c7', 'En forçant les GAFAM à utiliser les mêmes langages de programmation que leurs concurrents.', false, 1),
('e0bc0f89-7e85-4c97-aecb-34227ed5a0c7', 'En obligeant les services dominants (ex: messageries) à s''ouvrir et à pouvoir communiquer avec des services concurrents plus petits, ce qui réduit l''effet de réseau et facilite le choix pour l''utilisateur.', true, 2),
('e0bc0f89-7e85-4c97-aecb-34227ed5a0c7', 'En standardisant le design de toutes les interfaces utilisateur.', false, 3),
('e0bc0f89-7e85-4c97-aecb-34227ed5a0c7', 'En imposant des tarifs identiques pour tous les services numériques.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('deaf05e4-37f7-4f36-98e8-561974b51a49', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Quelles sont les fonctions principales du ''scheduler'' (ordonnanceur) du noyau Linux ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('deaf05e4-37f7-4f36-98e8-561974b51a49', 'Gérer l''installation et la suppression des paquets logiciels.', false, 1),
('deaf05e4-37f7-4f36-98e8-561974b51a49', 'Allouer le temps processeur (CPU) entre les différents processus et threads qui souhaitent s''exécuter, afin d''assurer la réactivité du système et une répartition équitable des ressources.', true, 2),
('deaf05e4-37f7-4f36-98e8-561974b51a49', 'Organiser les fichiers sur le disque dur.', false, 3),
('deaf05e4-37f7-4f36-98e8-561974b51a49', 'Planifier les tâches de maintenance automatiques comme les sauvegardes.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('211cbe19-6c29-4461-93c1-c41a7e65abb3', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Quelle est la principale différence d''approche entre les modules de sécurité SELinux et AppArmor ?', 'Réponse correcte : A');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('211cbe19-6c29-4461-93c1-c41a7e65abb3', 'SELinux est basé sur l''étiquetage de chaque fichier et processus (label-based), tandis qu''AppArmor est basé sur les chemins de fichiers (path-based), ce qui le rend souvent plus simple à configurer.', true, 1),
('211cbe19-6c29-4461-93c1-c41a7e65abb3', 'SELinux est un antivirus, alors qu''AppArmor est un pare-feu.', false, 2),
('211cbe19-6c29-4461-93c1-c41a7e65abb3', 'AppArmor est développé par la NSA, tandis que SELinux est une initiative communautaire.', false, 3),
('211cbe19-6c29-4461-93c1-c41a7e65abb3', 'SELinux ne fonctionne que sur les distributions Red Hat, AppArmor uniquement sur Debian.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('ae3a34f7-61f2-40c1-ab6d-a9f4f4329ca5', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Quelle est la principale innovation du protocole de serveur d''affichage Wayland par rapport à son prédécesseur X.Org (X11) ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('ae3a34f7-61f2-40c1-ab6d-a9f4f4329ca5', 'Il est entièrement compatible avec les anciennes applications X11 sans aucune couche de traduction.', false, 1),
('ae3a34f7-61f2-40c1-ab6d-a9f4f4329ca5', 'Il simplifie l''architecture en intégrant le compositeur directement dans le serveur d''affichage, visant à améliorer les performances, la sécurité et à éliminer les problèmes de ''tearing'' (déchirure d''image).', true, 2),
('ae3a34f7-61f2-40c1-ab6d-a9f4f4329ca5', 'Il fonctionne uniquement en ligne de commande, sans interface graphique.', false, 3),
('ae3a34f7-61f2-40c1-ab6d-a9f4f4329ca5', 'Il a été conçu exclusivement pour les cartes graphiques NVIDIA.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('1fde6e64-35cb-42d9-924e-a661942d5e5e', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Qu''est-ce qu''un système d''exploitation ''immuable'' comme Fedora Silverblue ou openSUSE MicroOS ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('1fde6e64-35cb-42d9-924e-a661942d5e5e', 'Un système d''exploitation qui ne reçoit jamais de mises à jour.', false, 1),
('1fde6e64-35cb-42d9-924e-a661942d5e5e', 'Un système où le système de fichiers racine est monté en lecture seule pour garantir la stabilité et la prévisibilité, les applications étant principalement installées dans des conteneurs (via Flatpak) ou des surcouches.', true, 2),
('1fde6e64-35cb-42d9-924e-a661942d5e5e', 'Un système d''exploitation conçu pour du matériel informatique qui ne peut pas être modifié.', false, 3),
('1fde6e64-35cb-42d9-924e-a661942d5e5e', 'Une version de Linux qui n''utilise pas le noyau Linux.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('07d5e334-57fa-4b66-8a8b-014772d4214e', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Comment la technique de ''browser fingerprinting'' (empreinte de navigateur) permet-elle de pister un utilisateur sans utiliser de cookies ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('07d5e334-57fa-4b66-8a8b-014772d4214e', 'En accédant à l''historique de navigation de l''utilisateur.', false, 1),
('07d5e334-57fa-4b66-8a8b-014772d4214e', 'En combinant un grand nombre d''informations de configuration du navigateur et du système (polices installées, version du navigateur, plugins, résolution d''écran, etc.) pour créer un identifiant unique et stable.', true, 2),
('07d5e334-57fa-4b66-8a8b-014772d4214e', 'En analysant l''adresse MAC de la carte réseau de l''ordinateur.', false, 3),
('07d5e334-57fa-4b66-8a8b-014772d4214e', 'En utilisant l''adresse IP de l''utilisateur comme identifiant unique.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('98c6f13b-0486-4e13-b9d2-afeeca2be5bc', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Quel est le principe du chiffrement homomorphe, considéré comme une avancée majeure pour la protection de la vie privée dans le cloud ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('98c6f13b-0486-4e13-b9d2-afeeca2be5bc', 'C''est une méthode pour chiffrer les données de manière à ce qu''elles ne puissent être déchiffrées que par l''intelligence artificielle.', false, 1),
('98c6f13b-0486-4e13-b9d2-afeeca2be5bc', 'C''est un type de chiffrement qui permet d''effectuer des calculs sur des données chiffrées sans les déchiffrer au préalable. Le résultat du calcul, une fois déchiffré, est identique à celui qui aurait été obtenu sur les données en clair.', true, 2),
('98c6f13b-0486-4e13-b9d2-afeeca2be5bc', 'C''est une technique qui chiffre les données différemment à chaque fois qu''on y accède.', false, 3),
('98c6f13b-0486-4e13-b9d2-afeeca2be5bc', 'C''est un chiffrement si léger qu''il peut être utilisé sur des objets connectés peu puissants.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('6dc1c748-70c5-434e-911e-d95996287ec0', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Qu''est-ce qu''une ''preuve à divulgation nulle de connaissance'' (Zero-Knowledge Proof - ZKP) ?', 'Réponse correcte : A');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('6dc1c748-70c5-434e-911e-d95996287ec0', 'Un système où un utilisateur peut prouver qu''il détient une information (ex: un mot de passe) sans révéler l''information elle-même.', true, 1),
('6dc1c748-70c5-434e-911e-d95996287ec0', 'Un algorithme qui prouve qu''une base de données ne contient aucune erreur.', false, 2),
('6dc1c748-70c5-434e-911e-d95996287ec0', 'Une méthode pour prouver son identité en utilisant uniquement la biométrie.', false, 3),
('6dc1c748-70c5-434e-911e-d95996287ec0', 'Une preuve mathématique qu''un logiciel est exempt de bugs.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('d1c8364d-3dca-4404-8fd3-57191c080a49', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Quel est le principal enjeu de vie privée lié à l''utilisation du protocole DNS-over-HTTPS (DoH) ?', 'Réponse correcte : C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('d1c8364d-3dca-4404-8fd3-57191c080a49', 'DoH n''est pas chiffré, ce qui rend les requêtes DNS visibles par tout le monde.', false, 1),
('d1c8364d-3dca-4404-8fd3-57191c080a49', 'DoH est moins rapide que le DNS classique, ce qui dégrade l''expérience utilisateur.', false, 2),
('d1c8364d-3dca-4404-8fd3-57191c080a49', 'En chiffrant les requêtes DNS et en les envoyant à des résolveurs centralisés (souvent gérés par des géants comme Google ou Cloudflare), on protège ces requêtes des FAI locaux, mais on centralise une quantité massive d''informations de navigation chez un petit nombre d''acteurs.', true, 3),
('d1c8364d-3dca-4404-8fd3-57191c080a49', 'Le protocole DoH est incompatible avec la plupart des sites web modernes.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('d2e3e977-1382-41be-9538-1005ed33797f', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Qu''est-ce que la ''fatigue du consentement'' (consent fatigue) en lien avec le RGPD ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('d2e3e977-1382-41be-9538-1005ed33797f', 'Un état de lassitude des entreprises face à la complexité du RGPD.', false, 1),
('d2e3e977-1382-41be-9538-1005ed33797f', 'Le phénomène où les utilisateurs, submergés par les demandes de consentement (bannières de cookies, etc.), finissent par cliquer sur ''Accepter tout'' sans lire les options, vidant ainsi le concept de consentement éclairé de sa substance.', true, 2),
('d2e3e977-1382-41be-9538-1005ed33797f', 'L''incapacité technique des sites web à enregistrer le consentement des utilisateurs.', false, 3),
('d2e3e977-1382-41be-9538-1005ed33797f', 'Une disposition du RGPD qui permet de retirer son consentement après un certain temps.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('3f747599-f708-4493-bec9-c286fcc35f3a', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Quelle est la différence fondamentale entre les approches ''Green IT'' (ou ''informatique verte'') et ''IT Sobriety'' (ou ''sobriété numérique'') ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('3f747599-f708-4493-bec9-c286fcc35f3a', 'Il n''y a aucune différence, ce sont des synonymes.', false, 1),
('3f747599-f708-4493-bec9-c286fcc35f3a', 'Le ''Green IT'' cherche à améliorer l''efficacité énergétique du numérique existant (ex: data centers plus efficients), tandis que la ''sobriété numérique'' questionne les usages et vise à réduire le volume global de services et de données produits.', true, 2),
('3f747599-f708-4493-bec9-c286fcc35f3a', '''Green IT'' concerne le matériel, ''sobriété numérique'' concerne le logiciel.', false, 3),
('3f747599-f708-4493-bec9-c286fcc35f3a', 'La ''sobriété numérique'' est une politique gouvernementale, le ''Green IT'' est une initiative d''entreprise.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('1ddbbb05-652f-4dff-a20d-7f0dd81d09c3', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Comment l''obsolescence logicielle (ex: fin du support d''un OS, non-compatibilité avec de nouvelles applications) contribue-t-elle à l''impact environnemental du numérique ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('1ddbbb05-652f-4dff-a20d-7f0dd81d09c3', 'Elle n''a aucun impact, car le logiciel est immatériel.', false, 1),
('1ddbbb05-652f-4dff-a20d-7f0dd81d09c3', 'Elle rend un matériel parfaitement fonctionnel inutilisable ou dangereux, forçant son remplacement prématuré et générant ainsi des déchets électroniques et la consommation de ressources pour la fabrication d''un nouvel appareil.', true, 2),
('1ddbbb05-652f-4dff-a20d-7f0dd81d09c3', 'Elle permet de recycler plus facilement les anciens appareils.', false, 3),
('1ddbbb05-652f-4dff-a20d-7f0dd81d09c3', 'Elle réduit la consommation électrique des appareils, car les logiciels non supportés sont désinstallés.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('fa545199-31a2-4478-bbec-33dd910607ff', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Les Web Content Accessibility Guidelines (WCAG) sont un standard international pour l''accessibilité numérique. Quel en est l''objectif principal ?', 'Réponse correcte : C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('fa545199-31a2-4478-bbec-33dd910607ff', 'Rendre les sites web plus rapides à charger.', false, 1),
('fa545199-31a2-4478-bbec-33dd910607ff', 'Assurer que les sites web sont compatibles avec tous les navigateurs.', false, 2),
('fa545199-31a2-4478-bbec-33dd910607ff', 'Fournir des recommandations pour rendre le contenu web plus accessible aux personnes en situation de handicap (visuel, auditif, moteur, cognitif).', true, 3),
('fa545199-31a2-4478-bbec-33dd910607ff', 'Optimiser le référencement des sites web sur les moteurs de recherche.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('c52379df-6184-433c-90b2-243c2a345dde', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Quel est l''un des principaux défis dans l''évaluation de l''impact environnemental de l''entraînement de grands modèles d''IA (LLM) ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('c52379df-6184-433c-90b2-243c2a345dde', 'L''entraînement de ces modèles ne consomme que très peu d''énergie.', false, 1),
('c52379df-6184-433c-90b2-243c2a345dde', 'Il est difficile de prendre en compte l''ensemble du cycle de vie, incluant la fabrication du matériel (GPU), la consommation électrique massive et l''origine de cette électricité (mix énergétique), et l''inférence (utilisation du modèle).', true, 2),
('c52379df-6184-433c-90b2-243c2a345dde', 'Les entreprises ne communiquent jamais sur la taille de leurs modèles.', false, 3),
('c52379df-6184-433c-90b2-243c2a345dde', 'L''impact est purement logiciel et donc impossible à quantifier.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('d7afdc5e-1edd-4190-831e-11c23901baeb', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'En quoi le concept de ''low-tech'' appliqué au numérique peut-il être une réponse aux enjeux de la démarche NIRD ?', 'Réponse correcte : A');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('d7afdc5e-1edd-4190-831e-11c23901baeb', 'En favorisant des technologies plus simples, plus robustes et réparables, il répond aux objectifs de durabilité (moins de déchets) et d''inclusion (technologies moins chères et plus accessibles).', true, 1),
('d7afdc5e-1edd-4190-831e-11c23901baeb', 'En interdisant l''utilisation d''Internet.', false, 2),
('d7afdc5e-1edd-4190-831e-11c23901baeb', 'En se focalisant uniquement sur les technologies les plus performantes et les plus récentes.', false, 3),
('d7afdc5e-1edd-4190-831e-11c23901baeb', 'En remplaçant tous les ordinateurs par des machines à écrire.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('d5fdaf8c-0280-4d1b-a1e6-a62c5d925ac1', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Qu''est-ce que le ''dual-licensing'' (double licence) comme stratégie commerciale pour un logiciel open-source ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('d5fdaf8c-0280-4d1b-a1e6-a62c5d925ac1', 'Distribuer le logiciel sous deux licences open-source différentes pour laisser le choix à l''utilisateur.', false, 1),
('d5fdaf8c-0280-4d1b-a1e6-a62c5d925ac1', 'Proposer le même logiciel sous une licence libre (souvent copyleft, comme la AGPL) et sous une licence commerciale. Les entreprises qui ne veulent pas être contraintes par la licence libre (ex: intégration dans un produit propriétaire) doivent acheter la licence commerciale.', true, 2),
('d5fdaf8c-0280-4d1b-a1e6-a62c5d925ac1', 'Obliger l''utilisateur à accepter deux licences avant d''installer le logiciel.', false, 3),
('d5fdaf8c-0280-4d1b-a1e6-a62c5d925ac1', 'Une licence qui n''est valable que pour deux installations.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('3880f229-4dd9-48a8-b537-dbd2c71010ce', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Le cas ''États-Unis contre Microsoft'' à la fin des années 1990 portait principalement sur...', 'Réponse correcte : C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('3880f229-4dd9-48a8-b537-dbd2c71010ce', 'La violation de la vie privée des utilisateurs de Windows.', false, 1),
('3880f229-4dd9-48a8-b537-dbd2c71010ce', 'Une faille de sécurité majeure dans le système d''exploitation.', false, 2),
('3880f229-4dd9-48a8-b537-dbd2c71010ce', 'Des pratiques anticoncurrentielles, notamment le fait de lier son navigateur Internet Explorer à son système d''exploitation Windows pour évincer les concurrents comme Netscape.', true, 3),
('3880f229-4dd9-48a8-b537-dbd2c71010ce', 'L''évasion fiscale de l''entreprise.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('b857aa16-eb41-44dd-ac9c-faf6cc5203cc', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Qu''est-ce qu''un ''gestionnaire de paquets'' (ex: APT pour Debian/Ubuntu, YUM/DNF pour Fedora/RHEL) dans un système Linux ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('b857aa16-eb41-44dd-ac9c-faf6cc5203cc', 'Un outil qui compresse les fichiers pour économiser de l''espace disque.', false, 1),
('b857aa16-eb41-44dd-ac9c-faf6cc5203cc', 'Un système qui automatise l''installation, la mise à jour, la configuration et la suppression des logiciels, en gérant les ''dépendances'' (les autres logiciels ou bibliothèques nécessaires).', true, 2),
('b857aa16-eb41-44dd-ac9c-faf6cc5203cc', 'Un pare-feu qui filtre les paquets réseau.', false, 3),
('b857aa16-eb41-44dd-ac9c-faf6cc5203cc', 'L''explorateur de fichiers graphique.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('5d38c2f5-749b-48b1-80e4-5cfd17aba9c4', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'La ''portabilité des données'', un droit garanti par le RGPD, vise à contrer l''enfermement propriétaire en permettant à un utilisateur...', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('5d38c2f5-749b-48b1-80e4-5cfd17aba9c4', 'De supprimer toutes ses données d''un service.', false, 1),
('5d38c2f5-749b-48b1-80e4-5cfd17aba9c4', 'De recevoir les données personnelles qu''il a fournies à un service dans un format structuré, couramment utilisé et lisible par machine, et de les transmettre à un autre service sans obstacle.', true, 2),
('5d38c2f5-749b-48b1-80e4-5cfd17aba9c4', 'D''accéder physiquement aux serveurs où ses données sont stockées.', false, 3),
('5d38c2f5-749b-48b1-80e4-5cfd17aba9c4', 'De rendre ses données publiques et accessibles à tous.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('6fa38dad-a00c-4137-9484-11ae80918860', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Pourquoi la réparation et le reconditionnement sont-ils des piliers essentiels d''un numérique durable (démarche NIRD) ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('6fa38dad-a00c-4137-9484-11ae80918860', 'Parce qu''ils permettent de créer des emplois dans le secteur de la technologie.', false, 1),
('6fa38dad-a00c-4137-9484-11ae80918860', 'Parce qu''ils allongent la durée de vie des équipements, ce qui permet d''amortir leur lourd impact environnemental initial lié à la fabrication et de réduire la génération de déchets électroniques.', true, 2),
('6fa38dad-a00c-4137-9484-11ae80918860', 'Parce que les appareils reconditionnés sont plus performants que les neufs.', false, 3),
('6fa38dad-a00c-4137-9484-11ae80918860', 'Parce que cela force les fabricants à innover davantage.', false, 4);

-- Fichier: quiz_question_lvl2.txt (moyen)
-- Found 25 questions in quiz_question_lvl2.txt
INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('6fe201a2-c42c-4131-9278-56f97872624d', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Quelle est la principale caractéristique d''une licence ''copyleft'' comme la GNU GPL (General Public License) ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('6fe201a2-c42c-4131-9278-56f97872624d', 'Elle permet d''intégrer le code dans un logiciel propriétaire sans aucune restriction.', false, 1),
('6fe201a2-c42c-4131-9278-56f97872624d', 'Elle oblige toute modification ou œuvre dérivée à être distribuée sous les mêmes conditions de liberté.', true, 2),
('6fe201a2-c42c-4131-9278-56f97872624d', 'Elle autorise uniquement l''utilisation non commerciale du logiciel.', false, 3),
('6fe201a2-c42c-4131-9278-56f97872624d', 'Elle a été développée par Apple pour contrer l''open source.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('410a62af-0a30-41a0-9bbd-af076da99cb9', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Parmi ces affirmations, lesquelles distinguent le mouvement du ''Logiciel Libre'' de celui de l''''Open Source'' ?', 'Réponse correcte : A, B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('410a62af-0a30-41a0-9bbd-af076da99cb9', 'Le ''Logiciel Libre'' est une philosophie axée sur les libertés éthiques de l''utilisateur.', true, 1),
('410a62af-0a30-41a0-9bbd-af076da99cb9', 'L''''Open Source'' est une méthodologie de développement qui met en avant les bénéfices pratiques (qualité, sécurité).', true, 2),
('410a62af-0a30-41a0-9bbd-af076da99cb9', 'Les logiciels Open Source ne sont jamais libres.', false, 3),
('410a62af-0a30-41a0-9bbd-af076da99cb9', 'Les logiciels libres sont toujours gratuits, contrairement aux logiciels Open Source.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('ce0d45fc-9097-448e-bb0e-e62581b356b6', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Qu''est-ce qu''un ''fork'' dans le contexte du développement open-source ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('ce0d45fc-9097-448e-bb0e-e62581b356b6', 'Une faille de sécurité majeure dans un logiciel.', false, 1),
('ce0d45fc-9097-448e-bb0e-e62581b356b6', 'La création d''un nouveau projet logiciel indépendant à partir du code source d''un projet existant.', true, 2),
('ce0d45fc-9097-448e-bb0e-e62581b356b6', 'Une fusion de deux projets logiciels concurrents.', false, 3),
('ce0d45fc-9097-448e-bb0e-e62581b356b6', 'La version payante d''un logiciel open-source.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('857045d9-534b-4dfb-acb1-bc1836d62660', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Le concept de ''capitalisme de surveillance'', souvent associé au modèle économique des GAFAM, désigne...', 'Réponse correcte : C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('857045d9-534b-4dfb-acb1-bc1836d62660', 'La surveillance des employés des GAFAM par leurs dirigeants.', false, 1),
('857045d9-534b-4dfb-acb1-bc1836d62660', 'La vente de logiciels antivirus et de systèmes de sécurité.', false, 2),
('857045d9-534b-4dfb-acb1-bc1836d62660', 'Un modèle économique basé sur la collecte et l''analyse massive des données personnelles à des fins de prédiction comportementale et de ciblage publicitaire.', true, 3),
('857045d9-534b-4dfb-acb1-bc1836d62660', 'La surveillance des activités illégales sur internet par les gouvernements.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('7a6e85e4-c47e-4731-86fb-096bbdde53f2', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Quel principe économique explique en partie la domination des GAFAM sur leurs marchés respectifs ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('7a6e85e4-c47e-4731-86fb-096bbdde53f2', 'La loi de l''offre et de la demande.', false, 1),
('7a6e85e4-c47e-4731-86fb-096bbdde53f2', 'L''effet de réseau (plus un service a d''utilisateurs, plus sa valeur augmente, attirant encore plus d''utilisateurs).', true, 2),
('7a6e85e4-c47e-4731-86fb-096bbdde53f2', 'Le principe de l''obsolescence programmée.', false, 3),
('7a6e85e4-c47e-4731-86fb-096bbdde53f2', 'La concurrence pure et parfaite.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('ccdfc9d8-847b-427c-b1c7-5d95c2c6ca5e', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Qu''est-ce que le ''Fediverse'' (ou la ''Fédivers'') ?', 'Réponse correcte : C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('ccdfc9d8-847b-427c-b1c7-5d95c2c6ca5e', 'Un nouveau métavers développé par Meta (Facebook).', false, 1),
('ccdfc9d8-847b-427c-b1c7-5d95c2c6ca5e', 'Le nom du cloud de Google.', false, 2),
('ccdfc9d8-847b-427c-b1c7-5d95c2c6ca5e', 'Un ensemble de réseaux sociaux décentralisés et interopérables, comme Mastodon ou PeerTube, qui ne sont pas contrôlés par une seule entité.', true, 3),
('ccdfc9d8-847b-427c-b1c7-5d95c2c6ca5e', 'Un projet de régulation d''internet par l''Union Européenne.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('588eec1a-fca8-477c-a71a-035193e0e2e6', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Pour se détacher des GAFAM, quelles actions concrètes peut-on entreprendre ?', 'Réponse correcte : B, C, D');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('588eec1a-fca8-477c-a71a-035193e0e2e6', 'Remplacer son smartphone Android par un iPhone.', false, 1),
('588eec1a-fca8-477c-a71a-035193e0e2e6', 'Utiliser un système d''exploitation comme /e/OS, qui est une version de Android sans les services Google.', true, 2),
('588eec1a-fca8-477c-a71a-035193e0e2e6', 'Héberger ses propres services (fichiers, calendrier, etc.) avec des logiciels comme Nextcloud.', true, 3),
('588eec1a-fca8-477c-a71a-035193e0e2e6', 'Privilégier des fournisseurs de services européens respectueux du RGPD (ex: ProtonMail, Infomaniak).', true, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('8f2040a9-4435-4ae3-8e3c-796ec287a9eb', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Quelle est la distinction fondamentale entre le ''noyau Linux'' et une ''distribution Linux'' (comme Ubuntu ou Debian) ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('8f2040a9-4435-4ae3-8e3c-796ec287a9eb', 'Le noyau est la partie graphique, la distribution est la ligne de commande.', false, 1),
('8f2040a9-4435-4ae3-8e3c-796ec287a9eb', 'Le noyau (créé par Linus Torvalds) est le cœur du système qui gère le matériel ; la distribution est un système d''exploitation complet qui inclut le noyau, des logiciels et une interface.', true, 2),
('8f2040a9-4435-4ae3-8e3c-796ec287a9eb', 'Le noyau Linux est payant, les distributions sont gratuites.', false, 3),
('8f2040a9-4435-4ae3-8e3c-796ec287a9eb', 'Il n''y a aucune différence, ce sont des synonymes.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('63d51d1c-2568-4f28-ac85-bef1cd2aacc7', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Dans quel(s) domaine(s) Linux est-il aujourd''hui majoritairement utilisé ?', 'Réponse correcte : B, C, D');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('63d51d1c-2568-4f28-ac85-bef1cd2aacc7', 'Les ordinateurs de bureau pour le grand public.', false, 1),
('63d51d1c-2568-4f28-ac85-bef1cd2aacc7', 'Les serveurs web qui hébergent les sites internet.', true, 2),
('63d51d1c-2568-4f28-ac85-bef1cd2aacc7', 'Les supercalculateurs les plus puissants au monde.', true, 3),
('63d51d1c-2568-4f28-ac85-bef1cd2aacc7', 'Les objets connectés (IoT) et les systèmes embarqués (ex: box internet, voitures).', true, 4),
('63d51d1c-2568-4f28-ac85-bef1cd2aacc7', 'La suite logicielle Adobe Creative Cloud.', false, 5);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('bc8ec193-362c-4cb2-9666-494f48ab68e7', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Qu''est-ce que le ''shell'' ou ''terminal'' sous Linux ?', 'Réponse correcte : C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('bc8ec193-362c-4cb2-9666-494f48ab68e7', 'Un logiciel antivirus intégré par défaut.', false, 1),
('bc8ec193-362c-4cb2-9666-494f48ab68e7', 'Le gestionnaire de fenêtres qui gère l''apparence du bureau.', false, 2),
('bc8ec193-362c-4cb2-9666-494f48ab68e7', 'Une interface en ligne de commande qui permet de communiquer directement avec le système d''exploitation.', true, 3),
('bc8ec193-362c-4cb2-9666-494f48ab68e7', 'Le magasin d''applications de la distribution.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('4e836fe6-e714-4615-9a55-1692cdcf0959', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Le système d''exploitation Android est basé sur...', 'Réponse correcte : C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('4e836fe6-e714-4615-9a55-1692cdcf0959', 'Le noyau de Windows.', false, 1),
('4e836fe6-e714-4615-9a55-1692cdcf0959', 'Le noyau de macOS.', false, 2),
('4e836fe6-e714-4615-9a55-1692cdcf0959', 'Le noyau Linux.', true, 3),
('4e836fe6-e714-4615-9a55-1692cdcf0959', 'Un noyau développé entièrement par Google.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('82d557e3-cd2f-449d-adf3-2107fd2d5250', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Que garantit le chiffrement de bout en bout (end-to-end encryption) dans une messagerie comme Signal ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('82d557e3-cd2f-449d-adf3-2107fd2d5250', 'Que les messages sont chiffrés sur les serveurs de l''entreprise mais qu''elle peut y accéder si besoin.', false, 1),
('82d557e3-cd2f-449d-adf3-2107fd2d5250', 'Que seuls l''émetteur et le(s) destinataire(s) possèdent les clés pour déchiffrer les messages, rendant leur lecture impossible par un tiers (y compris le fournisseur du service).', true, 2),
('82d557e3-cd2f-449d-adf3-2107fd2d5250', 'Que les messages sont anonymes et que personne ne connaît l''identité de l''émetteur.', false, 3),
('82d557e3-cd2f-449d-adf3-2107fd2d5250', 'Que les messages sont automatiquement supprimés après 24 heures.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('ba790c79-5620-4c13-b3d2-28a3a4841ffc', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Qu''est-ce qu''un ''cookie tiers'' (third-party cookie) sur un site web ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('ba790c79-5620-4c13-b3d2-28a3a4841ffc', 'Un fichier nécessaire au bon fonctionnement technique du site que l''on visite.', false, 1),
('ba790c79-5620-4c13-b3d2-28a3a4841ffc', 'Un cookie déposé par un site différent de celui que l''on visite, souvent utilisé pour le suivi publicitaire et le pistage de la navigation entre plusieurs sites.', true, 2),
('ba790c79-5620-4c13-b3d2-28a3a4841ffc', 'Un avertissement de sécurité qui prévient d''une faille sur le site.', false, 3),
('ba790c79-5620-4c13-b3d2-28a3a4841ffc', 'Un petit gâteau virtuel offert lors de la troisième visite sur un site.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('b0251ddc-4ef6-4d41-871c-a974803f01f1', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Qu''est-ce que le RGPD (Règlement Général sur la Protection des Données) ?', 'Réponse correcte : C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('b0251ddc-4ef6-4d41-871c-a974803f01f1', 'Un logiciel antivirus européen obligatoire.', false, 1),
('b0251ddc-4ef6-4d41-871c-a974803f01f1', 'Une loi américaine qui encadre l''utilisation des données par les GAFAM.', false, 2),
('b0251ddc-4ef6-4d41-871c-a974803f01f1', 'Une réglementation européenne qui renforce et unifie la protection des données personnelles des citoyens de l''UE.', true, 3),
('b0251ddc-4ef6-4d41-871c-a974803f01f1', 'Un protocole de sécurité pour les réseaux Wi-Fi.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('8ff1cbed-04bf-4680-a4f0-83f94a5a29a0', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'À quoi sert principalement un VPN (Virtual Private Network) ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('8ff1cbed-04bf-4680-a4f0-83f94a5a29a0', 'À augmenter la vitesse de sa connexion internet.', false, 1),
('8ff1cbed-04bf-4680-a4f0-83f94a5a29a0', 'À chiffrer son trafic internet et à masquer son adresse IP, améliorant ainsi la confidentialité et la sécurité.', true, 2),
('8ff1cbed-04bf-4680-a4f0-83f94a5a29a0', 'À bloquer toutes les publicités sur les sites web.', false, 3),
('8ff1cbed-04bf-4680-a4f0-83f94a5a29a0', 'À obtenir un accès gratuit à des services normalement payants.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('b8588f1d-e681-4104-ad78-a36c176d98b1', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Dans le cadre de la démarche NIRD, quel est le principal enjeu de l''axe ''Inclusif'' ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('b8588f1d-e681-4104-ad78-a36c176d98b1', 'S''assurer que tout le monde utilise le même modèle d''ordinateur.', false, 1),
('b8588f1d-e681-4104-ad78-a36c176d98b1', 'Lutter contre l''illectronisme et la fracture numérique (accès au matériel, aux compétences et aux usages).', true, 2),
('b8588f1d-e681-4104-ad78-a36c176d98b1', 'Inclure plus de publicités dans les logiciels éducatifs.', false, 3),
('b8588f1d-e681-4104-ad78-a36c176d98b1', 'Obliger tous les élèves à s''inscrire sur un réseau social.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('a10a6851-d175-47d2-bc49-106f46ef6ed2', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Quel est l''objectif de l''axe ''Responsable'' de la démarche NIRD ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('a10a6851-d175-47d2-bc49-106f46ef6ed2', 'Rendre le chef d''établissement responsable de toutes les pannes informatiques.', false, 1),
('a10a6851-d175-47d2-bc49-106f46ef6ed2', 'Encourager l''autonomie, la maîtrise des outils et le développement de l''esprit critique face au numérique, notamment en privilégiant les communs numériques et les logiciels libres.', true, 2),
('a10a6851-d175-47d2-bc49-106f46ef6ed2', 'Responsabiliser financièrement les élèves qui cassent du matériel.', false, 3),
('a10a6851-d175-47d2-bc49-106f46ef6ed2', 'Utiliser uniquement des logiciels créés par des entreprises françaises.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('f22afefe-74d9-47c9-a08d-f40a5603e184', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'L''axe ''Durable'' de la démarche NIRD vise à réduire l''empreinte environnementale du numérique. Quelle phase du cycle de vie d''un équipement (smartphone, ordinateur) est la plus impactante ?', 'Réponse correcte : D');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('f22afefe-74d9-47c9-a08d-f40a5603e184', 'Son utilisation quotidienne (consommation électrique).', false, 1),
('f22afefe-74d9-47c9-a08d-f40a5603e184', 'Son transport depuis le pays de fabrication.', false, 2),
('f22afefe-74d9-47c9-a08d-f40a5603e184', 'Sa phase de recyclage.', false, 3),
('f22afefe-74d9-47c9-a08d-f40a5603e184', 'Sa fabrication (extraction des matières premières, production des composants, assemblage).', true, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('8cc356c4-2856-41a0-8c4d-1e401cd91e0b', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Qu''est-ce que l''indice de réparabilité, en lien avec un numérique durable ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('8cc356c4-2856-41a0-8c4d-1e401cd91e0b', 'Une note qui indique la performance d''un appareil.', false, 1),
('8cc356c4-2856-41a0-8c4d-1e401cd91e0b', 'Une note obligatoire sur certains équipements électroniques en France, informant sur la facilité à les réparer.', true, 2),
('8cc356c4-2856-41a0-8c4d-1e401cd91e0b', 'Le nombre de fois qu''un appareil peut tomber en panne avant de devoir être remplacé.', false, 3),
('8cc356c4-2856-41a0-8c4d-1e401cd91e0b', 'Un indice boursier pour les entreprises de réparation.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('edcbeae6-6426-4f72-9d4d-08923563deb1', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Comment le choix d''un logiciel peut-il impacter la durabilité du matériel ?', 'Réponse correcte : A, B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('edcbeae6-6426-4f72-9d4d-08923563deb1', 'Les logiciels propriétaires récents exigent souvent des machines puissantes, poussant au renouvellement du matériel.', true, 1),
('edcbeae6-6426-4f72-9d4d-08923563deb1', 'Les systèmes d''exploitation légers, comme certaines distributions Linux, peuvent prolonger la vie d''ordinateurs anciens.', true, 2),
('edcbeae6-6426-4f72-9d4d-08923563deb1', 'Les logiciels libres n''ont aucun impact sur la durabilité du matériel.', false, 3),
('edcbeae6-6426-4f72-9d4d-08923563deb1', 'Utiliser des logiciels en ligne (cloud computing) permet de ne plus avoir besoin d''un ordinateur.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('bb9cc1d7-f021-48a3-9a73-da3ec2bb9596', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Que signifie l''acronyme FOSS (ou FLOSS) ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('bb9cc1d7-f021-48a3-9a73-da3ec2bb9596', 'Fast Operating System Software.', false, 1),
('bb9cc1d7-f021-48a3-9a73-da3ec2bb9596', 'Free and Open Source Software.', true, 2),
('bb9cc1d7-f021-48a3-9a73-da3ec2bb9596', 'Firmware of Secure Systems.', false, 3),
('bb9cc1d7-f021-48a3-9a73-da3ec2bb9596', 'For Open Source Societies.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('8aa06a02-0052-4303-b83a-24942ce2b8fc', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'L''argument ''Si c''est gratuit, c''est que vous êtes le produit'' s''applique particulièrement à...', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('8aa06a02-0052-4303-b83a-24942ce2b8fc', 'L''ensemble des logiciels libres et open-source.', false, 1),
('8aa06a02-0052-4303-b83a-24942ce2b8fc', 'Les services des GAFAM financés par la publicité ciblée.', true, 2),
('8aa06a02-0052-4303-b83a-24942ce2b8fc', 'Les services publics en ligne.', false, 3),
('8aa06a02-0052-4303-b83a-24942ce2b8fc', 'Les distributions Linux comme Debian.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('7fb866e1-960b-4717-95e1-5e21951f7d26', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Quel concept décrit la difficulté pour un utilisateur de changer de service ou de technologie à cause des coûts de transition (perte de données, réapprentissage, incompatibilité) ?', 'Réponse correcte : C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('7fb866e1-960b-4717-95e1-5e21951f7d26', 'L''effet de réseau.', false, 1),
('7fb866e1-960b-4717-95e1-5e21951f7d26', 'Le coût marginal.', false, 2),
('7fb866e1-960b-4717-95e1-5e21951f7d26', 'L''enfermement propriétaire (vendor lock-in).', true, 3),
('7fb866e1-960b-4717-95e1-5e21951f7d26', 'La fracture numérique.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('c9a53efa-ece3-4dbf-9074-2a485e0d44a0', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'Le ''droit à l''oubli'' (ou droit à l''effacement), consacré par le RGPD, permet à un individu de demander...', 'Réponse correcte : A, D');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('c9a53efa-ece3-4dbf-9074-2a485e0d44a0', 'La suppression de toutes ses données personnelles détenues par un organisme.', true, 1),
('c9a53efa-ece3-4dbf-9074-2a485e0d44a0', 'L''oubli de ses mauvaises notes dans les bulletins scolaires.', false, 2),
('c9a53efa-ece3-4dbf-9074-2a485e0d44a0', 'La suppression de son casier judiciaire.', false, 3),
('c9a53efa-ece3-4dbf-9074-2a485e0d44a0', 'La suppression des informations obsolètes ou non pertinentes des résultats d''un moteur de recherche (déréférencement).', true, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('51b9cb04-cbc8-4dcc-b4f4-efea6ab70af0', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'moyen', 'En quoi la ''sobriété numérique'' est-elle un pilier d''un numérique durable ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('51b9cb04-cbc8-4dcc-b4f4-efea6ab70af0', 'Elle consiste à ne plus utiliser du tout les technologies numériques.', false, 1),
('51b9cb04-cbc8-4dcc-b4f4-efea6ab70af0', 'Elle vise à réduire l''usage du numérique à ce qui est réellement utile et à concevoir des services moins gourmands en ressources (données, énergie).', true, 2),
('51b9cb04-cbc8-4dcc-b4f4-efea6ab70af0', 'Elle encourage la production d''équipements aux designs plus simples et moins colorés.', false, 3),
('51b9cb04-cbc8-4dcc-b4f4-efea6ab70af0', 'Elle implique de passer en mode ''ne pas déranger'' sur son téléphone en permanence.', false, 4);

-- Fichier: quiz_question_lvl3.txt (difficile)
-- Found 25 questions in quiz_question_lvl3.txt
INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('5a487b33-39b8-403d-9830-371fc05fa33b', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Quelle est la principale différence juridique et philosophique entre une licence permissive (ex: MIT, Apache) et une licence copyleft forte (ex: GNU GPLv3) ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('5a487b33-39b8-403d-9830-371fc05fa33b', 'Les licences permissives autorisent l''utilisation commerciale, contrairement aux licences copyleft.', false, 1),
('5a487b33-39b8-403d-9830-371fc05fa33b', 'Les licences copyleft imposent que les œuvres dérivées soient distribuées sous une licence compatible, préservant la liberté du code, tandis que les licences permissives autorisent l''intégration dans des logiciels propriétaires sans cette contrainte.', true, 2),
('5a487b33-39b8-403d-9830-371fc05fa33b', 'Les licences permissives sont validées par l''Open Source Initiative (OSI), alors que les licences copyleft sont validées par la Free Software Foundation (FSF).', false, 3),
('5a487b33-39b8-403d-9830-371fc05fa33b', 'Le copyleft est un concept américain, tandis que les licences permissives sont d''origine européenne.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('404120f9-0c5c-45cf-9990-f7b6c769e6b7', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Le modèle de développement open-source décrit par Eric S. Raymond dans ''La Cathédrale et le Bazar'' oppose deux approches. Qu''est-ce qui caractérise le ''Bazar'' ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('404120f9-0c5c-45cf-9990-f7b6c769e6b7', 'Un développement centralisé, planifié et mené par un petit groupe d''experts (La Cathédrale).', false, 1),
('404120f9-0c5c-45cf-9990-f7b6c769e6b7', 'Un développement décentralisé, ouvert, où les contributions et les versions sont fréquentes, s''appuyant sur une large communauté (Le Bazar).', true, 2),
('404120f9-0c5c-45cf-9990-f7b6c769e6b7', 'Un modèle économique basé sur la vente de licences logicielles.', false, 3),
('404120f9-0c5c-45cf-9990-f7b6c769e6b7', 'Une méthode de développement propriétaire utilisée exclusivement par Microsoft.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('6e110b5c-c3ac-4904-b9b8-a2d748209aa5', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Quel est le principal modèle économique des entreprises comme Red Hat ou SUSE, bâti autour de Linux ?', 'Réponse correcte : C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('6e110b5c-c3ac-4904-b9b8-a2d748209aa5', 'La vente de licences pour le système d''exploitation Linux lui-même.', false, 1),
('6e110b5c-c3ac-4904-b9b8-a2d748209aa5', 'La vente de matériel informatique optimisé pour Linux.', false, 2),
('6e110b5c-c3ac-4904-b9b8-a2d748209aa5', 'La vente de souscriptions offrant du support technique, de la maintenance, de la certification et des services professionnels pour leurs distributions Linux.', true, 3),
('6e110b5c-c3ac-4904-b9b8-a2d748209aa5', 'La collecte et la vente des données des utilisateurs de leurs distributions.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('c1f61a82-771e-4523-a62d-183084a900c2', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Quel est l''objectif principal du Digital Markets Act (DMA) européen vis-à-vis des GAFAM ?', 'Réponse correcte : C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('c1f61a82-771e-4523-a62d-183084a900c2', 'Interdire l''utilisation des services des GAFAM en Europe.', false, 1),
('c1f61a82-771e-4523-a62d-183084a900c2', 'Réguler les contenus haineux et la désinformation sur leurs plateformes.', false, 2),
('c1f61a82-771e-4523-a62d-183084a900c2', 'Imposer des obligations spécifiques aux ''contrôleurs d''accès'' (gatekeepers) pour garantir des marchés numériques plus équitables et contestables, en interdisant certaines de leurs pratiques d''auto-préférence et en exigeant l''interopérabilité.', true, 3),
('c1f61a82-771e-4523-a62d-183084a900c2', 'Mettre en place une taxe sur les bénéfices des géants du numérique.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('d2adc47c-9cfd-4f50-86e4-c293053fef8b', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Le concept d''''enfermement propriétaire'' (vendor lock-in) est une stratégie pour retenir les clients. Quels mécanismes techniques y contribuent ?', 'Réponse correcte : B, C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('d2adc47c-9cfd-4f50-86e4-c293053fef8b', 'L''utilisation de formats de fichiers ouverts et de standards interopérables.', false, 1),
('d2adc47c-9cfd-4f50-86e4-c293053fef8b', 'Des coûts de sortie élevés, par exemple en rendant le transfert de données vers un service concurrent complexe et coûteux.', true, 2),
('d2adc47c-9cfd-4f50-86e4-c293053fef8b', 'L''utilisation d''API propriétaires non documentées et d''une forte intégration verticale entre les services d''un même écosystème.', true, 3),
('d2adc47c-9cfd-4f50-86e4-c293053fef8b', 'La publication du code source du service sous une licence libre.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('26a127fb-42a0-4b42-a16b-b47c1aab3e96', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Qu''est-ce que l''initiative européenne GAIA-X vise à développer pour contrer la domination des GAFAM ?', 'Réponse correcte : C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('26a127fb-42a0-4b42-a16b-b47c1aab3e96', 'Un nouveau système d''exploitation concurrent de Windows et macOS.', false, 1),
('26a127fb-42a0-4b42-a16b-b47c1aab3e96', 'Un moteur de recherche européen financé par des fonds publics.', false, 2),
('26a127fb-42a0-4b42-a16b-b47c1aab3e96', 'Un projet visant à créer une infrastructure de données fédérée, ouverte et souveraine, basée sur des standards communs, pour renforcer l''autonomie numérique de l''Europe.', true, 3),
('26a127fb-42a0-4b42-a16b-b47c1aab3e96', 'Une messagerie instantanée chiffrée pour les gouvernements européens.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('332d5142-9be0-4a73-b4c3-f2c8cbd2d565', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'En termes d''architecture, qu''est-ce qui distingue principalement le noyau Linux d''un micro-noyau (comme Mach, utilisé dans les premières versions de macOS) ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('332d5142-9be0-4a73-b4c3-f2c8cbd2d565', 'Le noyau Linux est entièrement modulaire et ne contient aucun pilote de périphérique.', false, 1),
('332d5142-9be0-4a73-b4c3-f2c8cbd2d565', 'Linux est un noyau monolithique où les principaux services (gestion des processus, de la mémoire, des systèmes de fichiers, pilotes) s''exécutent dans le même espace (l''espace noyau), contrairement à un micro-noyau qui délègue la plupart des services à des processus externes (en espace utilisateur).', true, 2),
('332d5142-9be0-4a73-b4c3-f2c8cbd2d565', 'Les micro-noyaux sont plus performants mais moins stables que les noyaux monolithiques.', false, 3),
('332d5142-9be0-4a73-b4c3-f2c8cbd2d565', 'Le noyau Linux ne peut fonctionner que sur des architectures x86.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('dd1a1b34-564d-4804-9d90-0de251d95c1e', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Quel est le rôle des ''cgroups'' (control groups) et des ''namespaces'' dans le noyau Linux, qui sont des technologies fondamentales pour la conteneurisation (Docker, Kubernetes) ?', 'Réponse correcte : C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('dd1a1b34-564d-4804-9d90-0de251d95c1e', 'Gérer les permissions des utilisateurs et des groupes sur les fichiers.', false, 1),
('dd1a1b34-564d-4804-9d90-0de251d95c1e', 'Installer et mettre à jour les paquets logiciels.', false, 2),
('dd1a1b34-564d-4804-9d90-0de251d95c1e', 'Les cgroups limitent et contrôlent les ressources (CPU, RAM, I/O) allouées à un groupe de processus, tandis que les namespaces isolent la vue qu''ont ces processus du système (PID, réseau, utilisateurs, etc.).', true, 3),
('dd1a1b34-564d-4804-9d90-0de251d95c1e', 'Configurer l''interface graphique et l''environnement de bureau.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('5eb0f9fd-a446-4e1e-8cbd-9fdd3808c6e5', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Pourquoi le système d''initialisation ''systemd'' est-il parfois controversé au sein de la communauté Linux ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('5eb0f9fd-a446-4e1e-8cbd-9fdd3808c6e5', 'Parce qu''il est développé par Microsoft.', false, 1),
('5eb0f9fd-a446-4e1e-8cbd-9fdd3808c6e5', 'Parce que son approche est jugée trop complexe et monolithique, allant à l''encontre de la philosophie UNIX ''un outil fait une seule chose et la fait bien''.', true, 2),
('5eb0f9fd-a446-4e1e-8cbd-9fdd3808c6e5', 'Parce qu''il est moins performant que les anciens systèmes d''init comme SysV.', false, 3),
('5eb0f9fd-a446-4e1e-8cbd-9fdd3808c6e5', 'Parce qu''il n''est pas distribué sous une licence libre.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('e39241ad-5b32-4d1a-841f-723091171ec4', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Qu''est-ce que le Filesystem Hierarchy Standard (FHS) définit sous Linux ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('e39241ad-5b32-4d1a-841f-723091171ec4', 'Le type de système de fichiers à utiliser pour le stockage (ext4, Btrfs, XFS).', false, 1),
('e39241ad-5b32-4d1a-841f-723091171ec4', 'Une convention sur l''arborescence des répertoires et l''emplacement des fichiers (ex: /bin, /etc, /var, /usr) pour assurer une cohérence entre les distributions.', true, 2),
('e39241ad-5b32-4d1a-841f-723091171ec4', 'Un protocole de partage de fichiers en réseau.', false, 3),
('e39241ad-5b32-4d1a-841f-723091171ec4', 'La hiérarchie des permissions d''accès aux fichiers.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('20ada96f-4c11-4b25-94f5-b3382726c206', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Comment fonctionne le réseau Tor pour anonymiser le trafic de ses utilisateurs ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('20ada96f-4c11-4b25-94f5-b3382726c206', 'En utilisant un VPN centralisé qui masque l''adresse IP de l''utilisateur.', false, 1),
('20ada96f-4c11-4b25-94f5-b3382726c206', 'En chiffrant le trafic en plusieurs couches (comme un oignon) et en le faisant transiter par une série de relais aléatoires, de sorte qu''aucun relais unique ne connaît à la fois l''origine et la destination finale du trafic.', true, 2),
('20ada96f-4c11-4b25-94f5-b3382726c206', 'En supprimant toutes les métadonnées des paquets réseau.', false, 3),
('20ada96f-4c11-4b25-94f5-b3382726c206', 'En utilisant exclusivement le protocole peer-to-peer pour la communication.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('8d3bf867-1fff-488d-ba57-76d0768787c3', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Dans le contexte de la cryptographie et de la navigation web (HTTPS), quel est le rôle respectif de la cryptographie asymétrique (ex: RSA) et symétrique (ex: AES) lors de l''établissement d''une connexion TLS/SSL ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('8d3bf867-1fff-488d-ba57-76d0768787c3', 'Tout le trafic est chiffré avec la cryptographie asymétrique, qui est plus rapide.', false, 1),
('8d3bf867-1fff-488d-ba57-76d0768787c3', 'La cryptographie asymétrique est utilisée au début (handshake) pour authentifier le serveur et échanger de manière sécurisée une clé de session. Ensuite, cette clé est utilisée pour chiffrer la communication de manière symétrique, ce qui est beaucoup plus performant.', true, 2),
('8d3bf867-1fff-488d-ba57-76d0768787c3', 'La cryptographie symétrique authentifie le serveur, et la cryptographie asymétrique chiffre les données.', false, 3),
('8d3bf867-1fff-488d-ba57-76d0768787c3', 'Seule la cryptographie symétrique est utilisée car elle est plus sécurisée.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('b2397365-e352-4274-acc8-eae2501b5ed2', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Qu''est-ce que la ''confidentialité différentielle'' (differential privacy) ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('b2397365-e352-4274-acc8-eae2501b5ed2', 'Une méthode de chiffrement des bases de données.', false, 1),
('b2397365-e352-4274-acc8-eae2501b5ed2', 'Un cadre mathématique permettant d''analyser des ensembles de données en y ajoutant un ''bruit'' statistique, de sorte que les résultats de l''analyse ne permettent pas de savoir si les informations d''un individu spécifique faisaient partie de l''ensemble de données initial ou non.', true, 2),
('b2397365-e352-4274-acc8-eae2501b5ed2', 'Une politique de confidentialité qui varie selon le pays de l''utilisateur.', false, 3),
('b2397365-e352-4274-acc8-eae2501b5ed2', 'Une technique qui garantit l''anonymat complet sur Internet.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('b441c096-6a87-4600-8c48-5081f8ecbdb9', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Pourquoi les métadonnées de communication (qui a appelé qui, quand, pendant combien de temps) peuvent-elles être aussi, voire plus, révélatrices que le contenu lui-même ?', 'Réponse correcte : D');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('b441c096-6a87-4600-8c48-5081f8ecbdb9', 'Car elles sont plus faciles à stocker et à analyser en masse.', false, 1),
('b441c096-6a87-4600-8c48-5081f8ecbdb9', 'Car elles permettent de cartographier des réseaux sociaux, de déduire des affiliations, des habitudes de vie ou des événements (ex: appel à un médecin suivi d''un appel à un assureur) même sans connaître le contenu des conversations.', false, 2),
('b441c096-6a87-4600-8c48-5081f8ecbdb9', 'Car elles ne sont pas protégées par le chiffrement de bout en bout.', false, 3),
('b441c096-6a87-4600-8c48-5081f8ecbdb9', 'Toutes les réponses ci-dessus sont correctes.', true, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('db7d776a-d410-4592-98d3-31b13998465e', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Qu''est-ce qu''une ''attaque par canal auxiliaire'' (side-channel attack) en sécurité informatique ?', 'Réponse correcte : C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('db7d776a-d410-4592-98d3-31b13998465e', 'Une attaque qui exploite une faille dans le code d''un logiciel (ex: buffer overflow).', false, 1),
('db7d776a-d410-4592-98d3-31b13998465e', 'Une attaque basée sur l''ingénierie sociale pour tromper un utilisateur.', false, 2),
('db7d776a-d410-4592-98d3-31b13998465e', 'Une attaque qui exploite des informations issues de l''implémentation physique d''un système (consommation électrique, temps de calcul, émissions électromagnétiques) pour en déduire des données secrètes comme des clés de chiffrement.', true, 3),
('db7d776a-d410-4592-98d3-31b13998465e', 'Une attaque par déni de service (DDoS).', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('4fbd9064-eb85-4e2b-8a4f-3a01b6058aec', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Dans le cadre de la démarche NIRD, en quoi consiste une Analyse du Cycle de Vie (ACV) d''un service numérique ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('4fbd9064-eb85-4e2b-8a4f-3a01b6058aec', 'À mesurer uniquement la consommation électrique des serveurs pendant la phase d''utilisation du service.', false, 1),
('4fbd9064-eb85-4e2b-8a4f-3a01b6058aec', 'À évaluer l''impact environnemental global du service, en incluant la fabrication des terminaux utilisateurs et des infrastructures réseau/serveur, leur phase d''utilisation et leur fin de vie.', true, 2),
('4fbd9064-eb85-4e2b-8a4f-3a01b6058aec', 'À calculer la durée de vie moyenne des logiciels utilisés.', false, 3),
('4fbd9064-eb85-4e2b-8a4f-3a01b6058aec', 'À analyser le cycle de développement et de mise à jour du service.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('993403e3-89dd-4ea5-aa33-e5f3ceb9c36b', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Comment le concept de ''low-tech'' peut-il s''appliquer au numérique dans une démarche de durabilité ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('993403e3-89dd-4ea5-aa33-e5f3ceb9c36b', 'En refusant toute forme de technologie numérique.', false, 1),
('993403e3-89dd-4ea5-aa33-e5f3ceb9c36b', 'En concevant des services et des sites web plus simples, moins gourmands en ressources, et en privilégiant des technologies robustes, réparables et moins complexes.', true, 2),
('993403e3-89dd-4ea5-aa33-e5f3ceb9c36b', 'En utilisant des ordinateurs plus anciens et moins puissants.', false, 3),
('993403e3-89dd-4ea5-aa33-e5f3ceb9c36b', 'En se concentrant uniquement sur des technologies basées sur le texte, sans images ni vidéos.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('297b984d-376f-441b-a6ad-11017c945418', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Le pilier ''Inclusif'' de la démarche NIRD cherche à lutter contre les biais algorithmiques. Qu''est-ce qu''un biais algorithmique ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('297b984d-376f-441b-a6ad-11017c945418', 'Une erreur de programmation qui fait planter le logiciel.', false, 1),
('297b984d-376f-441b-a6ad-11017c945418', 'Une tendance systématique d''un algorithme à produire des résultats qui désavantagent certains groupes de personnes, souvent en reproduisant et en amplifiant des préjugés existants dans les données d''entraînement.', true, 2),
('297b984d-376f-441b-a6ad-11017c945418', 'Une fonctionnalité qui rend l''algorithme plus lent pour certains utilisateurs.', false, 3),
('297b984d-376f-441b-a6ad-11017c945418', 'Un choix délibéré de l''IA pour ignorer certaines données.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('0cd49297-4be7-4260-9835-0834a38a4b51', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Quel est le ''paradoxe de Jevons'' appliqué à l''efficacité énergétique du numérique (Effet rebond) ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('0cd49297-4be7-4260-9835-0834a38a4b51', 'Les gains d''efficacité énergétique d''une technologie diminuent avec le temps.', false, 1),
('0cd49297-4be7-4260-9835-0834a38a4b51', 'À mesure qu''une technologie devient plus efficace sur le plan énergétique, son utilisation tend à augmenter, ce qui peut annuler (voire dépasser) les économies d''énergie réalisées.', true, 2),
('0cd49297-4be7-4260-9835-0834a38a4b51', 'Les technologies les plus efficaces sont toujours les plus chères.', false, 3),
('0cd49297-4be7-4260-9835-0834a38a4b51', 'L''efficacité énergétique est inversement proportionnelle à la puissance de calcul.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('c2a67850-5d28-4744-9ad6-89f578c848cd', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'En quoi l''utilisation de ''communs numériques'' (ex: Wikipedia, OpenStreetMap, logiciels libres) soutient-elle l''axe ''Responsable'' de la démarche NIRD ?', 'Réponse correcte : C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('c2a67850-5d28-4744-9ad6-89f578c848cd', 'Car ils sont toujours plus sécurisés que les alternatives propriétaires.', false, 1),
('c2a67850-5d28-4744-9ad6-89f578c848cd', 'Car ils sont gérés et maintenus par des GAFAM.', false, 2),
('c2a67850-5d28-4744-9ad6-89f578c848cd', 'Car ils représentent des ressources partagées et gouvernées collectivement, favorisant l''autonomie, la souveraineté numérique et la sortie de logiques purement mercantiles et opaques.', true, 3),
('c2a67850-5d28-4744-9ad6-89f578c848cd', 'Car leur utilisation est gratuite et ne requiert aucune compétence technique.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('63349501-233e-428a-b6d9-e7ccfd0d5b9d', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Qu''est-ce que le ''Software Bill of Materials'' (SBOM) et pourquoi devient-il crucial pour la sécurité et la transparence ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('63349501-233e-428a-b6d9-e7ccfd0d5b9d', 'La facture d''achat d''un logiciel.', false, 1),
('63349501-233e-428a-b6d9-e7ccfd0d5b9d', 'Une liste exhaustive de tous les composants, bibliothèques et dépendances (libres ou propriétaires) utilisés pour construire un logiciel, permettant de tracer rapidement les vulnérabilités.', true, 2),
('63349501-233e-428a-b6d9-e7ccfd0d5b9d', 'Le manuel d''utilisation d''un logiciel.', false, 3),
('63349501-233e-428a-b6d9-e7ccfd0d5b9d', 'Un document légal qui définit les conditions d''utilisation d''un logiciel.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('20038e15-fe63-413c-b8dd-5304ea711b4a', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Comment les ''dark patterns'' dans les interfaces utilisateur (UI) sapent-ils le consentement et la protection de la vie privée ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('20038e15-fe63-413c-b8dd-5304ea711b4a', 'En utilisant un thème sombre qui consomme moins d''énergie sur les écrans OLED.', false, 1),
('20038e15-fe63-413c-b8dd-5304ea711b4a', 'En rendant les options respectueuses de la vie privée difficiles à trouver, en utilisant un langage trompeur ou en pré-cochant des cases pour inciter l''utilisateur à partager plus de données qu''il ne le souhaiterait.', true, 2),
('20038e15-fe63-413c-b8dd-5304ea711b4a', 'En cachant des fonctionnalités derrière des menus complexes.', false, 3),
('20038e15-fe63-413c-b8dd-5304ea711b4a', 'En utilisant des polices de caractères difficiles à lire pour les personnes malvoyantes.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('18309896-b78b-4146-81c0-6ca147f4937d', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Quelle est la principale limite technique du ''droit à l''oubli'' face à des technologies comme les blockchains ou les systèmes de fichiers décentralisés (IPFS) ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('18309896-b78b-4146-81c0-6ca147f4937d', 'Ces technologies ne sont pas soumises au RGPD.', false, 1),
('18309896-b78b-4146-81c0-6ca147f4937d', 'L''immuabilité et la décentralisation de ces systèmes rendent l''effacement ou la modification de données a posteriori extrêmement difficile, voire impossible par conception.', true, 2),
('18309896-b78b-4146-81c0-6ca147f4937d', 'Seul le créateur de la blockchain peut effacer des données.', false, 3),
('18309896-b78b-4146-81c0-6ca147f4937d', 'Le droit à l''oubli ne s''applique qu''aux données textuelles, pas aux transactions financières.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('b3a208cc-ba84-40a4-bca6-2908ad3ef9fb', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'Quelle affirmation décrit le mieux le concept de ''souveraineté numérique'' pour un État ou une organisation ?', 'Réponse correcte : B');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('b3a208cc-ba84-40a4-bca6-2908ad3ef9fb', 'Le fait de produire son propre matériel informatique sur son territoire.', false, 1),
('b3a208cc-ba84-40a4-bca6-2908ad3ef9fb', 'La capacité à maîtriser et à contrôler son infrastructure, ses logiciels, ses données et les règles qui s''y appliquent, afin de ne pas dépendre de puissances ou d''entreprises étrangères.', true, 2),
('b3a208cc-ba84-40a4-bca6-2908ad3ef9fb', 'L''interdiction totale d''utiliser des logiciels ou services étrangers.', false, 3),
('b3a208cc-ba84-40a4-bca6-2908ad3ef9fb', 'La possession d''une monnaie numérique de banque centrale.', false, 4);

INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES
('1dd8fd63-5bd8-4f43-b057-aa02a7ecba68', '3a867926-6863-4208-a579-0021d6418861', 'multiple_choice', 'difficile', 'L''éco-conception de services numériques, un aspect du NIRD, vise à...', 'Réponse correcte : C');
INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES
('1dd8fd63-5bd8-4f43-b057-aa02a7ecba68', 'Utiliser exclusivement des énergies renouvelables pour alimenter les data centers.', false, 1),
('1dd8fd63-5bd8-4f43-b057-aa02a7ecba68', 'Réduire la quantité de fonctionnalités d''une application pour la rendre moins attractive.', false, 2),
('1dd8fd63-5bd8-4f43-b057-aa02a7ecba68', 'Intégrer les enjeux environnementaux à toutes les étapes de la conception d''un service (UX/UI, architecture, code) pour minimiser son empreinte écologique tout au long de son cycle de vie.', true, 3),
('1dd8fd63-5bd8-4f43-b057-aa02a7ecba68', 'Rendre l''interface du service entièrement verte pour rappeler la nature.', false, 4);

