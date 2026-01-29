#!/bin/bash

# Test Statistics Endpoints

BASE_URL="http://192.168.1.6:5000/api"
EMAIL="test@example.com"
PASSWORD="password123"

echo "🧪 Testing Statistics Endpoints"
echo "================================"

# Step 1: Login to get token
echo -e "\n1️⃣  Logging in..."
LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}")

TOKEN=$(echo $LOGIN_RESPONSE | grep -o '"token":"[^"]*' | cut -d'"' -f4)
USER_ID=$(echo $LOGIN_RESPONSE | grep -o '"id":[0-9]*' | cut -d':' -f2 | head -1)

if [ -z "$TOKEN" ]; then
  echo "❌ Login failed!"
  echo "Response: $LOGIN_RESPONSE"
  exit 1
fi

echo "✅ Login successful!"
echo "   Token: ${TOKEN:0:20}..."
echo "   User ID: $USER_ID"

# Step 2: Get Categories
echo -e "\n2️⃣  Getting categories..."
CATEGORIES=$(curl -s -X GET "$BASE_URL/categories" \
  -H "Authorization: Bearer $TOKEN")
echo "✅ Categories response:"
echo $CATEGORIES | jq '.' 2>/dev/null || echo $CATEGORIES

# Step 3: Get Transactions
echo -e "\n3️⃣  Getting transactions..."
TRANSACTIONS=$(curl -s -X GET "$BASE_URL/transactions" \
  -H "Authorization: Bearer $TOKEN")
echo "✅ Transactions response:"
echo $TRANSACTIONS | jq '.[0:2]' 2>/dev/null || echo $TRANSACTIONS

# Step 4: Get Monthly Stats
echo -e "\n4️⃣  Getting monthly stats (2026-01)..."
MONTHLY=$(curl -s -X GET "$BASE_URL/statistics/month/$USER_ID/2026-01" \
  -H "Authorization: Bearer $TOKEN")
echo "✅ Monthly stats response:"
echo $MONTHLY | jq '.' 2>/dev/null || echo $MONTHLY

# Step 5: Get Daily Stats
echo -e "\n5️⃣  Getting daily stats (2026-01)..."
DAILY=$(curl -s -X GET "$BASE_URL/statistics/daily/$USER_ID/2026-01" \
  -H "Authorization: Bearer $TOKEN")
echo "✅ Daily stats response:"
echo $DAILY | jq '.' 2>/dev/null || echo $DAILY

# Step 6: Get History Stats
echo -e "\n6️⃣  Getting history stats (last 6 months)..."
HISTORY=$(curl -s -X GET "$BASE_URL/statistics/history/$USER_ID" \
  -H "Authorization: Bearer $TOKEN")
echo "✅ History stats response:"
echo $HISTORY | jq '.' 2>/dev/null || echo $HISTORY

echo -e "\n✅ All tests completed!"
