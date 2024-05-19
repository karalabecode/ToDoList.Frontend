onload = () => {
  const loginForm = document.getElementById('login-form');

  loginForm.onsubmit = (event) => {
    event.preventDefault();
    const username = document.getElementById('username');
    alert(`Hello, ${username.value}`);
    return false;
  };
};