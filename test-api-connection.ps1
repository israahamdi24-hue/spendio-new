# 🔍 Script de diagnostic API - Backend/Frontend
# Utilisation: ./test-api-connection.ps1

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "🔗 TEST DE CONNEXION API" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$BackendIP = "192.168.1.20"
$BackendPort = "5000"
$BackendURL = "http://${BackendIP}:${BackendPort}"
$APIEndpoint = "${BackendURL}/api/auth/login"

Write-Host "📋 Configuration détectée:" -ForegroundColor Yellow
Write-Host "   Backend URL: $BackendURL"
Write-Host "   API Endpoint: $APIEndpoint"
Write-Host ""

# ============================================
# TEST 1 - Vérifier que le backend répond
# ============================================
Write-Host "TEST 1️⃣  - Vérifier que le backend répond" -ForegroundColor Magenta
Write-Host "   Connexion à: $BackendURL"

try {
    $response = Invoke-WebRequest -Uri "$BackendURL/" -UseBasicParsing -TimeoutSec 5 -ErrorAction Stop
    Write-Host "   ✅ Backend accessible!" -ForegroundColor Green
    Write-Host "   Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "   Response: $($response.Content)" -ForegroundColor Gray
    $backendOK = $true
} catch {
    Write-Host "   ❌ Backend non accessible" -ForegroundColor Red
    Write-Host "   Erreur: $($_.Exception.Message)" -ForegroundColor Red
    $backendOK = $false
}
Write-Host ""

# ============================================
# TEST 2 - Tester l'endpoint API
# ============================================
if ($backendOK) {
    Write-Host "TEST 2️⃣  - Tester l'endpoint API" -ForegroundColor Magenta
    Write-Host "   Connexion à: $APIEndpoint"
    
    try {
        $response = Invoke-WebRequest -Uri $APIEndpoint `
            -Method POST `
            -Headers @{"Content-Type"="application/json"} `
            -Body '{"email":"test@test.com","password":"test"}' `
            -UseBasicParsing `
            -TimeoutSec 5 `
            -ErrorAction SilentlyContinue
        
        Write-Host "   ✅ API endpoint accessible!" -ForegroundColor Green
        Write-Host "   Status: $($response.StatusCode)" -ForegroundColor Green
    } catch {
        # Les erreurs 4xx/5xx JSON sont normales (pas d'erreur de connexion)
        if ($_.Exception.Response) {
            Write-Host "   ✅ API endpoint accessible!" -ForegroundColor Green
            Write-Host "   Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Green
        } else {
            Write-Host "   ❌ API endpoint non accessible" -ForegroundColor Red
            Write-Host "   Erreur: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
} else {
    Write-Host "TEST 2️⃣  - Tester l'endpoint API" -ForegroundColor Magenta
    Write-Host "   ⏭️  Sauté (backend non accessible)" -ForegroundColor Yellow
}
Write-Host ""

# ============================================
# TEST 3 - Vérifier l'IP locale
# ============================================
Write-Host "TEST 3️⃣  - Vérifier l'IP locale" -ForegroundColor Magenta

$ipConfig = ipconfig | Select-String "IPv4"
Write-Host "   Adresses IP locales détectées:" -ForegroundColor Gray

foreach ($line in $ipConfig) {
    if ($line -match '192\.168\.1\.') {
        Write-Host "   ✅ $line" -ForegroundColor Green
    } else {
        Write-Host "   📍 $line" -ForegroundColor Gray
    }
}
Write-Host ""

# ============================================
# TEST 4 - Vérifier le pare-feu port 5000
# ============================================
Write-Host "TEST 4️⃣  - Vérifier le pare-feu Windows (port 5000)" -ForegroundColor Magenta

$firewallRule = Get-NetFirewallRule -DisplayName "*Express*5000*" -ErrorAction SilentlyContinue

if ($firewallRule) {
    Write-Host "   ✅ Règle pare-feu trouvée!" -ForegroundColor Green
    Write-Host "      Nom: $($firewallRule.DisplayName)" -ForegroundColor Green
    Write-Host "      Status: $($firewallRule.Enabled)" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  Aucune règle pare-feu pour le port 5000" -ForegroundColor Yellow
    Write-Host "   💡 Solution: Exécute ce script en Admin et relance-le" -ForegroundColor Cyan
}
Write-Host ""

# ============================================
# TEST 5 - Vérifier la configuration API
# ============================================
Write-Host "TEST 5️⃣  - Vérifier la configuration API" -ForegroundColor Magenta

$configFile = ".\spendioo-new\src\config\api.config.ts"

if (Test-Path $configFile) {
    $content = Get-Content $configFile
    if ($content -match "192\.168\.1\.20:5000") {
        Write-Host "   ✅ Configuration API correcte!" -ForegroundColor Green
        Write-Host "   📄 Fichier: $configFile" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  Configuration API à mettre à jour" -ForegroundColor Yellow
        Write-Host "   📄 Fichier: $configFile" -ForegroundColor Yellow
        Write-Host "   💡 BASE_URL doit être: http://192.168.1.20:5000/api" -ForegroundColor Cyan
    }
} else {
    Write-Host "   ❌ Fichier config non trouvé" -ForegroundColor Red
    Write-Host "   📄 Attendu: $configFile" -ForegroundColor Red
}
Write-Host ""

# ============================================
# RÉSUMÉ
# ============================================
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "📊 RÉSUMÉ DU DIAGNOSTIC" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

if ($backendOK) {
    Write-Host "✅ Backend est accessible sur $BackendURL" -ForegroundColor Green
    Write-Host "✅ API est fonctionnelle" -ForegroundColor Green
    Write-Host "✅ Vous pouvez lancer l'app Expo!" -ForegroundColor Green
} else {
    Write-Host "❌ Backend N'EST PAS accessible" -ForegroundColor Red
    Write-Host ""
    Write-Host "Dépannage:" -ForegroundColor Yellow
    Write-Host "1️⃣  Vérifie que le backend est lancé (npm run dev)" -ForegroundColor Yellow
    Write-Host "2️⃣  Vérifie l'adresse IP du backend (doit être 192.168.1.20)" -ForegroundColor Yellow
    Write-Host "3️⃣  Vérifie que le port 5000 est ouvert au pare-feu" -ForegroundColor Yellow
    Write-Host "4️⃣  Assure-toi que PC et téléphone sont sur le même réseau" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Pour plus d'infos: voir CONFIGURATION_API_COMPLETE.md" -ForegroundColor Cyan
Write-Host ""
