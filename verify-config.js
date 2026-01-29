#!/usr/bin/env node

/**
 * Script de vérification de configuration - Spendioo
 * Vérifie que tout est correctement configuré pour le développement
 */

const fs = require("fs");
const path = require("path");

console.log("🔍 Vérification de la configuration Spendioo...\n");

const checks = [];

// ✅ Vérifier que les fichiers critiques existent
function checkFileExists(filePath, description) {
  const fullPath = path.join(process.cwd(), filePath);
  const exists = fs.existsSync(fullPath);
  checks.push({
    name: description,
    status: exists ? "✅" : "❌",
    path: filePath,
  });
  return exists;
}

// ✅ Vérifier le contenu d'un fichier
function checkFileContent(filePath, searchString, description) {
  try {
    const fullPath = path.join(process.cwd(), filePath);
    const content = fs.readFileSync(fullPath, "utf-8");
    const contains = content.includes(searchString);
    checks.push({
      name: description,
      status: contains ? "✅" : "❌",
      path: filePath,
      detail: searchString,
    });
    return contains;
  } catch (e) {
    checks.push({
      name: description,
      status: "❌",
      path: filePath,
      detail: e.message,
    });
    return false;
  }
}

console.log("📁 Vérification des fichiers...\n");

// Frontend files
checkFileExists("spendioo-new/app/(auth)/_layout.tsx", "✅ (auth) Layout");
checkFileExists(
  "spendioo-new/app/(auth)/login.tsx",
  "✅ Login page"
);
checkFileExists(
  "spendioo-new/app/(auth)/registre.tsx",
  "✅ Register page"
);
checkFileExists(
  "spendioo-new/app/drawer/_layout.tsx",
  "✅ Drawer Layout"
);

console.log("\n🔗 Vérification de la configuration API...\n");

// API Configuration
checkFileContent(
  "spendioo-new/src/services/api.ts",
  "192.168.1.20:5000",
  "✅ API URL correcte (192.168.1.20)"
);

console.log("\n🔐 Vérification d'AuthContext...\n");

checkFileExists(
  "spendioo-new/src/context/AuthContext.tsx",
  "✅ AuthContext"
);
checkFileContent(
  "spendioo-new/src/context/AuthContext.tsx",
  "login",
  "✅ Méthode login()"
);
checkFileContent(
  "spendioo-new/src/context/AuthContext.tsx",
  "register",
  "✅ Méthode register()"
);
checkFileContent(
  "spendioo-new/src/context/AuthContext.tsx",
  "logout",
  "✅ Méthode logout()"
);

console.log("\n⚙️ Vérification des composants...\n");

checkFileExists(
  "spendioo-new/src/components/AnimatedLogo.tsx",
  "✅ AnimatedLogo"
);
checkFileExists(
  "spendioo-new/src/components/AnimatedTagline.tsx",
  "✅ AnimatedTagline"
);
checkFileExists(
  "spendioo-new/src/components/AuthButton.tsx",
  "✅ AuthButton"
);
checkFileExists(
  "spendioo-new/src/components/CustomAlert.tsx",
  "✅ CustomAlert"
);
checkFileExists(
  "spendioo-new/src/components/FormInput.tsx",
  "✅ FormInput"
);

console.log("\n📊 Résultats de la vérification:\n");

const passed = checks.filter((c) => c.status === "✅").length;
const failed = checks.filter((c) => c.status === "❌").length;

checks.forEach((check) => {
  console.log(`${check.status} ${check.name}`);
});

console.log(`\n📈 Score: ${passed}/${checks.length} vérifications réussies\n`);

if (failed > 0) {
  console.log(`❌ ${failed} problème(s) détecté(s)!`);
  console.log(
    "\n📖 Consultez CONFIGURATION_RESEAU.md pour les solutions\n"
  );
  process.exit(1);
} else {
  console.log("✅ Toutes les vérifications sont passées!");
  console.log("\n🚀 Vous pouvez maintenant démarrer l'application:\n");
  console.log("Terminal 1: cd backend && npm run dev");
  console.log("Terminal 2: cd spendioo-new && npm run dev\n");
}
