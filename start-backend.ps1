# 🚀 Script de lancement du Backend (Windows PowerShell)
# Utilisation: .\start-backend.ps1

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "🚀 DÉMARRAGE DU BACKEND SPENDIOO" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$ProjectRoot = "c:\Users\israa\spendionvfrontetback"
$BackendDir = "$ProjectRoot\backend"
$BackendIP = "192.168.1.20"
$BackendPort = "5000"

Write-Host "📋 Vérification..." -ForegroundColor Blue
Write-Host ""

# Vérifier que le dossier backend existe
if (-not (Test-Path $BackendDir)) {
    Write-Host "❌ Dossier backend non trouvé" -ForegroundColor Red
    Write-Host "   Attendu: $BackendDir"
    exit 1
}

Write-Host "✅ Dossier backend trouvé" -ForegroundColor Green
Write-Host "   Chemin: $BackendDir"
Write-Host ""

# Vérifier que node_modules existe
if (-not (Test-Path "$BackendDir\node_modules")) {
    Write-Host "⚠️  node_modules non trouvé" -ForegroundColor Yellow
    Write-Host "   Installation des dépendances..."
    Set-Location $BackendDir
    npm install
    Write-Host ""
}

Write-Host "🔧 Configuration..." -ForegroundColor Blue
Write-Host ""
Write-Host "Backend URL: http://$BackendIP`:$BackendPort"
Write-Host "API URL: http://$BackendIP`:$BackendPort/api"
Write-Host ""

# Vérifier le fichier .env
$envFile = "$BackendDir\.env"
if (-not (Test-Path $envFile)) {
    Write-Host "⚠️  Fichier .env non trouvé" -ForegroundColor Yellow
    Write-Host "   Créant .env par défaut..."
    
    $envContent = @"
PORT=5000
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=
DB_NAME=spendioo
NODE_ENV=development
"@
    
    Set-Content -Path $envFile -Value $envContent
    Write-Host "✅ Fichier .env créé" -ForegroundColor Green
    Write-Host ""
}

Write-Host "🚀 Lancement du serveur..." -ForegroundColor Blue
Write-Host ""
Write-Host "ℹ️  Appuie sur Ctrl+C pour arrêter" -ForegroundColor Yellow
Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

Set-Location $BackendDir

# Vérifier si nodemon est installé dans package.json
$packageJson = Get-Content "package.json" | ConvertFrom-Json
if ($null -ne $packageJson.devDependencies.nodemon) {
    # Utiliser npm run dev (qui utilise nodemon)
    Write-Host "🔄 Hot reload activé (nodemon)" -ForegroundColor Green
    Write-Host ""
    npm run dev
} else {
    # Sinon utiliser node directement
    Write-Host "💡 Astuce: Installe nodemon pour le hot reload" -ForegroundColor Yellow
    Write-Host "   Commande: npm install -D nodemon" -ForegroundColor Yellow
    Write-Host ""
    npm start
}
