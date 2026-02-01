# 🚨 DIAGNOSTIC - Erreur 500 sur TOUS les endpoints

## 🔴 Symptômes

- ✅ `/api/test` → 500
- ✅ `/api/health/db` → 500
- ✅ `/api/auth/login` → 500
- ✅ `/api/auth/register` → 500
- ✅ Tous les endpoints → 500

**Conclusion:** Le serveur lui-même ne fonctionne pas ou a crashé au démarrage.

---

## 🔍 Étape 1: Vérifier les Logs Clever Cloud

### Accès aux Logs

1. Va sur: **https://console.clever-cloud.com**
2. Clique sur ton application
3. Onglet **Logs** (ou **Activity** → **Recent Events**)
4. Tu devrais voir les logs du démarrage

### Ou via la CLI

```bash
clever logs --follow
```

---

## 🔎 Ce qu'il Faut Chercher

### ✅ Logs Normaux (Si ça marche)

Tu devrais voir:

```
[INFO] Node.js application started...
[INFO] npm start executed
🔗 [DATABASE CONFIG]
   Host: bmqq6ec1jz4mi9w5zt27-mysql...
   Port: 3306
   User: ub5hqz7gukpvnbr9
   Database: bmqq6ec1jz4mi9w5zt27

🚀 Serveur lancé sur http://0.0.0.0:5000

✅ [DB] Connexion MySQL réussie!
🔧 [DATABASE INIT] Vérification...
✅ [DATABASE INIT] Base de données initialisée avec succès!
```

### ❌ Logs d'Erreur (Si ça plante)

Cherche:

- `error`, `Error`, `ERROR`
- `Cannot find module`
- `SyntaxError`
- `ReferenceError`
- `TypeError`
- `ECONNREFUSED` (BD inaccessible)
- `Access denied`
- `No space left on device`
- `EADDRINUSE` (port déjà utilisé)

---

## 🧪 Étapes de Diagnostic

### 1️⃣ Vérifier que le serveur démarre

**Attendu dans les logs:**
```
🚀 Serveur lancé sur http://0.0.0.0:5000
```

Si tu vois ça → serveur marche
Si tu ne vois pas ça → serveur ne démarre pas

### 2️⃣ Vérifier la connexion DB

**Attendu dans les logs:**
```
✅ [DB] Connexion MySQL réussie!
```

Si tu vois ça → BD accessible
Si tu vois `❌ Erreur de connexion MySQL` → BD inaccessible

### 3️⃣ Vérifier l'initialisation DB

**Attendu:**
```
✅ [DATABASE INIT] Base de données initialisée avec succès!
```

Si pas de message → problème lors de l'initialisation

### 4️⃣ Vérifier les erreurs non gérées

Si le serveur crash, tu verras:
```
Error: ...
    at ...
    at ...
```

**Copie toute la stack trace!**

---

## 🎯 Commandes de Test Immédiates

Une fois que Clever Cloud a redéployé (après ~5 min), teste:

### Test 1: Serveur répond?

```bash
curl -v https://app-92fbc2c7-21cc-4f40-beb1-ff76864f76f9.cleverapps.io/
```

**Attendu:** 
- Status 200
- Body: "Bienvenue sur l'API Spendio"

**Si erreur:**
- Status: ?
- Body: Ce qu'il dit exactement

### Test 2: API endpoint?

```bash
curl -v https://app-92fbc2c7-21cc-4f40-beb1-ff76864f76f9.cleverapps.io/api/test
```

**Attendu:**
```json
{
  "message": "✅ API Spendio fonctionne!",
  ...
}
```

### Test 3: Database OK?

```bash
curl -v https://app-92fbc2c7-21cc-4f40-beb1-ff76864f76f9.cleverapps.io/api/health/db
```

**Attendu:**
```json
{
  "status": "✅ Connexion OK",
  "database": "bmqq6ec1jz4mi9w5zt27"
}
```

**Si erreur 500:**
```json
{
  "status": "❌ Erreur connexion",
  "error": "..."
}
```

### Test 4: Login?

```bash
curl -X POST https://app-92fbc2c7-21cc-4f40-beb1-ff76864f76f9.cleverapps.io/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"123456"}'
```

**Attendu:**
```json
{
  "message": "Connexion réussie",
  "token": "eyJ...",
  "user": {
    "id": 1,
    "name": "Test User",
    "role": "user"
  }
}
```

---

## 🔧 Possibles Causes d'Erreur 500 Partout

### 1. Serveur n'a pas démarré

**Symptôme:** Les logs ne montrent pas "Serveur lancé"

**Solutions:**
- Attendre 5 min supplémentaires
- Vérifier que `npm run build && npm start` s'exécute (via Procfile)
- Vérifier que TypeScript compile sans erreur

### 2. Bug lors du démarrage

**Symptôme:** Les logs montrent une erreur dans `app.ts`

**Possibilités:**
- Import manquant
- Syntaxe invalide
- Middleware mal configuré

**Solution:** Partage le log exact d'erreur

### 3. BD inaccessible

**Symptôme:** 
```
Error: connect ECONNREFUSED 127.0.0.1:3306
```
ou
```
Error: Access denied for user 'ub5hqz7gukpvnbr9'...
```

**Solutions:**
- Vérifier les variables d'env Clever Cloud
- Vérifier que le MySQL add-on est actif
- Vérifier les credentials

### 4. Pool de connexions toujours saturé

**Symptôme:**
```
Error: User has exceeded 'max_user_connections'
```

**Solution:** Déjà fixé (connectionLimit: 2)

### 5. Espace disque plein

**Symptôme:**
```
Error: No space left on device
```

**Solution:** Contacter support Clever Cloud

### 6. Port déjà utilisé

**Symptôme:**
```
Error: listen EADDRINUSE :::5000
```

**Solution:** Changer le port ou redémarrer

---

## 📝 Modèle de Rapport d'Erreur

Quand tu veras l'erreur, fournis:

1. **Premier log d'erreur:**
   ```
   [COPIE-COLLE LA LIGNE D'ERREUR]
   ```

2. **Stack trace complète:**
   ```
   Error: ...
       at ...
       at ...
   ```

3. **État du serveur:**
   - Démarre: OUI / NON
   - BD connectée: OUI / NON
   - Tables initialisées: OUI / NON

4. **Résultat du test `/api/test`:**
   - Status: ?
   - Body: ?

---

## ✅ Prochaines Étapes

1. **ATTENDS 5 MINUTES** que Clever Cloud redéploie
2. **Regarde les logs Clever Cloud**
3. **Teste `/api/test`** avec curl
4. **Partage l'erreur exacte** qu'il affiche

---

## 💡 Astuce de Debugging Rapide

Si tu peux accéder à la console Clever Cloud:

```bash
# Voir les logs en temps réel
clever logs --follow

# Redémarrer l'app
clever restart

# Vérifier le statut
clever status
```

---

**Tu vois une erreur? Copie-la et partage-la, je vais la fixer immédiatement!** 🚀
