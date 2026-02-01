# 🔧 Budget 500 Error - Debugging Guide

## 📝 Problem Statement

Frontend sends POST `/budgets` request → Backend returns 500 Internal Server Error

**Current log shows:**
```
POST /budgets
Body: {"amount": 5000, "month": "Février"}
Response: {"message": "Erreur serveur"} (500)
```

---

## 🎯 What I Just Fixed

Enhanced the backend `saveBudget()` function with **comprehensive logging** so we can see exactly what's failing:

```
💰 [BUDGET POST] ===== DÉBUT =====
   Timestamp: ...
   Body reçu: {"amount": 5000, "month": "Février"}
   User ID: 1
   Paramètres extraits: {month: "Février", amount: 5000, category_id: undefined}
   Tentative de parse du format "Février"...
   Parts après split: ["Février"]
   Year: NaN, Month: NaN
   ❌ Format de mois invalide
```

---

## 🚨 Issue Identified: Invalid Month Format

**Problem:** The frontend is sending `"month": "Février"` (French month name)

**Expected:** `"month": "2026-01"` (YYYY-MM format)

### Why it fails:
```javascript
const monthParts = "Février".split("-");  // Returns ["Février"]
const yearNum = parseInt("Février");      // Returns NaN
const monthNumInt = parseInt(undefined);  // Returns NaN

if (isNaN(yearNum) || isNaN(monthNumInt)) {
  return res.status(400).json({ message: "Format de mois invalide" });
}
```

---

## ✅ Solution: Frontend Input Validation

The frontend needs to ensure `budgetMonth` is in the correct format. Currently it's a simple TextInput that accepts anything.

### Option 1: Simple Validation (Quick Fix)
Add validation to show error before sending:

```typescript
const handleAddBudget = async () => {
  // Validate month format
  const monthRegex = /^\d{4}-\d{2}$/;  // Match YYYY-MM
  if (!monthRegex.test(budgetMonth.trim())) {
    Alert.alert("Erreur", "Format invalide!\nUtilisez: YYYY-MM (ex: 2026-02)");
    return;
  }
  
  // ... rest of code
};
```

### Option 2: Month Picker (Better UX)
Replace TextInput with a date/month picker:

```typescript
import DateTimePicker from '@react-native-community/datetimepicker';

const [selectedDate, setSelectedDate] = useState(new Date());

const handleDateChange = (event: any, date: any) => {
  if (date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    setBudgetMonth(`${year}-${month}`);
  }
};
```

---

## 🧪 How to Test After Fix

### Step 1: Wait for Clever Cloud Redeploy
- Latest commit: `329bf96`
- Redeployment: 2-5 minutes

### Step 2: Check Clever Cloud Logs
```
https://console.clever-cloud.com → Your App → Logs
```

Look for the new detailed logs when you try to add a budget:
```
💰 [BUDGET POST] ===== DÉBUT =====
   Body reçu: {...}
   Tentative de parse du format "..."
   ...
```

### Step 3: Try Different Month Formats

**Format ❌ (Will fail):**
- "Février"
- "February"
- "2/2026"
- "02-2026"

**Format ✅ (Will work):**
- "2026-01"
- "2026-02"
- "2026-12"

### Step 4: Check Response

**If month format is wrong (400):**
```json
{
  "message": "Format de mois invalide (utilisez YYYY-MM)"
}
```

**If category_id is missing (400):**
```json
{
  "message": "category_id est requis"
}
```

**If successful (200):**
```json
{
  "message": "Budget ajouté"
}
```

---

## 🛠️ Frontend Fix Required

**File:** `spendioo-new/app/drawer/(tabs)/budget.tsx`

**Current Issue:**
- TextInput accepts any text input
- No validation of YYYY-MM format
- User might enter "Février" or any other value

**Fix:**
```typescript
const handleAddBudget = async () => {
  // 1. Validate format
  const monthRegex = /^\d{4}-\d{2}$/;
  if (!monthRegex.test(budgetMonth.trim())) {
    Alert.alert(
      "Format invalide",
      "Utilisez le format YYYY-MM\n(ex: 2026-02 pour février 2026)"
    );
    return;
  }

  // 2. Rest of code (already correct)
  if (!budgetAmount || isNaN(Number(budgetAmount))) {
    Alert.alert("Erreur", "Le montant doit être un nombre");
    return;
  }

  if (!budgetCategory) {
    Alert.alert("Erreur", "La catégorie est obligatoire");
    return;
  }

  try {
    const payload = {
      month: budgetMonth.trim(),
      amount: Number(budgetAmount),
      category_id: budgetCategory.id,
    };
    // ... rest unchanged
  }
};
```

---

## 📋 Checklist Before Retesting

- [ ] Clever Cloud has redeployed (wait 2-5 minutes)
- [ ] Frontend validates month format is YYYY-MM
- [ ] Category is selected (not undefined)
- [ ] Amount is a valid number
- [ ] Month is between 01-12
- [ ] Check Clever Cloud logs for detailed error messages

---

## 🚀 Next Steps

1. **Add month format validation** to frontend `handleAddBudget()`
2. **Reload Expo** to test with fixed validation
3. **Try adding a budget** with correct format: `2026-02`
4. **Check Clever Cloud logs** to see the detailed debugging output
5. **If still 500:** The logs will show the exact error (SQL error, missing column, etc)

---

## 📊 Expected Flow After Fix

```
User enters: Month="2026-02", Amount="500", Category="Nourriture"
                ↓
Frontend validates format ✅
                ↓
Frontend sends: {month: "2026-02", amount: 500, category_id: 3}
                ↓
Backend receives and logs all parameters ✅
                ↓
Backend parses: year=2026, month=02 ✅
                ↓
Backend queries DB and inserts ✅
                ↓
Response: {message: "Budget ajouté"} (200)
                ↓
Frontend shows alert: "✅ Succès"
```

---

## 💡 Why Better Logging Helps

The new logs will show EXACTLY where it fails:

✅ **If parsing works:** 
```
Year: 2026, Month: 2
```

❌ **If format is wrong:**
```
Parts après split: ["Février"]
Year: NaN, Month: NaN
❌ Format de mois invalide
```

❌ **If SQL fails:**
```
SQL error: Unknown column 'XYZ'
Code: ER_BAD_FIELD_ERROR
```

---

**Status:** Backend improved with logging. Frontend needs month format validation.
