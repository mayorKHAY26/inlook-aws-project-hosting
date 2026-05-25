const express = require("express");
const router = express.Router();

const users = [];

router.post("/register", (req, res) => {
  const { name, email, password } = req.body;

  const existingUser = users.find(user => user.email === email);

  if (existingUser) {
    return res.json({
      success: false,
      message: "User already exists"
    });
  }

  users.push({ name, email, password });

  res.json({
    success: true,
    message: "Inlook account created successfully"
  });
});

router.post("/login", (req, res) => {
  const { email, password } = req.body;

  const user = users.find(
    user => user.email === email && user.password === password
  );

  if (!user) {
    return res.json({
      success: false,
      message: "Invalid email or password"
    });
  }

  res.json({
    success: true,
    message: "Login successful",
    user: {
      name: user.name,
      email: user.email
    }
  });
});

router.get("/health", (req, res) => {
  res.json({
    status: "healthy",
    app: "Inlook"
  });
});

module.exports = router;