document.addEventListener('DOMContentLoaded', () => {

    const draggableElement = document.getElementById('draggable-element');
    const dropZone = document.getElementById('drop-zone');
    const instructionArea = document.getElementById('instruction-area');
    const mainForm = document.getElementById('main-form');
    const formElements = mainForm.elements;

    // Rendre l'élément déplaçable
    draggableElement.addEventListener('dragstart', (event) => {
        event.dataTransfer.setData('text/plain', event.target.id);
        setTimeout(() => {
            event.target.style.visibility = 'hidden';
        }, 0);
    });

    draggableElement.addEventListener('dragend', (event) => {
        event.target.style.visibility = 'visible';
    });

    // Gérer la zone de dépôt
    dropZone.addEventListener('dragover', (event) => {
        event.preventDefault();
        dropZone.classList.add('hovered');
    });

    dropZone.addEventListener('dragleave', () => {
        dropZone.classList.remove('hovered');
    });

    dropZone.addEventListener('drop', (event) => {
        event.preventDefault();
        dropZone.classList.remove('hovered');
        const id = event.dataTransfer.getData('text');
        const draggable = document.getElementById(id);

        if (draggable) {
            dropZone.innerHTML = '';
            dropZone.appendChild(draggable);
            draggable.style.visibility = 'hidden';

            instructionArea.classList.remove('disabled');
            for (let i = 0; i < formElements.length; i++) {
                formElements[i].disabled = false;
            }
            instructionArea.querySelector('p').textContent = "Élément placé avec succès ! Vous pouvez maintenant remplir le formulaire.";
        }
    });

    // Icône du chatbot
    const chatbotIcon = document.getElementById('chatbot-icon');
    chatbotIcon.addEventListener('click', (event) => {
        event.preventDefault();
        alert("Le chatbot IA s'ouvrirait ici !");
        // Ici, vous intégreriez la logique pour ouvrir votre chatbot
    });
});
