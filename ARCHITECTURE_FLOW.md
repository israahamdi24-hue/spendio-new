# 🔄 ARCHITECTURE - FLUX DE DONNÉES & RAFRAÎCHISSEMENT

## 📊 ARCHITECTURE GÉNÉRALE

```
┌─────────────────────────────────────────────────────────┐
│                      APPLICATION                         │
│                                                          │
│  ┌────────────────────────────────────────────────────┐ │
│  │         app/_layout.tsx                            │ │
│  │  ┌──────────────────────────────────────────────┐  │ │
│  │  │ <TransactionRefreshProvider>  🔑 Context    │  │ │
│  │  │                                              │  │ │
│  │  │  ┌──────────────────────────────────────┐   │  │ │
│  │  │  │  Stats Screen                         │   │  │ │
│  │  │  │  • StatCards (Dépenses, Revenus)    │   │  │ │
│  │  │  │  • LineChart (Trends)               │   │  │ │
│  │  │  │  • BarChart (Historique)            │   │  │ │
│  │  │  │  • PieChart (Catégories)            │   │  │ │
│  │  │  │                                      │   │  │ │
│  │  │  │  useStatistics(month) → Hook        │   │  │ │
│  │  │  │  useTransactionRefresh() → Context  │   │  │ │
│  │  │  └──────────────────────────────────────┘   │  │ │
│  │  │                                              │  │ │
│  │  │  ┌──────────────────────────────────────┐   │  │ │
│  │  │  │  Add Transaction Screen              │   │  │ │
│  │  │  │  • Form Input                        │   │  │ │
│  │  │  │  • handleSubmit()                    │   │  │ │
│  │  │  │    └─ triggerRefresh() 🔥            │   │  │ │
│  │  │  │                                      │   │  │ │
│  │  │  └──────────────────────────────────────┘   │  │ │
│  │  │                                              │  │ │
│  │  │  ┌──────────────────────────────────────┐   │  │ │
│  │  │  │  Budget Screen                       │   │  │ │
│  │  │  │  • handleAddCategory()               │   │  │ │
│  │  │  │    └─ triggerRefresh() 🔥            │   │  │ │
│  │  │  │                                      │   │  │ │
│  │  │  └──────────────────────────────────────┘   │  │ │
│  │  │                                              │  │ │
│  │  └──────────────────────────────────────────────┘  │ │
│  │                                                    │ │
│  └────────────────────────────────────────────────────┘ │
│                                                        │
└─────────────────────────────────────────────────────────┘
```

---

## 🔄 FLUX DE RAFRAÎCHISSEMENT - DÉTAIL

### Scénario: Ajouter une Transaction

```
USER ACTION
    │
    ├─→ Clique "Ajouter Transaction"
    │
FORM SCREEN (add.tsx)
    │
    ├─→ Remplit:
    │   • Montant: 100 DT
    │   • Catégorie: Alimentation
    │   • Type: Dépense
    │   • Date: 2026-01-15
    │
    ├─→ Clique "Enregistrer"
    │
HANDLESUBMIT()
    │
    ├─→ POST /api/transactions {
    │   "category_id": 1,
    │   "type": "expense",
    │   "amount": 100,
    │   "date": "2026-01-15",
    │   "description": "..."
    │ }
    │
    ├─→ Success ✅
    │
    ├─→ fetchAll() [catégories]
    │
    ├─→ triggerRefresh() 🔥 ← KEY POINT!
    │
    └─→ Alert + router.back()


TRANSACTION REFRESH CONTEXT
    │
    ├─→ refreshKey: 0 → 1 (increment)
    │
    └─→ Notify all subscribers


USE STATISTICS HOOK (tous les écrans le utilisent)
    │
    ├─→ useEffect([fetchAll, refreshKey])
    │   triggered because refreshKey changed!
    │
    ├─→ fetchAll() exécuté
    │
    ├─→ GET /api/statistics/month/2026-01 {
    │   "Authorization": "Bearer {token}"
    │ }
    │
    ├─→ Backend response:
    │   {
    │     "month": "2026-01",
    │     "budget": 1000,
    │     "expenses": 100,      ← UPDATED!
    │     "revenues": 0,
    │     "remaining": 900,
    │     "percentage": 10,
    │     "categories": [...]
    │   }
    │
    ├─→ setState({
    │     summary,
    │     history,
    │     categories
    │   })
    │
    └─→ Component re-render


STATS SCREEN (stats.tsx)
    │
    ├─→ useMemo recalculates:
    │   • pieData
    │   • lineData
    │   • barData
    │
    ├─→ Render updated:
    │   • StatCards: "Dépenses: 100 DT" ✅
    │   • LineChart: expenses vs revenues
    │   • BarChart: monthly expenses
    │   • PieChart: categories breakdown
    │
    └─→ UI Updated! ✅ < 1 second


RESULT
    │
    └─→ User sees:
        ✅ Success alert
        ✅ Graphs updated immediately
        ✅ Numbers correct
        ✅ Smooth experience
```

---

## 📈 GRAPHIQUE - FLUX DE DONNÉES

```
┌────────────────────────────────────────────────────┐
│            TRANSACTION REFRESH FLOW                 │
└────────────────────────────────────────────────────┘

1. ACTION TRIGGERED
   ├─ Add Transaction
   ├─ Update Transaction
   ├─ Delete Transaction
   └─ Add/Update Category

2. triggerRefresh() CALLED
   │
   └─→ setRefreshKey(prev => prev + 1)

3. CONTEXT VALUE CHANGED
   │
   ├─→ refreshKey: 0 → 1
   └─→ All subscribers notified

4. EFFECT TRIGGERED (useStatistics)
   │
   ├─→ useEffect([fetchAll, refreshKey])
   │   Dependency changed!
   │
   ├─→ fetchAll() executed
   │
   └─→ API calls:
       ├─ GET /statistics/month/:month
       ├─ GET /statistics/history
       └─ Parse response

5. STATE UPDATED (useStatistics)
   │
   ├─→ setSummary({...})
   ├─→ setHistory([...])
   └─→ setCategories([...])

6. COMPONENT RERENDER (stats.tsx)
   │
   ├─→ useMemo recalculates pieData
   ├─→ useMemo recalculates lineData
   ├─→ useMemo recalculates barData
   │
   └─→ JSX rendered with new data

7. UI UPDATED
   │
   └─→ User sees fresh data ✅
```

---

## 🔐 SÉCURITÉ - AUTHENTICATION FLOW

```
FRONTEND (add.tsx)
    │
    ├─→ POST /api/transactions
    │   Headers: {
    │     "Authorization": "Bearer {token}",
    │     "Content-Type": "application/json"
    │   }
    │   Body: {
    │     "category_id": 1,
    │     "type": "expense",
    │     "amount": 100,
    │     "date": "2026-01-15"
    │   }
    │
    └─→ Send to Backend


BACKEND MIDDLEWARE (verifyToken)
    │
    ├─→ Extract token from header
    ├─→ Verify JWT signature
    ├─→ Decode token
    ├─→ Extract user_id
    │
    └─→ req.user = { id, email, ... }


BACKEND CONTROLLER (createTransaction)
    │
    ├─→ const userId = req.user.id ← FROM TOKEN
    ├─→ const { category_id, type, amount, date } = req.body
    │
    ├─→ Validate:
    │   ├─ userId exists
    │   ├─ category_id valid
    │   ├─ type valid (expense/income)
    │   ├─ amount > 0
    │   └─ date valid
    │
    ├─→ INSERT INTO transactions
    │   VALUES (userId, category_id, type, amount, date)
    │
    └─→ RETURN 201 Created


BACKEND STATISTICS (getMonthlyStats)
    │
    ├─→ const userId = req.user.id ← FROM TOKEN (NOT URL!)
    ├─→ const { month } = req.params
    │
    ├─→ Query:
    │   SELECT ... WHERE user_id = ? ← SECURITY!
    │
    └─→ RETURN 200 with stats


SECURITY BENEFITS
    │
    ├─→ ✅ Impossible to see other users' data
    ├─→ ✅ userId cannot be spoofed in URL
    ├─→ ✅ All requests verified by token
    └─→ ✅ JWT prevents unauthorized access
```

---

## 📊 ENDPOINT COMPARISON

### BEFORE (❌ Problematic)

```
GET /api/statistics/month/123/2026-01

Problems:
❌ userId in URL (spoofable)
❌ Can access any user's data (if guess their ID)
❌ Unnecessary parameter duplication
❌ Less secure

Request Flow:
User 123 → GET /month/123/2026-01
User 456 → GET /month/456/2026-01

Vulnerability:
Attacker → GET /month/999/2026-01 ← Can access other user!
```

### AFTER (✅ Secure)

```
GET /api/statistics/month/2026-01
Authorization: Bearer eyJhbGc...

Benefits:
✅ userId from JWT token
✅ Cannot access other users' data
✅ Simplified URL
✅ More secure

Request Flow:
User 123 (token) → GET /month/2026-01 → Backend extracts userId=123
User 456 (token) → GET /month/2026-01 → Backend extracts userId=456

Security:
Attacker (invalid token) → 401 Unauthorized ✅
Attacker (other user's token) → Gets other user's data (still need valid token)
```

---

## 🔗 DATA FLOW - DATABASE TO UI

```
┌─────────────────────────────────────────────────────┐
│              DATABASE (MySQL)                        │
│                                                     │
│  transactions (id, user_id, category_id, ...)     │
│  categories (id, name, color, ...)                │
│  budgets (id, user_id, month, amount)             │
└─────────────────────────────────────────────────────┘
                      │
                      │ SQL Queries
                      ▼
┌─────────────────────────────────────────────────────┐
│           BACKEND Controllers                        │
│                                                     │
│  getMonthlyStats():                                │
│  ├─ SUM(amount) WHERE type='expense'               │
│  ├─ SUM(amount) WHERE type='income'                │
│  ├─ COUNT transactions per category                │
│  └─ Calculate remaining, percentage                │
│                                                     │
│  Response:                                          │
│  {                                                  │
│    "expenses": 100,    ← REAL VALUE                │
│    "revenues": 2000,   ← REAL VALUE                │
│    "categories": [...]                             │
│  }                                                  │
└─────────────────────────────────────────────────────┘
                      │
                      │ JSON Response
                      ▼
┌─────────────────────────────────────────────────────┐
│           FRONTEND API Client                        │
│                                                     │
│  api.get('/statistics/month/2026-01')              │
│  .then(response => response.data)                  │
│  .then(data => setState(data))                     │
└─────────────────────────────────────────────────────┘
                      │
                      │ State Update
                      ▼
┌─────────────────────────────────────────────────────┐
│           React Hook (useStatistics)                │
│                                                     │
│  setSummary({                                       │
│    expenses: 100,      ← NOW IN STATE               │
│    revenues: 2000,     ← NOW IN STATE               │
│    ...                                              │
│  })                                                 │
│                                                     │
│  setHistory([...])                                  │
│  setCategories([...])                              │
└─────────────────────────────────────────────────────┘
                      │
                      │ Re-render with new props
                      ▼
┌─────────────────────────────────────────────────────┐
│           React Components                           │
│                                                     │
│  <StatCard>                                         │
│    Dépenses: {summary.expenses} DT ← 100 ✅        │
│    Revenus: {summary.revenues} DT ← 2000 ✅        │
│  </StatCard>                                        │
│                                                     │
│  <LineChart data={lineData} />                     │
│  <BarChart data={barData} />                       │
│  <PieChart data={pieData} />                       │
└─────────────────────────────────────────────────────┘
                      │
                      ▼
              📱 USER SEES CORRECT DATA! ✅
```

---

## 🎯 CRITICAL SUCCESS FACTORS

```
1. triggerRefresh() CALL ✅
   └─ Must be called after every data change
   └─ Implemented in add.tsx ✅
   └─ Implemented in budget.tsx ✅

2. Context Wrapper ✅
   └─ TransactionRefreshProvider envelops entire app
   └─ Implemented in app/_layout.tsx ✅

3. Hook Listener ✅
   └─ useStatistics listens to refreshKey
   └─ useEffect([fetchAll, refreshKey])
   └─ Implemented in useStatistics.ts ✅

4. Correct Endpoints ✅
   └─ Frontend: /statistics/month/:month
   └─ Backend: No userId in URL
   └─ userId from JWT token

5. Real Data ✅
   └─ Backend returns expenses, revenues
   └─ Not calculated/estimated
   └─ From actual transactions table
```

---

## 🧪 TESTING FLOW

```
MANUAL TEST

1. Setup
   ├─ Start backend server
   └─ Start frontend app

2. Add Transaction
   ├─ Click "Add Transaction"
   ├─ Fill form
   ├─ Submit
   │
   ├─→ Backend:
   │   POST /api/transactions ✅
   │   INSERT into database ✅
   │
   ├─→ Frontend:
   │   triggerRefresh() ✅
   │   refreshKey++ ✅
   │   useStatistics.fetchAll() ✅
   │   GET /statistics/month/2026-01 ✅
   │   setState() ✅
   │
   └─→ Result:
       ✅ UI Updates < 1 second
       ✅ Graphs refresh immediately
       ✅ Numbers correct

3. Verify Data
   ├─ Check StatCard values
   ├─ Check graph data
   ├─ Check calculations
   └─ All should match database

RESULT
└─ ✅ Everything works!
```

---

## 📝 SUMMARY

**Key Architecture Decisions:**

1. **Event-based refresh** (not polling)
   - ✅ More efficient
   - ✅ Real-time updates
   - ✅ Better UX

2. **Global context** (TransactionRefreshContext)
   - ✅ All screens can listen
   - ✅ Single source of truth
   - ✅ Easy to extend

3. **Secure endpoints** (userId from token)
   - ✅ No URL spoofing possible
   - ✅ JWT verification required
   - ✅ Better security

4. **Real data from backend** (not calculated)
   - ✅ Always accurate
   - ✅ Consistent with database
   - ✅ No sync issues

