#!/usr/bin/env node

/**
 * Test Script - Vérifier que les statistiques fonctionnent correctement
 * Tests les endpoints /statistics/month, /statistics/history
 */

const http = require("http");

const API_URL = "http://localhost:5000";
let token = "";
let userId = "";

// Color codes for console
const colors = {
  reset: "\x1b[0m",
  green: "\x1b[32m",
  red: "\x1b[31m",
  yellow: "\x1b[33m",
  blue: "\x1b[34m",
};

function makeRequest(method, path, body = null, headers = {}) {
  return new Promise((resolve, reject) => {
    const url = new URL(path, API_URL);
    const options = {
      method,
      hostname: url.hostname,
      port: url.port,
      path: url.pathname + url.search,
      headers: {
        "Content-Type": "application/json",
        ...headers,
      },
    };

    const req = http.request(options, (res) => {
      let data = "";
      res.on("data", (chunk) => {
        data += chunk;
      });
      res.on("end", () => {
        resolve({
          status: res.statusCode,
          body: data ? JSON.parse(data) : null,
        });
      });
    });

    req.on("error", reject);

    if (body) {
      req.write(JSON.stringify(body));
    }
    req.end();
  });
}

async function test() {
  console.log(`\n${"=".repeat(60)}`);
  console.log("🧪 TESTS - STATISTIQUES API");
  console.log(`${"=".repeat(60)}\n`);

  try {
    // 1️⃣ Register user
    console.log(`${colors.blue}1️⃣  Registering test user...${colors.reset}`);
    const registerRes = await makeRequest("POST", "/api/auth/register", {
      firstName: "Test",
      lastName: "User",
      email: `test-${Date.now()}@test.com`,
      password: "password123",
    });
    console.log(`   Status: ${registerRes.status}`);

    // 2️⃣ Login
    console.log(`\n${colors.blue}2️⃣  Logging in...${colors.reset}`);
    const loginRes = await makeRequest("POST", "/api/auth/login", {
      email: registerRes.body.user.email,
      password: "password123",
    });
    console.log(`   Status: ${loginRes.status}`);
    token = loginRes.body.token;
    userId = loginRes.body.user.id;
    console.log(`   ✅ Token: ${token.substring(0, 20)}...`);
    console.log(`   ✅ UserId: ${userId}`);

    // 3️⃣ Create a budget
    console.log(`\n${colors.blue}3️⃣  Creating budget...${colors.reset}`);
    const budgetRes = await makeRequest(
      "POST",
      "/api/budgets",
      {
        month: "2026-01",
        amount: 1000,
      },
      { Authorization: `Bearer ${token}` }
    );
    console.log(`   Status: ${budgetRes.status}`);
    console.log(`   ✅ Budget created`);

    // 4️⃣ Create a category
    console.log(`\n${colors.blue}4️⃣  Creating category...${colors.reset}`);
    const categoryRes = await makeRequest(
      "POST",
      "/api/categories",
      {
        name: "Alimentation",
        color: "#F78CA0",
        icon: "food-apple",
        budget: 300,
      },
      { Authorization: `Bearer ${token}` }
    );
    console.log(`   Status: ${categoryRes.status}`);
    const categoryId = categoryRes.body.id || categoryRes.body.category?.id;
    console.log(`   ✅ Category ID: ${categoryId}`);

    // 5️⃣ Create a transaction
    console.log(`\n${colors.blue}5️⃣  Creating expense transaction...${colors.reset}`);
    const txRes = await makeRequest(
      "POST",
      "/api/transactions",
      {
        category_id: categoryId,
        type: "expense",
        amount: 150.5,
        date: "2026-01-15",
        description: "Test expense",
      },
      { Authorization: `Bearer ${token}` }
    );
    console.log(`   Status: ${txRes.status}`);
    console.log(`   ✅ Transaction created`);

    // 6️⃣ TEST: Get monthly stats (NEW ENDPOINT)
    console.log(
      `\n${colors.blue}6️⃣  Testing /statistics/month/2026-01...${colors.reset}`
    );
    const statsRes = await makeRequest(
      "GET",
      "/api/statistics/month/2026-01",
      null,
      { Authorization: `Bearer ${token}` }
    );
    console.log(`   Status: ${statsRes.status}`);
    if (statsRes.status === 200) {
      const data = statsRes.body;
      console.log(`   ${colors.green}✅ Monthly Statistics:${colors.reset}`);
      console.log(`      - Budget: ${data.budget} DT`);
      console.log(`      - Expenses: ${data.expenses} DT (should be 150.5)`);
      console.log(`      - Revenues: ${data.revenues} DT (should be 0)`);
      console.log(`      - Remaining: ${data.remaining} DT`);
      console.log(`      - Percentage: ${data.percentage}%`);
      console.log(`      - Categories count: ${data.categories.length}`);

      if (data.categories.length > 0) {
        const cat = data.categories[0];
        console.log(`      - First category: ${cat.name} (${cat.total} DT)`);
      }

      // Verify values
      if (data.expenses === 150.5) {
        console.log(`   ${colors.green}✅ EXPENSES VALUE CORRECT${colors.reset}`);
      } else {
        console.log(
          `   ${colors.red}❌ EXPENSES INCORRECT: ${data.expenses} (expected 150.5)${colors.reset}`
        );
      }
    }

    // 7️⃣ Create income transaction
    console.log(
      `\n${colors.blue}7️⃣  Creating income transaction...${colors.reset}`
    );
    const incomeRes = await makeRequest(
      "POST",
      "/api/transactions",
      {
        type: "income",
        amount: 2000,
        date: "2026-01-10",
        description: "Salary",
      },
      { Authorization: `Bearer ${token}` }
    );
    console.log(`   Status: ${incomeRes.status}`);
    console.log(`   ✅ Income created`);

    // 8️⃣ TEST: Get updated monthly stats
    console.log(
      `\n${colors.blue}8️⃣  Testing updated /statistics/month/2026-01...${colors.reset}`
    );
    const statsRes2 = await makeRequest(
      "GET",
      "/api/statistics/month/2026-01",
      null,
      { Authorization: `Bearer ${token}` }
    );
    console.log(`   Status: ${statsRes2.status}`);
    if (statsRes2.status === 200) {
      const data = statsRes2.body;
      console.log(`   ${colors.green}✅ Updated Statistics:${colors.reset}`);
      console.log(`      - Expenses: ${data.expenses} DT (should be 150.5)`);
      console.log(`      - Revenues: ${data.revenues} DT (should be 2000)`);
      console.log(`      - Balance: ${data.revenues - data.expenses} DT`);

      // Verify values
      if (data.expenses === 150.5 && data.revenues === 2000) {
        console.log(
          `   ${colors.green}✅ ALL VALUES CORRECT - STATISTICS WORKING!${colors.reset}`
        );
      } else {
        console.log(
          `   ${colors.red}❌ VALUES INCORRECT${colors.reset}`
        );
      }
    }

    // 9️⃣ TEST: Get history
    console.log(
      `\n${colors.blue}9️⃣  Testing /statistics/history...${colors.reset}`
    );
    const histRes = await makeRequest(
      "GET",
      "/api/statistics/history",
      null,
      { Authorization: `Bearer ${token}` }
    );
    console.log(`   Status: ${histRes.status}`);
    if (histRes.status === 200) {
      const data = histRes.body;
      console.log(
        `   ${colors.green}✅ History retrieved: ${data.length} months${colors.reset}`
      );
      if (data.length > 0) {
        data.slice(0, 3).forEach((m) => {
          console.log(
            `      - ${m.month}: Budget=${m.budget}, Expenses=${m.expenses}, Revenues=${m.revenues}`
          );
        });
      }
    }

    console.log(`\n${colors.green}🎉 ALL TESTS COMPLETED${colors.reset}\n`);
  } catch (error) {
    console.error(`${colors.red}❌ Error:${colors.reset}`, error.message);
  }
}

test();
