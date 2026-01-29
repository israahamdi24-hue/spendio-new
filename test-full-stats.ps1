# Register and Test Statistics

$BaseURL = "http://192.168.1.6:5000/api"
$Name = "Test User"
$Email = "testuser@example.com"
$Password = "TestPass123"

Write-Host "🧪 Register User & Test Statistics" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan

# Step 1: Register User
Write-Host "`n1️⃣  Registering user..." -ForegroundColor Yellow
$RegisterBody = @{
    name = $Name
    email = $Email
    password = $Password
} | ConvertTo-Json

try {
    $RegisterResponse = Invoke-RestMethod -Uri "$BaseURL/auth/register" -Method POST -Body $RegisterBody -ContentType "application/json"
    $Token = $RegisterResponse.token
    $UserId = $RegisterResponse.user.id
    
    Write-Host "✅ Registration successful!" -ForegroundColor Green
    Write-Host "   User ID: $UserId" -ForegroundColor Gray
    Write-Host "   Email: $Email" -ForegroundColor Gray
    Write-Host "   Token: $($Token.Substring(0, 20))..." -ForegroundColor Gray
} catch {
    Write-Host "❌ Registration failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Create headers with token
$Headers = @{
    "Authorization" = "Bearer $Token"
    "Content-Type" = "application/json"
}

# Step 2: Create Categories
Write-Host "`n2️⃣  Creating sample categories..." -ForegroundColor Yellow
$Categories = @(
    @{ name = "Alimentation"; color = "#F78CA0"; budget = 500; icon = "food" },
    @{ name = "Transport"; color = "#4ECDC4"; budget = 300; icon = "car" },
    @{ name = "Loisirs"; color = "#FFE66D"; budget = 200; icon = "games" }
)

$CreatedCategories = @()
foreach ($cat in $Categories) {
    try {
        $Body = $cat | ConvertTo-Json
        $Response = Invoke-RestMethod -Uri "$BaseURL/categories" -Method POST -Body $Body -Headers $Headers
        $CreatedCategories += $Response
        Write-Host "   ✅ Created: $($cat.name)" -ForegroundColor Green
    } catch {
        Write-Host "   ❌ Error creating $($cat.name): $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Step 3: Set Budget
Write-Host "`n3️⃣  Setting monthly budget..." -ForegroundColor Yellow
$BudgetBody = @{
    month = "2026-01"
    amount = 1000
} | ConvertTo-Json

try {
    $BudgetResponse = Invoke-RestMethod -Uri "$BaseURL/budgets" -Method POST -Body $BudgetBody -Headers $Headers
    Write-Host "✅ Budget set: 1000 DT for 2026-01" -ForegroundColor Green
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 4: Create Transactions
Write-Host "`n4️⃣  Creating sample transactions..." -ForegroundColor Yellow
$Transactions = @(
    @{ 
        category_id = if ($CreatedCategories.Count -gt 0) { $CreatedCategories[0].id } else { 1 }
        description = "Groceries"
        amount = 75.50
        type = "expense"
        date = "2026-01-05"
    },
    @{
        category_id = if ($CreatedCategories.Count -gt 1) { $CreatedCategories[1].id } else { 2 }
        description = "Bus fare"
        amount = 15
        type = "expense"
        date = "2026-01-06"
    },
    @{
        category_id = if ($CreatedCategories.Count -gt 2) { $CreatedCategories[2].id } else { 3 }
        description = "Movie"
        amount = 25
        type = "expense"
        date = "2026-01-10"
    },
    @{
        description = "Salary"
        amount = 2000
        type = "income"
        date = "2026-01-01"
    }
)

foreach ($trans in $Transactions) {
    try {
        $Body = $trans | ConvertTo-Json
        $Response = Invoke-RestMethod -Uri "$BaseURL/transactions" -Method POST -Body $Body -Headers $Headers
        Write-Host "   ✅ Created: $($trans.description)" -ForegroundColor Green
    } catch {
        Write-Host "   ❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Step 5: Get Categories
Write-Host "`n5️⃣  Getting categories..." -ForegroundColor Yellow
try {
    $Categories = Invoke-RestMethod -Uri "$BaseURL/categories" -Method GET -Headers $Headers
    Write-Host "✅ Categories found: $($Categories.Count)" -ForegroundColor Green
    $Categories | ForEach-Object {
        $total = if ($_.total) { $_.total } else { 0 }
        Write-Host "   - $($_.name): Color=$($_.color), Budget=$($_.budget), Total=$total" -ForegroundColor Gray
    }
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 6: Get Monthly Stats
Write-Host "`n6️⃣  Getting monthly stats (2026-01)..." -ForegroundColor Yellow
try {
    $MonthlyStats = Invoke-RestMethod -Uri "$BaseURL/statistics/month/$UserId/2026-01" -Method GET -Headers $Headers
    Write-Host "✅ Monthly Stats:" -ForegroundColor Green
    Write-Host "   Budget:     $($MonthlyStats.budget) DT" -ForegroundColor Gray
    Write-Host "   Expenses:   $($MonthlyStats.expenses) DT" -ForegroundColor Gray
    Write-Host "   Revenues:   $($MonthlyStats.revenues) DT" -ForegroundColor Gray
    Write-Host "   Remaining:  $($MonthlyStats.remaining) DT" -ForegroundColor Gray
    Write-Host "   Percentage: $($MonthlyStats.percentage)%" -ForegroundColor Gray
    Write-Host "   Categories breakdown:" -ForegroundColor Gray
    $MonthlyStats.categories | ForEach-Object {
        Write-Host "      - $($_.name): $($_.total) DT ($($_.count) transactions)" -ForegroundColor Gray
    }
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 7: Get Daily Stats
Write-Host "`n7️⃣  Getting daily stats (2026-01)..." -ForegroundColor Yellow
try {
    $DailyStats = Invoke-RestMethod -Uri "$BaseURL/statistics/daily/$UserId/2026-01" -Method GET -Headers $Headers
    Write-Host "✅ Daily stats found: $($DailyStats.Count) days" -ForegroundColor Green
    $DailyStats | ForEach-Object {
        $day = $_.day.ToString().PadLeft(2, '0')
        if ($_.expenses -gt 0 -or $_.revenues -gt 0) {
            Write-Host "   Day $day`: Expenses=$($_.expenses) DT, Revenues=$($_.revenues) DT" -ForegroundColor Gray
        }
    }
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 8: Get History Stats
Write-Host "`n8️⃣  Getting history stats..." -ForegroundColor Yellow
try {
    $History = Invoke-RestMethod -Uri "$BaseURL/statistics/history/$UserId" -Method GET -Headers $Headers
    Write-Host "✅ History found: $($History.Count) months" -ForegroundColor Green
    $History | ForEach-Object {
        if ($_.budget -gt 0 -or $_.expenses -gt 0 -or $_.revenues -gt 0) {
            Write-Host "   $($_.month): Budget=$($_.budget) DT, Expenses=$($_.expenses) DT, Revenues=$($_.revenues) DT" -ForegroundColor Gray
        }
    }
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n✅ All tests completed!" -ForegroundColor Cyan
Write-Host "`n📊 Summary:" -ForegroundColor Yellow
Write-Host "   User created with ID: $UserId" -ForegroundColor Gray
Write-Host "   Categories created: $($CreatedCategories.Count)" -ForegroundColor Gray
Write-Host "   Transactions created: $($Transactions.Count)" -ForegroundColor Gray
Write-Host "   Budget set: 1000 DT" -ForegroundColor Gray
Write-Host "`n🎉 All systems operational!" -ForegroundColor Green
