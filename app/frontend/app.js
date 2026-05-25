const API_URL = "";
let currentUser = {};
let sentMessages = [];

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
    currentUser = data.user;

    document.getElementById("registerBox").classList.add("hidden");
    document.getElementById("loginBox").classList.add("hidden");
    document.getElementById("dashboard").classList.remove("hidden");

    document.getElementById("profileName").innerText = currentUser.name;
    document.getElementById("profileEmail").innerText = currentUser.email;

    showSection("inbox");
  } else {
    alert("Invalid login");
  }
}

function showSection(sectionId) {
  const sections = document.querySelectorAll(".section");
  sections.forEach(section => section.classList.add("hidden"));
  document.getElementById(sectionId).classList.remove("hidden");
}

function sendMessage() {
  const to = document.getElementById("toEmail").value;
  const subject = document.getElementById("subject").value;
  const body = document.getElementById("messageBody").value;

  if (!to || !subject || !body) {
    alert("Please complete all message fields.");
    return;
  }

  sentMessages.push({ to, subject, body });

  const sentDiv = document.getElementById("sentMessages");
  sentDiv.innerHTML += `
    <div class="message">
      <strong>To: ${to}</strong>
      <p><strong>Subject:</strong> ${subject}</p>
      <p>${body}</p>
    </div>
  `;

  document.getElementById("toEmail").value = "";
  document.getElementById("subject").value = "";
  document.getElementById("messageBody").value = "";

  alert("Message sent successfully.");
  showSection("sent");
}

function logout() {
  currentUser = {};
  document.getElementById("dashboard").classList.add("hidden");
  document.getElementById("registerBox").classList.remove("hidden");
  document.getElementById("loginBox").classList.remove("hidden");
}