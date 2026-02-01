# 🔍 Comment Vérifier les Logs sur Clever Cloud

## ✅ Étapes pour Déboguer l'Erreur 500

### 1️⃣ Accéder aux Logs Clever Cloud

```
1. Va sur https://console.clever-cloud.com
2. Connecte-toi avec tes identifiants
3. Sélectionne ton application (spendioo backend)
4. Clique sur "Logs" dans le menu latéral
5. Cherche "Stdout" ou "Stderr"
```

### 2️⃣ Faire une Requête de Test

**Option A: Avec cURL**
```bash
curl -X POST https://app-92fbc2c7-21cc-4f40-beb1-ff76864f76f9.cleverapps.io/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "123456"
  }'
```

**Option B: Avec Postman**
```
Method: POST
URL: https://app-92fbc2c7-21cc-4f40-beb1-ff76864f76f9.cleverapps.io/api/auth/login
Headers: Content-Type: application/json
Body (raw JSON):
{
  "email": "test@example.com",
  "password": "123456"
}
```

### 3️⃣ Chercher les Logs Pertinents

Après la requête de test, **cherche ces patterns dans les logs Clever Cloud**:

#### 🟢 Si tout fonctionne:
```
🔓 [LOGIN] Tentative avec email: test@example.com
🔍 [LOGIN] Recherche utilisateur avec email: test@example.com
✅ [LOGIN] Requête DB réussie, 1 utilisateur(s) trouvé(s)
👤 [LOGIN] Utilisateur trouvé: ID=1, email=test@example.com
🔐 [LOGIN] Vérification du mot de passe...
✅ [LOGIN] Mot de passe correct
🎫 [LOGIN] Génération du JWT...
✅ [LOGIN] JWT généré avec succès
🎉 [LOGIN] Connexion réussie pour: test@example.com
```

#### 🔴 Si ça échoue à la connexion DB:
```
❌ [DB] Erreur de connexion MySQL:
  Message: connect ECONNREFUSED 127.0.0.1:3306
  Code: PROTOCOL_CONNECTION_LOST
  Errno: ECONNREFUSED
```
**→ Ton backend essaie de se connecter à localhost (127.0.0.1) qui n'existe pas!**

#### 🔴 Si ça échoue au login:
```
❌ [LOGIN] ERREUR: ...
📋 Stack: ...
💬 Message: ...
🔧 Code: ...
```
**→ C'est l'erreur exacte qui te dira ce qui ne va pas**

#### 🔴 Si tu as une erreur 500 generic:
```
❌ [ERROR HANDLER] 2026-01-30T14:25:30.000Z
  Route: POST /api/auth/login
  IP: xxx.xxx.xxx.xxx
  Message: ...
  Code: ...
```

---

## 🛠️ Qu'est-ce que tu dois Chercher

### 🔴 Problème 1: Base de données inaccessible
**Log:**
```
❌ [DB] Erreur de connexion MySQL:
  Message: connect ECONNREFUSED 127.0.0.1:3306
```
**Solution:**
- Ajoute l'add-on MySQL à ton app Clever Cloud
- Configure les variables d'environnement:
  ```
  MYSQL_HOST = [fourni par Clever Cloud]
  MYSQL_USER = [fourni par Clever Cloud]
  MYSQL_PASSWORD = [fourni par Clever Cloud]
  MYSQL_DB = spendio
  ```

### 🔴 Problème 2: Variables d'environnement manquantes
**Log:**
```
🔍 [STARTUP] Configuration de la base de données:
  - Host: localhost
  - User: root
  - Database: spendio
```
**→ Si tu vois "localhost", c'est que `MYSQL_HOST` n'est pas défini!**

**Solution:**
- Vérifie que les vars d'env sont dans Clever Cloud → Variables d'environnement

### 🔴 Problème 3: Erreur dans la requête
**Log:**
```
🔓 [LOGIN] Tentative avec email: test@example.com
❌ [LOGIN] ERREUR: Error: ER_ACCESS_DENIED_ERROR
```
**→ L'erreur dépend du code d'erreur MySQL**

---

## 📋 Checklist de Dépannage

- [ ] Accède à Clever Cloud Console
- [ ] Va dans "Logs"
- [ ] Fais une requête POST à `/api/auth/login`
- [ ] Cherche le pattern `[LOGIN]` dans les logs
- [ ] Note le message d'erreur exact
- [ ] Cherche le pattern `[DB]` si présent
- [ ] Cherche le pattern `[ERROR HANDLER]` si présent
- [ ] Lis le message d'erreur et identifie le problème

---

## 🎯 Messages Clés à Noter

**Copie-colle exactement ces patterns dans les logs Clever Cloud:**

1. **`[STARTUP] Configuration de la base de données:`**
   → Vérifie que Host ≠ localhost

2. **`❌ [DB] Erreur de connexion MySQL:`**
   → Copie le Code et Message exactement

3. **`🔓 [LOGIN]`**
   → Ton requête est arrivée au serveur ✅

4. **`❌ [LOGIN] ERREUR:`**
   → Copie le Message et Stack exactement

5. **`🎉 [LOGIN] Connexion réussie`**
   → Tout fonctionne! ✅

---

## 🚀 Après Avoir Identifié le Problème

Une fois que tu as trouvé le message d'erreur exact dans les logs:

1. **Note le message complet**
2. **Dis-moi exactement ce que tu vois dans les logs**
3. **Je pourrai alors proposer la correction appropriée**

---

## 📞 Format pour Me Rapporter l'Erreur

"Voici ce qui apparaît dans les logs Clever Cloud quand je fais POST /auth/login:

```
[Colle ici exactement ce que tu vois dans les logs]
```

Merci!"

---

**Prochaine étape:** Redéploie ton backend avec `git push` et refais le test!
