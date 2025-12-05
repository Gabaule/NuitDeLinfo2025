document.addEventListener('DOMContentLoaded', () => {
  const navToggle = document.getElementById('navToggle');
  const mainNav = document.getElementById('mainNav');

  if (navToggle && mainNav) {
    navToggle.addEventListener('click', () => {
      mainNav.classList.toggle('open');
    });
  }

  const answers = document.querySelectorAll('.answer');
  answers.forEach((btn) => {
    btn.addEventListener('click', () => {
      answers.forEach((other) => other.classList.remove('active'));
      btn.classList.add('active');
    });
  });
});
