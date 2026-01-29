#!/usr/bin/env node

/**
 * Script de validation post-corrections
 * Vérifie que tous les bugs ont été corrigés
 */

const fs = require('fs');
const path = require('path');

const checks = [];

function logCheck(name, status, detail = '') {
  checks.push({ name, status, detail });
  const icon = status ? '✅' : '❌';
  const color = status ? '\x1b[32m' : '\x1b[31m';
  console.log(`${color}${icon}\x1b[0m ${name}${detail ? ` - ${detail}` : ''}`);
}

console.log('\n🔍 Vérification des Corrections\n');

// 1. Vérifier profile/_layout.tsx
try {
  const profileLayout = fs.readFileSync(
    path.join(__dirname, 'spendioo-new/app/drawer/profile/_layout.tsx'),
    'utf8'
  );
  const hasStack = profileLayout.includes('Stack') && profileLayout.includes('Stack.Screen');
  const hasProperScreens = 
    profileLayout.includes('profile') &&
    profileLayout.includes('editProfile') &&
    profileLayout.includes('changePassword');
  logCheck('Profile Layout', hasStack && hasProperScreens, 'Stack Navigator configuré');
} catch (e) {
  logCheck('Profile Layout', false, 'Fichier manquant');
}

// 2. Vérifier budget.tsx pour SwipeListView
try {
  const budgetCode = fs.readFileSync(
    path.join(__dirname, 'spendioo-new/app/drawer/(tabs)/budget.tsx'),
    'utf8'
  );
  
  // Vérifier que Slider est importé
  const hasSliderImport = budgetCode.includes('import Slider from "@react-native-community/slider"');
  logCheck('Slider Import', hasSliderImport, '@react-native-community/slider');
  
  // Vérifier que Slider est passé à ColorPicker
  const hasSliderProp = budgetCode.includes('sliderComponent={Slider}');
  logCheck('Slider Prop', hasSliderProp, 'Passé à ColorPicker');
  
  // Vérifier que SwipeListView n'est pas dans ScrollView
  const lines = budgetCode.split('\n');
  let inScrollView = false;
  let hasSwipeInScroll = false;
  for (let i = 0; i < lines.length; i++) {
    if (lines[i].includes('<ScrollView') && lines[i].includes('overview')) {
      inScrollView = true;
    }
    if (inScrollView && lines[i].includes('</ScrollView>')) {
      inScrollView = false;
    }
    if (inScrollView && lines[i].includes('SwipeListView')) {
      hasSwipeInScroll = true;
      break;
    }
  }
  logCheck('SwipeListView Imbrication', !hasSwipeInScroll, 'Correctement séparé du ScrollView');
  
  // Vérifier categories container
  const hasCategoriesContainer = budgetCode.includes('categoriesContainer');
  logCheck('Categories Container', hasCategoriesContainer, 'Vue séparée pour catégories');
  
} catch (e) {
  logCheck('Budget Validation', false, `Erreur: ${e.message}`);
}

// 3. Vérifier les autres fichiers clés
try {
  const authLayout = fs.readFileSync(
    path.join(__dirname, 'spendioo-new/app/(auth)/_layout.tsx'),
    'utf8'
  );
  const hasAuthStack = authLayout.includes('Stack') && authLayout.includes('login');
  logCheck('Auth Layout', hasAuthStack, 'Correctement configuré');
} catch (e) {
  logCheck('Auth Layout', false, 'Fichier manquant');
}

try {
  const drawerLayout = fs.readFileSync(
    path.join(__dirname, 'spendioo-new/app/drawer/_layout.tsx'),
    'utf8'
  );
  const hasCorrectLogout = drawerLayout.includes('router.replace("/(auth)/login")');
  logCheck('Drawer Logout', hasCorrectLogout, 'Redirection vers /(auth)/login');
} catch (e) {
  logCheck('Drawer Layout', false, 'Fichier manquant');
}

// 4. Vérifier package.json pour dependencies
try {
  const pkgJson = JSON.parse(fs.readFileSync(
    path.join(__dirname, 'spendioo-new/package.json'),
    'utf8'
  ));
  
  const hasSliderDep = '@react-native-community/slider' in pkgJson.dependencies;
  logCheck('Slider Dependency', hasSliderDep, '@react-native-community/slider installé');
  
  const hasColorPicker = 'react-native-color-picker' in pkgJson.dependencies;
  logCheck('Color Picker', hasColorPicker, 'Installé');
  
} catch (e) {
  logCheck('Package.json', false, 'Erreur de lecture');
}

// 5. Résumé
console.log('\n📊 RÉSUMÉ\n');
const passed = checks.filter(c => c.status).length;
const total = checks.length;
const percentage = Math.round((passed / total) * 100);

console.log(`✅ ${passed}/${total} vérifications réussies (${percentage}%)\n`);

if (percentage === 100) {
  console.log('🎉 Toutes les corrections sont validées!');
  console.log('\n🚀 Prêt pour déploiement:\n');
  console.log('Terminal 1: cd backend && npm run dev');
  console.log('Terminal 2: cd spendioo-new && npm run dev\n');
} else {
  console.log('⚠️  Certaines vérifications ont échoué. Veuillez vérifier.');
  checks.filter(c => !c.status).forEach(c => {
    console.log(`  - ${c.name}: ${c.detail}`);
  });
  console.log();
}

process.exit(percentage === 100 ? 0 : 1);
