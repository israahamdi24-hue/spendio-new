# 🔧 Guide de Dépannage Backend

## 🎯 Problème Actuel

L'app Expo reçoit une **erreur 500** du backend sur `/auth/login`.

**Logs Expo:**
```
ERROR  API Error [POST /auth/login]: {"response": {"data": {"message": "Erreur serveur"}, "status": 500}}
```

**Cause probable:** La base de données n'est pas accessible depuis Clever Cloud.

---

## 🚀 Étapes pour Déboguer

### ✅ Étape 1: Vérifier que le Backend est Lancé (Local)

```bash
cd backend
npm run dev
```

Tu devrais voir:
```
🔍 [STARTUP] Configuration de la base de données:
  - Host: localhost
  - User: root
  - Database: spendio
  - Port: 3306
  - Mode: development

✅ [DB] Connexion MySQL réussie!
🚀 Serveur lancé sur http://0.0.0.0:5000
```

### ✅ Étape 2: Tester le Backend Localement

```bash
# Dans un autre terminal
node backend/test-backend.js
```

**Résultat attendu:**
```
✅ Test 1: Ping
   Status: 200
   Response: pong

✅ Test 2: Health Check (Diagnostic)
   Status: 200
   DB Connected: true
   Users Table: EXISTS

✅ Test 3: Login (test@example.com)
   Status: 200
   ✅ Login réussi!
   Token: eyJhbGciOiJIUzI1NiIs...
```

### ✅ Étape 3: Tester l'Endpoint Health Check

**Via curl:**
```bash
curl http://192.168.1.36:5000/api/auth/health
```

**Réponse attendue:**
```json
{
  "status": "ok",
  "database": {
    "connected": true,
    "host": "localhost",
    "database": "spendio",
    "usersTableExists": true
  },
  "timestamp": "2026-01-30T..."
}
```

---

## 🔴 Si Ça Échoue

### Problème 1: Erreur BD au démarrage

**Log:**
```
❌ [DB] Erreur de connexion MySQL:
  Message: connect ECONNREFUSED 127.0.0.1:3306
```

**Solutions:**
1. Vérifier que MySQL est lancé:
   ```bash
   # Windows
   mysql --version
   
   # Ou start le service MySQL
   ```
2. Vérifier les credentials dans `.env`:
   ```
   DB_HOST=localhost
   DB_USER=root
   DB_PASSWORD=
   DB_NAME=spendio
   ```

### Problème 2: Table users manquante

**Log Health Check:**
```json
"usersTableExists": false
```

**Solution:**
```bash
cd backend
npm run init-db
```

### Problème 3: Login échoue avec erreur BD

**Log:**
```
🔓 [LOGIN] Tentative avec email: test@example.com
❌ [LOGIN] ERREUR: Error: ER_NO_REFERENCED_TABLE
```

**Solution:** Vérifier que la table `users` est créée avec les colonnes correctes:
```bash
mysql -u root spendio -e "DESCRIBE users;"
```

---

## 🌐 Pour Clever Cloud

### Étape 1: Vérifier la BD Clever Cloud

Va sur **Clever Cloud Console** → **Logs** de ton app backend.

Fais une requête test:
```bash
curl https://app-92fbc2c7-21cc-4f40-beb1-ff76864f76f9.cleverapps.io/api/auth/health
```

### Étape 2: Lire les Logs

Cherche ces patterns dans Clever Cloud → Logs:

#### ✅ Si tout fonctionne:
```
🔍 [STARTUP] Configuration de la base de données:
  - Host: [host clever cloud]
  - User: [user clever cloud]
✅ [DB] Connexion MySQL réussie!
```

#### 🔴 Si BD inaccessible:
```
❌ [DB] Erreur de connexion MySQL:
  Message: connect ECONNREFUSED
  Code: PROTOCOL_CONNECTION_LOST
```

#### 🔴 Si table manquante:
```
[HEALTH] Users Table: MISSING
```

### Étape 3: Redéployer si Besoin

```bash
cd backend
git add .
git commit -m "improvement: Add health check endpoint and detailed logging"
git push
```

---

## 📋 Checklist de Dépannage

- [ ] Backend lancé localement (`npm run dev`)
- [ ] MySQL lancé et accessible
- [ ] Table `users` existe (`npm run init-db`)
- [ ] Test local réussit (`node test-backend.js`)
- [ ] Health check retourne OK (`curl /api/auth/health`)
- [ ] Login fonctionne localement
- [ ] Backend redéployé sur Clever Cloud (`git push`)
- [ ] Variables d'environnement Clever Cloud configurées
- [ ] Logs Clever Cloud montrent connexion BD OK

---

## 🔗 Endpoints de Test

| Endpoint | Méthode | Teste |
|----------|---------|-------|
| `/api/auth/ping` | GET | Serveur actif |
| `/api/auth/health` | GET | Connexion BD + tables |
| `/api/auth/login` | POST | Authentification complète |
| `/api/auth/register` | POST | Inscription + BD insert |

---

## 💡 Aide Rapide

**Si tu vois dans les logs:**
- `🔓 [LOGIN] Tentative...` → Requête reçue ✅
- `🔍 [LOGIN] Recherche...` → BD accessible ✅
- `👤 [LOGIN] Utilisateur trouvé...` → User existe ✅
- `❌ [LOGIN] ERREUR: ...` → Copie le message complet

---

**Prochaine étape:** Lance le backend et partage-moi les logs! 🚀
