const API_URL = "";

async function register() {
  alert("REGISTER BUTTON CLICKED");

  const name = document.getElementById("registerName").value;
  const email = document.getElementById("registerEmail").value;
  const password = document.getElementById("registerPassword").value;

  try {
    const response = await fetch(`${API_URL}/register`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        name,
        email,
        password
      })
    });

    const data = await response.json();
    alert(data.message);

  } catch (error) {
    alert("Register error: " + error.message);
  }
}

async function login() {
  alert("LOGIN BUTTON CLICKED");

  const email = document.getElementById("loginEmail").value;
  const password = document.getElementById("loginPassword").value;

  try {
    const response = await fetch(`${API_URL}/login`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        email,
        password
      })
    });

    const data = await response.json();

    if (data.success) {
      document.getElementById("dashboard").classList.remove("hidden");
      alert("Login successful");
    } else {
      alert("Invalid login");
    }

  } catch (error) {
    alert("Login error: " + error.message);
  }
}

function logout() {
  alert("LOGOUT CLICKED");
  document.getElementById("dashboard").classList.add("hidden");
}