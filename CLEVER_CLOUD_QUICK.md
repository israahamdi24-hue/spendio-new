# ⚡ QUICK START - Clever Cloud Backend

## ✅ Configuration Mise à Jour

URLs frontend **maintenant pointent vers Clever Cloud** ✅

```typescript
BASE_URL: 'https://app-92fbc2c7-21cc-4f40-beb1-ff76864f76f9.cleverapps.io/api'
```

---

## 🚀 3 Étapes pour Tester

### 1. Nettoyer le Cache Expo

```bash
cd spendioo-new
npx expo start -c
```

### 2. Vérifier les Logs

Cherche dans le terminal Expo:
```
🔗 API Service initialisé avec: https://app-92fbc2c7-21cc-4f40-beb1-ff76864f76f9.cleverapps.io/api
```

### 3. Scanne le QR Code

Ouvre Expo Go sur ton téléphone et scanne!

---

## ✨ Résultat Attendu

✅ App se charge en 10-20 secondes  
✅ Login fonctionne  
✅ Dashboard affiche les données  
✅ Pas d'erreur réseau  

---

## 🆘 Si Problème

**Erreur "Cannot fetch"?**
```bash
npx expo start -c
```

**Erreur "CORS"?**
→ Backend CORS ✅ (déjà configuré)

**URL incorrecte?**
→ Vérifie `src/services/api.ts`

---

**C'est tout! 🎉 App est prête!**
