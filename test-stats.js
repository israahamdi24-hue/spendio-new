#!/usr/bin/env node

/**
 * Test script to verify statistics endpoints
 * Tests categories, transactions, and stats data flow
 */

const axios = require('axios');

const BASE_URL = 'http://192.168.1.6:5000/api';
let authToken = '';
let userId = 1;
const month = '2026-01';

const api = axios.create({
  baseURL: BASE_URL,
  timeout: 5000,
});

// Add token to requests
api.interceptors.request.use((config) => {
  if (authToken) {
    config.headers['Authorization'] = `Bearer ${authToken}`;
  }
  return config;
});

async function runTests() {
  console.log('🧪 Starting Statistics Tests...\n');

  try {
    // Test 1: Login
    console.log('1️⃣  Testing Login...');
    const loginRes = await api.post('/auth/login', {
      email: 'test@example.com',
      password: 'password123',
    });
    authToken = loginRes.data.token;
    userId = loginRes.data.user.id;
    console.log(`✅ Login successful for user ${userId}`);
    console.log(`   Token: ${authToken.substring(0, 20)}...\n`);

    // Test 2: Get Categories
    console.log('2️⃣  Testing Categories...');
    const categoriesRes = await api.get('/categories');
    const categories = categoriesRes.data;
    console.log(`✅ Found ${categories.length} categories`);
    categories.forEach((cat) => {
      console.log(
        `   - ${cat.name} (color: ${cat.color}, budget: ${cat.budget}, total: ${cat.total})`
      );
    });
    console.log();

    // Test 3: Get Transactions
    console.log('3️⃣  Testing Transactions...');
    const transRes = await api.get('/transactions');
    const transactions = transRes.data;
    console.log(`✅ Found ${transactions.length} transactions`);
    if (transactions.length > 0) {
      transactions.slice(0, 3).forEach((t) => {
        console.log(
          `   - ${t.description} (${t.type}): ${t.amount} DT on ${t.date}`
        );
      });
      if (transactions.length > 3) console.log(`   ... and ${transactions.length - 3} more`);
    }
    console.log();

    // Test 4: Get Monthly Stats
    console.log(`4️⃣  Testing Monthly Stats (${month})...`);
    const monthStatsRes = await api.get(`/statistics/month/${userId}/${month}`);
    const monthStats = monthStatsRes.data;
    console.log('✅ Monthly Stats:');
    console.log(`   Budget:     ${monthStats.budget} DT`);
    console.log(`   Expenses:   ${monthStats.expenses} DT`);
    console.log(`   Revenues:   ${monthStats.revenues} DT`);
    console.log(`   Remaining:  ${monthStats.remaining} DT`);
    console.log(`   Percentage: ${monthStats.percentage}%`);
    console.log(`   Categories: ${monthStats.categories.length}`);
    monthStats.categories.forEach((cat) => {
      console.log(
        `      - ${cat.name}: ${cat.total} DT (${cat.count} transactions, budget: ${cat.budget})`
      );
    });
    console.log();

    // Test 5: Get Daily Stats
    console.log(`5️⃣  Testing Daily Stats (${month})...`);
    const dailyStatsRes = await api.get(`/statistics/daily/${userId}/${month}`);
    const dailyStats = dailyStatsRes.data;
    console.log(`✅ Found ${dailyStats.length} days with transactions`);
    if (dailyStats.length > 0) {
      dailyStats.slice(0, 5).forEach((d) => {
        console.log(
          `   Day ${d.day.toString().padStart(2, '0')}: Expenses=${d.expenses} DT, Revenues=${d.revenues} DT`
        );
      });
      if (dailyStats.length > 5) console.log(`   ... and ${dailyStats.length - 5} more days`);
    }
    console.log();

    // Test 6: Get History Stats
    console.log('6️⃣  Testing History Stats (last 6 months)...');
    const historyRes = await api.get(`/statistics/history/${userId}`);
    const history = historyRes.data;
    console.log(`✅ Found ${history.length} months`);
    history.forEach((h) => {
      console.log(
        `   ${h.month}: Budget=${h.budget} DT, Expenses=${h.expenses} DT, Revenues=${h.revenues} DT`
      );
    });
    console.log();

    // Test 7: Verify Data Consistency
    console.log('7️⃣  Verifying Data Consistency...');
    const categoryTotals = monthStats.categories.reduce((sum, cat) => sum + cat.total, 0);
    const expensesFromTransactions = monthStats.expenses;
    
    console.log(`   Category totals sum:  ${categoryTotals} DT`);
    console.log(`   Monthly expenses:     ${expensesFromTransactions} DT`);
    
    if (Math.abs(categoryTotals - expensesFromTransactions) < 0.01) {
      console.log(`✅ ✓ Data is consistent!`);
    } else {
      console.log(`⚠️  ✗ Data mismatch detected!`);
    }
    console.log();

    console.log('🎉 All tests completed successfully!');
  } catch (error) {
    console.error('❌ Error:', error.response?.data || error.message);
    process.exit(1);
  }
}

runTests();
