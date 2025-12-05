/**
 * JavaScript pour la page QCM interactive
 * Gère les réponses, la navigation et la communication avec le backend
 */

document.addEventListener('DOMContentLoaded', function() {
    const answerForm = document.getElementById('answer-form');
    const questionCard = document.querySelector('.question-card');

    if (!answerForm || !questionCard) return;

    const sessionId = questionCard.dataset.sessionId;
    const questionNum = parseInt(questionCard.dataset.questionNum);

    // Gestion des réponses à choix multiples
    const answerButtons = document.querySelectorAll('.answer');
    const selectedChoices = new Set();

    answerButtons.forEach(button => {
        if (button.classList.contains('active')) {
            selectedChoices.add(button.dataset.choiceId);
        }

        button.addEventListener('click', function() {
            const choiceId = this.dataset.choiceId;

            if (this.classList.contains('active')) {
                this.classList.remove('active');
                selectedChoices.delete(choiceId);
            } else {
                this.classList.add('active');
                selectedChoices.add(choiceId);
            }
        });
    });

    // Gestion de l'indice (hint)
    const hint = document.querySelector('.hint');
    if (hint) {
        hint.addEventListener('click', function() {
            const hintText = this.querySelector('.hint-text');
            if (hintText) {
                hintText.style.display = hintText.style.display === 'none' ? 'inline' : 'none';
            }
        });
    }

    // Soumission du formulaire
    answerForm.addEventListener('submit', async function(e) {
        e.preventDefault();

        let answerData;

        // Récupérer la réponse selon le type de question
        const textAnswerInput = document.getElementById('text-answer');
        if (textAnswerInput) {
            // Question texte
            answerData = textAnswerInput.value.trim();
            if (!answerData) {
                alert('Veuillez entrer une réponse');
                return;
            }
        } else {
            // Question à choix multiples
            if (selectedChoices.size === 0) {
                alert('Veuillez sélectionner au moins une réponse');
                return;
            }
            answerData = Array.from(selectedChoices);
        }

        // Envoyer la réponse au backend
        try {
            const response = await fetch(`/qcm/${sessionId}/answer`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    question_num: questionNum,
                    answer: answerData
                })
            });

            const result = await response.json();

            if (result.success) {
                // Afficher un feedback visuel
                const submitBtn = answerForm.querySelector('button[type="submit"]');
                submitBtn.textContent = '✓ Enregistré!';
                submitBtn.classList.add('btn-success');

                setTimeout(() => {
                    submitBtn.textContent = 'Valider';
                    submitBtn.classList.remove('btn-success');
                }, 1500);
            } else {
                alert('Erreur lors de l\'enregistrement de la réponse');
            }
        } catch (error) {
            console.error('Erreur:', error);
            alert('Erreur de communication avec le serveur');
        }
    });

    // Auto-save toutes les 30 secondes
    let autoSaveInterval = setInterval(() => {
        const submitBtn = answerForm.querySelector('button[type="submit"]');
        if (submitBtn && selectedChoices.size > 0) {
            submitBtn.click();
        }
    }, 30000);

    // Nettoyer l'interval quand on quitte la page
    window.addEventListener('beforeunload', () => {
        clearInterval(autoSaveInterval);
    });
});
