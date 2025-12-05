/**
 * ShadyGPT - Chatbot draggable et contextuel
 * Utilise Ollama (llama3.2:1b) via Flask backend
 */

document.addEventListener('DOMContentLoaded', function() {
    const widget = document.getElementById('shadygpt-widget');
    const header = document.getElementById('shadygpt-header');
    const minimizeBtn = document.getElementById('minimize-btn');
    const maximizeBtn = document.getElementById('maximize-btn');
    const chatMessages = document.getElementById('chat-messages');
    const chatForm = document.getElementById('chat-form');
    const chatInput = document.getElementById('chat-input');

    if (!widget) return;

    let isDragging = false;
    let currentX;
    let currentY;
    let initialX;
    let initialY;
    let xOffset = 0;
    let yOffset = 0;
    let conversationId = null;

    // Position initiale (coin bas-droit)
    widget.style.bottom = '20px';
    widget.style.right = '20px';

    // Drag & Drop functionality
    header.addEventListener('mousedown', dragStart);
    document.addEventListener('mousemove', drag);
    document.addEventListener('mouseup', dragEnd);

    function dragStart(e) {
        if (e.target === minimizeBtn || e.target === maximizeBtn) return;

        initialX = e.clientX - xOffset;
        initialY = e.clientY - yOffset;

        if (e.target === header || header.contains(e.target)) {
            isDragging = true;
        }
    }

    function drag(e) {
        if (isDragging) {
            e.preventDefault();

            currentX = e.clientX - initialX;
            currentY = e.clientY - initialY;

            xOffset = currentX;
            yOffset = currentY;

            setTranslate(currentX, currentY, widget);
        }
    }

    function dragEnd() {
        initialX = currentX;
        initialY = currentY;
        isDragging = false;
    }

    function setTranslate(xPos, yPos, el) {
        el.style.transform = `translate3d(${xPos}px, ${yPos}px, 0)`;
    }

    // Minimize / Maximize
    minimizeBtn.addEventListener('click', function() {
        widget.classList.add('minimized');
        minimizeBtn.style.display = 'none';
        maximizeBtn.style.display = 'inline-block';
    });

    maximizeBtn.addEventListener('click', function() {
        widget.classList.remove('minimized');
        minimizeBtn.style.display = 'inline-block';
        maximizeBtn.style.display = 'none';
    });

    // Chat functionality
    chatForm.addEventListener('submit', async function(e) {
        e.preventDefault();

        const message = chatInput.value.trim();
        if (!message) return;

        // Afficher le message de l'utilisateur
        addMessage('user', message);
        chatInput.value = '';

        // Récupérer le contexte depuis la page QCM
        const questionCard = document.querySelector('.question-card');
        const context = questionCard ? {
            theme: questionCard.dataset.theme,
            question_text: questionCard.dataset.questionText
        } : {};

        // Afficher un indicateur de chargement
        const loadingId = addMessage('assistant', 'ShadyGPT réfléchit... 🤔', true);

        try {
            const response = await fetch('/api/chat', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    message: message,
                    conversation_id: conversationId,
                    context: context
                })
            });

            const result = await response.json();

            // Supprimer le message de chargement
            removeMessage(loadingId);

            if (result.success) {
                // Sauvegarder l'ID de conversation
                conversationId = result.conversation_id;

                // Afficher la réponse de ShadyGPT
                addMessage('assistant', result.message);
            } else {
                addMessage('assistant', `Erreur: ${result.error}`, false, 'error');
            }
        } catch (error) {
            removeMessage(loadingId);
            addMessage('assistant', `Erreur de connexion: ${error.message}`, false, 'error');
        }
    });

    // Fonction pour ajouter un message au chat
    function addMessage(role, content, isLoading = false, cssClass = '') {
        const messageDiv = document.createElement('div');
        messageDiv.className = `chat-message ${role} ${cssClass}`;

        if (isLoading) {
            messageDiv.id = `loading-${Date.now()}`;
        }

        const roleLabel = role === 'user' ? 'Vous' : 'ShadyGPT';

        messageDiv.innerHTML = `
            <strong>${roleLabel}:</strong>
            <p>${content}</p>
        `;

        chatMessages.appendChild(messageDiv);
        chatMessages.scrollTop = chatMessages.scrollHeight;

        return messageDiv.id;
    }

    // Fonction pour supprimer un message
    function removeMessage(messageId) {
        if (messageId) {
            const message = document.getElementById(messageId);
            if (message) {
                message.remove();
            }
        }
    }

    // Version avec streaming (optionnel, pour plus tard)
    async function sendMessageStreaming(message, context) {
        const eventSource = new EventSource('/api/chat/stream');

        eventSource.onmessage = function(event) {
            if (event.data === '[DONE]') {
                eventSource.close();
                return;
            }

            if (event.data.startsWith('[ERROR]')) {
                addMessage('assistant', event.data.replace('[ERROR]', ''), false, 'error');
                eventSource.close();
                return;
            }

            // Ajouter le token à la réponse en streaming
            const lastMessage = chatMessages.lastElementChild;
            if (lastMessage && lastMessage.classList.contains('assistant')) {
                const p = lastMessage.querySelector('p');
                p.textContent += event.data;
            } else {
                addMessage('assistant', event.data);
            }

            chatMessages.scrollTop = chatMessages.scrollHeight;
        };

        eventSource.onerror = function() {
            eventSource.close();
            addMessage('assistant', 'Erreur de streaming', false, 'error');
        };
    }
});
