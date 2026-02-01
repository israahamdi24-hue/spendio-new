# 🔍 DIAGNOSTIC - Erreur 500 sur /auth/login

## ✅ Ce qui Fonctionne

- ✅ Expo se connecte à Clever Cloud (URL publique reçue correctement)
- ✅ POST /auth/login est bien appelé par Expo
- ✅ Requête arrive au serveur Clever Cloud

## ❌ Problème Identifié

Clever Cloud retourne:
```json
{
  "message": "Erreur serveur",
  "status": 500
}
```

Cela signifie que le **backend plante** et pas le frontend.

---

## 🔧 Étapes pour Déboguer

### 1️⃣ Vérifier les Logs Clever Cloud

**Va sur:**
- Clever Cloud console → ton application
- Section **Logs** (ou **Activity**)
- Cherche `[LOGIN]` ou `[ERROR]`

Les logs maintenant contiennent:
```
🔓 [LOGIN] ===== DÉBUT TENTATIVE =====
   Email: test@example.com
   Request body: {...}
   
🔍 [LOGIN] Recherche utilisateur avec email...
✅ [LOGIN] Requête DB réussie, 1 utilisateur(s) trouvé(s)

👤 [LOGIN] Utilisateur trouvé: ID=1, email=test@example.com

🔐 [LOGIN] Vérification du mot de passe...
✅ [LOGIN] Mot de passe correct

🎫 [LOGIN] Génération du JWT...
✅ [LOGIN] JWT généré avec succès

🎉 [LOGIN] ===== CONNEXION RÉUSSIE =====
```

Si tu vois une erreur, elle sera entre ces logs.

### 2️⃣ Tester avec Postman ou curl

**Postman:**
```
Method: POST
URL: https://app-92fbc2c7-21cc-4f40-beb1-ff76864f76f9.cleverapps.io/api/auth/login
Headers: Content-Type: application/json
Body:
{
  "email": "test@example.com",
  "password": "123456"
}
```

**curl (Windows PowerShell):**
```powershell
$body = @{
    email = "test@example.com"
    password = "123456"
} | ConvertTo-Json

$response = Invoke-WebRequest `
  -Uri "https://app-92fbc2c7-21cc-4f40-beb1-ff76864f76f9.cleverapps.io/api/auth/login" `
  -Method POST `
  -Headers @{"Content-Type"="application/json"} `
  -Body $body

$response.Content | ConvertFrom-Json | ConvertTo-Json
```

### 3️⃣ Tester d'abord les Health Checks

Avant de tester le login, vérifie que le serveur répond:

```bash
# Test simple
curl https://app-92fbc2c7-21cc-4f40-beb1-ff76864f76f9.cleverapps.io/

# Test API
curl https://app-92fbc2c7-21cc-4f40-beb1-ff76864f76f9.cleverapps.io/api/test

# Test DB
curl https://app-92fbc2c7-21cc-4f40-beb1-ff76864f76f9.cleverapps.io/api/health/db
```

Attendu:
- `/` → "Bienvenue sur l'API Spendio"
- `/api/test` → `{"message": "✅ API Spendio fonctionne!", ...}`
- `/api/health/db` → `{"status": "✅ Connexion OK", ...}`

---

## 📋 Checklist de Configuration

Clever Cloud Variables d'Environnement (pas le .env local):

- [ ] `MYSQL_HOST` = `bmqq6ec1jz4mi9w5zt27-mysql.services.clever-cloud.com`
- [ ] `MYSQL_USER` = `ub5hqz7gukpvnbr9`
- [ ] `MYSQL_PASSWORD` = `WKAAqtz4RbyQSNY5WTe2`
- [ ] `MYSQL_DB` = `bmqq6ec1jz4mi9w5zt27`
- [ ] `MYSQL_PORT` = `3306`
- [ ] `JWT_SECRET` = quelque chose
- [ ] `NODE_ENV` = `production`

**⚠️ IMPORTANT:** Clever Cloud utilise `MYSQL_*` pas `DB_*` !

Si tu as défini les variables en `.env` local, elles ne seront pas utilisées sur Clever Cloud!

---

## 🚀 Déploiement des Logs

Les améliorations ont été faites à:

1. **backend/src/app.ts** - Error handler global amélioré
2. **backend/src/controllers/authController.ts** - Logs détaillés dans login
3. **backend/src/config/database.ts** - Affiche la config au démarrage

Pour déployer:

```bash
cd backend
git add .
git commit -m "improvement: Add detailed debugging logs for error 500"
git push
```

Clever Cloud va recompiler et redéployer en 2-5 minutes.

---

## 🎯 Ordre de Diagnostic

1. **Attends 2-5 min** que Clever Cloud redéploie
2. **Tente un health check:** `/api/health/db`
   - Si ça marche → serveur répond
   - Si erreur → serveur ne démarre pas
3. **Tente un login:** `/api/auth/login`
4. **Regarde les logs Clever Cloud** pour l'erreur exacte
5. **Partage le log d'erreur** pour qu'on puisse trouver le bug

---

## 🔍 Erreurs Courantes et Solutions

### "Connection timeout"
- Host Clever Cloud pas correct
- MySQL add-on pas activé

### "Connection refused"
- Port pas correct (doit être 3306)
- MySQL not listening

### "Access denied for user"
- Username ou password mauvais
- Vérifier les variables d'env Clever Cloud

### "Unknown database"
- DB_NAME pas correct
- Database pas créée

### "CORS error"
- CORS est activé dans app.ts, donc pas de problème

---

## 💡 Prochaines Étapes

Une fois que tu as vu l'erreur exacte dans les logs:

1. Si c'est une **erreur DB** (Connection refused, Access denied, etc.)
   → On va corriger la configuration Clever Cloud

2. Si c'est une **erreur dans le code** (Cannot read property, etc.)
   → On va fixer le bug

3. Si tout marche! 🎉
   → On teste Expo en fin-à-fin

---

**Prêt? Vas-y, déploie et partage ce que tu vois dans les logs! 📝**
