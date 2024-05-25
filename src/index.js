onload = () => {
  const loginForm = document.getElementById('login-form');

  loginForm.onsubmit = (event) => {
    event.preventDefault();
    const username = document.getElementById('username');

    if (username.value) {
      alert(`Hello, ${username.value}`);
    } else {
      alert("Please set username!");
    }
    return false;
  };
};
