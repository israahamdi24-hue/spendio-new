#!/bin/bash
# 🚀 Script de lancement du Backend
# Utilisation: ./start-backend.sh (sur Mac/Linux)
# Sur Windows: remplacer les chemins forward slashes

echo "=================================="
echo "🚀 DÉMARRAGE DU BACKEND SPENDIOO"
echo "=================================="
echo ""

# Configuration
PROJECT_ROOT="c:\Users\israa\spendionvfrontetback"
BACKEND_DIR="$PROJECT_ROOT\backend"

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📋 Vérification...${NC}"
echo ""

# Vérifier que le dossier backend existe
if [ ! -d "$BACKEND_DIR" ]; then
    echo -e "${RED}❌ Dossier backend non trouvé${NC}"
    echo "   Attendu: $BACKEND_DIR"
    exit 1
fi

echo -e "${GREEN}✅ Dossier backend trouvé${NC}"
echo ""

# Vérifier que node_modules existe
if [ ! -d "$BACKEND_DIR/node_modules" ]; then
    echo -e "${YELLOW}⚠️  node_modules non trouvé${NC}"
    echo "   Installation des dépendances..."
    cd "$BACKEND_DIR"
    npm install
    echo ""
fi

echo -e "${BLUE}🔧 Configuration...${NC}"
echo ""
echo "Backend URL: http://192.168.1.20:5000"
echo "API URL: http://192.168.1.20:5000/api"
echo ""

# Vérifier le fichier .env
if [ ! -f "$BACKEND_DIR/.env" ]; then
    echo -e "${YELLOW}⚠️  Fichier .env non trouvé${NC}"
    echo "   Créant .env par défaut..."
    cat > "$BACKEND_DIR/.env" << EOF
PORT=5000
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=
DB_NAME=spendioo
NODE_ENV=development
EOF
    echo -e "${GREEN}✅ Fichier .env créé${NC}"
    echo ""
fi

echo -e "${BLUE}🚀 Lancement du serveur...${NC}"
echo ""
echo -e "${YELLOW}ℹ️  Appuie sur Ctrl+C pour arrêter${NC}"
echo ""
echo "=================================="
echo ""

cd "$BACKEND_DIR"

# Vérifier si nodemon est installé
if npm list nodemon > /dev/null 2>&1; then
    # Utiliser nodemon si disponible
    npm run dev
else
    # Sinon utiliser node
    echo -e "${YELLOW}💡 Utilise 'npm install -D nodemon' pour le hot reload${NC}"
    echo ""
    npm start
fi
