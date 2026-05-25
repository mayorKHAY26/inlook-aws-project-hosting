const API_URL = "http://localhost:5000";

async function register() {
  const name = document.getElementById("registerName").value;
  const email = document.getElementById("registerEmail").value;
  const password = document.getElementById("registerPassword").value;

  const response = await fetch(`${API_URL}/register`, {
    method: "POST",
    headers: {"Content-Type": "application/json"},
    body: JSON.stringify({ name, email, password })
  });

  const data = await response.json();
  alert(data.message);
}

async function login() {
  const email = document.getElementById("loginEmail").value;
  const password = document.getElementById("loginPassword").value;

  const response = await fetch(`${API_URL}/login`, {
    method: "POST",
    headers: {"Content-Type": "application/json"},
    body: JSON.stringify({ email, password })
  });

  const data = await response.json();

  if (data.success) {
    document.getElementById("dashboard").classList.remove("hidden");
    alert("Login successful");
  } else {
    alert("Invalid login");
  }
}

function logout() {
  document.getElementById("dashboard").classList.add("hidden");
  alert("Logged out");
}