# Test Statistics Endpoints

$BaseURL = "http://192.168.1.6:5000/api"
$Email = "test@example.com"
$Password = "password123"

Write-Host "🧪 Testing Statistics Endpoints" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

# Step 1: Login
Write-Host "`n1️⃣  Logging in..." -ForegroundColor Yellow
$LoginBody = @{
    email = $Email
    password = $Password
} | ConvertTo-Json

$LoginResponse = Invoke-RestMethod -Uri "$BaseURL/auth/login" -Method POST -Body $LoginBody -ContentType "application/json"
$Token = $LoginResponse.token
$UserId = $LoginResponse.user.id

if (-not $Token) {
    Write-Host "❌ Login failed!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Login successful!" -ForegroundColor Green
Write-Host "   Token: $($Token.Substring(0, 20))..." -ForegroundColor Gray
Write-Host "   User ID: $UserId" -ForegroundColor Gray

# Create headers with token
$Headers = @{
    "Authorization" = "Bearer $Token"
    "Content-Type" = "application/json"
}

# Step 2: Get Categories
Write-Host "`n2️⃣  Getting categories..." -ForegroundColor Yellow
try {
    $Categories = Invoke-RestMethod -Uri "$BaseURL/categories" -Method GET -Headers $Headers
    Write-Host "✅ Categories found: $($Categories.Count)" -ForegroundColor Green
    $Categories | ForEach-Object {
        Write-Host "   - $($_.name): Color=$($_.color), Budget=$($_.budget), Total=$($_.total)" -ForegroundColor Gray
    }
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 3: Get Transactions
Write-Host "`n3️⃣  Getting transactions..." -ForegroundColor Yellow
try {
    $Transactions = Invoke-RestMethod -Uri "$BaseURL/transactions" -Method GET -Headers $Headers
    Write-Host "✅ Transactions found: $($Transactions.Count)" -ForegroundColor Green
    $Transactions | Select-Object -First 3 | ForEach-Object {
        Write-Host "   - $($_.description): $($_.type) $($_.amount) DT on $($_.date)" -ForegroundColor Gray
    }
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 4: Get Monthly Stats
Write-Host "`n4️⃣  Getting monthly stats (2026-01)..." -ForegroundColor Yellow
try {
    $MonthlyStats = Invoke-RestMethod -Uri "$BaseURL/statistics/month/$UserId/2026-01" -Method GET -Headers $Headers
    Write-Host "✅ Monthly Stats:" -ForegroundColor Green
    Write-Host "   Budget:     $($MonthlyStats.budget) DT" -ForegroundColor Gray
    Write-Host "   Expenses:   $($MonthlyStats.expenses) DT" -ForegroundColor Gray
    Write-Host "   Revenues:   $($MonthlyStats.revenues) DT" -ForegroundColor Gray
    Write-Host "   Remaining:  $($MonthlyStats.remaining) DT" -ForegroundColor Gray
    Write-Host "   Percentage: $($MonthlyStats.percentage)%" -ForegroundColor Gray
    Write-Host "   Categories: $($MonthlyStats.categories.Count)" -ForegroundColor Gray
    $MonthlyStats.categories | ForEach-Object {
        Write-Host "      - $($_.name): $($_.total) DT ($($_.count) transactions, budget: $($_.budget))" -ForegroundColor Gray
    }
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 5: Get Daily Stats
Write-Host "`n5️⃣  Getting daily stats (2026-01)..." -ForegroundColor Yellow
try {
    $DailyStats = Invoke-RestMethod -Uri "$BaseURL/statistics/daily/$UserId/2026-01" -Method GET -Headers $Headers
    Write-Host "✅ Daily stats found: $($DailyStats.Count) days" -ForegroundColor Green
    $DailyStats | Select-Object -First 5 | ForEach-Object {
        $day = $_.day.ToString().PadLeft(2, '0')
        Write-Host "   Day $day`: Expenses=$($_.expenses) DT, Revenues=$($_.revenues) DT" -ForegroundColor Gray
    }
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 6: Get History Stats
Write-Host "`n6️⃣  Getting history stats (last 6 months)..." -ForegroundColor Yellow
try {
    $History = Invoke-RestMethod -Uri "$BaseURL/statistics/history/$UserId" -Method GET -Headers $Headers
    Write-Host "✅ History found: $($History.Count) months" -ForegroundColor Green
    $History | ForEach-Object {
        Write-Host "   $($_.month): Budget=$($_.budget) DT, Expenses=$($_.expenses) DT, Revenues=$($_.revenues) DT" -ForegroundColor Gray
    }
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 7: Verify Data Consistency
Write-Host "`n7️⃣  Verifying data consistency..." -ForegroundColor Yellow
try {
    $CategoryTotals = ($MonthlyStats.categories | Measure-Object -Property total -Sum).Sum
    $ExpensesFromTransactions = $MonthlyStats.expenses
    
    Write-Host "   Category totals sum:  $CategoryTotals DT" -ForegroundColor Gray
    Write-Host "   Monthly expenses:     $ExpensesFromTransactions DT" -ForegroundColor Gray
    
    if ([Math]::Abs($CategoryTotals - $ExpensesFromTransactions) -lt 0.01) {
        Write-Host "✅ ✓ Data is consistent!" -ForegroundColor Green
    } else {
        Write-Host "⚠️  ✗ Data mismatch detected!" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n🎉 All tests completed!" -ForegroundColor Cyan
