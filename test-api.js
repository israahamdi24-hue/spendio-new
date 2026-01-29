const http = require("http");

// D'abord, faire un login pour obtenir un token valide
const loginData = JSON.stringify({
  email: "alice@example.com",
  password: "password123",
});

const loginOptions = {
  hostname: "127.0.0.1",
  port: 5000,
  path: "/api/auth/login",
  method: "POST",
  headers: {
    "Content-Type": "application/json",
    "Content-Length": loginData.length,
  },
};

console.log("📝 Tentative de login...");

const loginReq = http.request(loginOptions, (res) => {
  let body = "";
  res.on("data", (chunk) => (body += chunk));
  res.on("end", () => {
    console.log("Status Login:", res.statusCode);
    const response = JSON.parse(body);
    console.log("Login Response:", response);

    if (response.token) {
      testAddCategory(response.token);
    }
  });
});

loginReq.on("error", (error) => console.error("Login Error:", error));
loginReq.write(loginData);
loginReq.end();

// Ensuite, utiliser le token pour ajouter une catégorie
function testAddCategory(token) {
  console.log("\n📝 Test d'ajout de catégorie avec token valide...");

  const categoryData = JSON.stringify({
    name: "Test Alimentation",
    color: "#cddc39ff",
    budget: 500,
  });

  const categoryOptions = {
    hostname: "127.0.0.1",
    port: 5000,
    path: "/api/categories",
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Content-Length": categoryData.length,
      "Authorization": `Bearer ${token}`,
    },
  };

  const categoryReq = http.request(categoryOptions, (res) => {
    let body = "";
    res.on("data", (chunk) => (body += chunk));
    res.on("end", () => {
      console.log("Status Category:", res.statusCode);
      console.log("Category Response:", body);
    });
  });

  categoryReq.on("error", (error) => console.error("Category Error:", error));
  categoryReq.write(categoryData);
  categoryReq.end();
}
