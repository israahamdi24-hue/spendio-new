const http = require("http");

const registerData = JSON.stringify({
  name: "Alice Test",
  email: "alice.test@example.com",
  password: "password123",
});

const registerOptions = {
  hostname: "127.0.0.1",
  port: 5000,
  path: "/api/auth/register",
  method: "POST",
  headers: {
    "Content-Type": "application/json",
    "Content-Length": registerData.length,
  },
};

console.log("📝 Tentative de register...");

const registerReq = http.request(registerOptions, (res) => {
  let body = "";
  res.on("data", (chunk) => (body += chunk));
  res.on("end", () => {
    console.log("Status Register:", res.statusCode);
    console.log("Register Response:", body);
  });
});

registerReq.on("error", (error) => console.error("Register Error:", error));
registerReq.write(registerData);
registerReq.end();
