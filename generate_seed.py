import json
import glob
import uuid
import os

def escape_sql(text):
    if text is None:
        return "NULL"
    return "'" + str(text).replace("'", "''") + "'"

def get_difficulty(filename):
    if "lvl3" in filename:
        return "difficile"
    if "lvl2" in filename:
        return "moyen"
    return "facile"

def main():
    questions_dir = "questions"
    theme_id = "3a867926-6863-4208-a579-0021d6418861"
    theme_name = "Numérique Responsable"
    theme_desc = "Questions sur l'impact environnemental et social du numérique, et les bonnes pratiques."
    
    print(f"-- ============================================")
    print(f"-- THÈME : {theme_name}")
    print(f"-- ============================================")
    print(f"INSERT INTO themes (id, name, description, is_active) VALUES")
    print(f"('{theme_id}', '{theme_name}', {escape_sql(theme_desc)}, true);")
    print("")

    files = glob.glob(os.path.join(questions_dir, "*.txt"))
    
    for filepath in sorted(files):
        filename = os.path.basename(filepath)
        difficulty = get_difficulty(filename)
        
        print(f"-- Fichier: {filename} ({difficulty})")
        
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                data = json.load(f)
                print(f"-- Found {len(data.get('questionnaire', []))} questions in {filename}")
        except json.JSONDecodeError as e:
            print(f"-- ERREUR: Erreur de décodage JSON dans {filename}: {e}")
            continue
        except Exception as e:
            print(f"-- ERREUR: Impossible de lire {filename}: {e}")
            continue

        # Handle different JSON structures if any. 
        # Based on view_file, structure is {"questionnaire": [ { "id":..., "question":..., "options":..., "reponse_correcte":... } ] }
        
        questions = data.get("questionnaire", [])
        
        for q in questions:
            q_id = uuid.uuid4()
            q_text = q.get("question")
            q_type = "multiple_choice" # Default based on files seen
            # Check if it's text input? The files seen so far are all multiple choice with options.
            # If "options" is missing or empty, it might be text? But existing files have options.
            
            explanation = "Réponse correcte : " + ", ".join(q.get("reponse_correcte", []))
            # The existing seed has real explanations. The JSON doesn't seem to have explanation fields.
            # I will just put a generic explanation or combine the correct answers.
            
            print(f"INSERT INTO questions (id, theme_id, question_type, difficulty, question_text, explanation) VALUES")
            print(f"('{q_id}', '{theme_id}', '{q_type}', '{difficulty}', {escape_sql(q_text)}, {escape_sql(explanation)});")
            
            options = q.get("options", [])
            correct_ids = q.get("reponse_correcte", [])
            
            # Insert choices
            if options:
                print("INSERT INTO question_choices (question_id, choice_text, is_correct, choice_order) VALUES")
                choice_values = []
                for idx, opt in enumerate(options):
                    # opt is {"id": "A", "text": "..."}
                    is_correct = opt.get("id") in correct_ids
                    choice_text = opt.get("text")
                    choice_values.append(f"('{q_id}', {escape_sql(choice_text)}, {str(is_correct).lower()}, {idx + 1})")
                
                print(",\n".join(choice_values) + ";")
            
            print("")

if __name__ == "__main__":
    main()
