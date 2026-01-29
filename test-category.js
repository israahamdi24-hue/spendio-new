const http = require("http");

// Token obtenu du register
const token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTIsImVtYWlsIjoiYWxpY2UudGVzdEBleGFtcGxlLmNvbSIsImlhdCI6MTc2OTU4NzY5MywiZXhwIjoxNzcwMTkyNDkzfQ.KFY0G9WoHdXaNhrB6k617ihbjKm1nthzqEARL--xya4";

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

console.log("📝 Test d'ajout de catégorie avec token valide...");

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
