# 🎯 ACTION - Diagnostiquer l'Erreur 500

## ⏰ Timeline

1. **Commit déployé:** `53a806b` 
2. **Attends:** 5-10 minutes pour Clever Cloud
3. **Ensuite:** Teste les endpoints

---

## 🔧 Commandes à Exécuter (dans cet ordre)

### Étape 1: Test Simple du Serveur

```bash
curl -v https://app-92fbc2c7-21cc-4f40-beb1-ff76864f76f9.cleverapps.io/
```

**Résultat Attendu:**
```
< HTTP/1.1 200 OK
Bienvenue sur l'API Spendio
```

**Si tu vois 500 ou erreur de connexion:**
- Le serveur n'a pas démarré
- Attends 2 minutes de plus
- Puis va à l'Étape 2

---

### Étape 2: Vérifier les Logs Clever Cloud

**Via le navigateur:**
1. https://console.clever-cloud.com
2. Clique sur ton application
3. Onglet "Logs" (pas "Activity")
4. Cherche le texte "Serveur lancé"

**Tu devrais voir:**
```
🚀 Serveur lancé sur http://0.0.0.0:5000
📱 Accessible à: http://...:5000

🔧 [DATABASE INIT] Vérification de la base de données...
✅ [DB] Connexion MySQL réussie!
✅ [DATABASE INIT] Base de données initialisée avec succès!
```

**Si tu vois une erreur:**
- Copie-la complètement
- Va à l'Étape 3

---

### Étape 3: Test Health Check DB

```bash
curl -v https://app-92fbc2c7-21cc-4f40-beb1-ff76864f76f9.cleverapps.io/api/health/db
```

**Si ça retourne 200:**
```json
{
  "status": "✅ Connexion OK",
  "database": "bmqq6ec1jz4mi9w5zt27"
}
```

→ Base de données marche!

**Si ça retourne 500:**
```json
{
  "status": "❌ Erreur connexion",
  "error": "..."
}
```

→ Problème de BD, partage le message d'erreur

---

### Étape 4: Test Login

```bash
curl -X POST https://app-92fbc2c7-21cc-4f40-beb1-ff76864f76f9.cleverapps.io/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"123456"}'
```

**Si succès (200):**
```json
{
  "message": "Connexion réussie",
  "token": "eyJ...",
  "user": {
    "id": 1,
    "name": "Test User"
  }
}
```

→ **C'EST BON! Tout marche!**

**Si erreur 500:**
```json
{
  "message": "❌ Erreur interne du serveur",
  "error": "...",
  "debug": {...}
}
```

→ Partage le message d'erreur et le debug

---

## 📋 Résumé à Me Donner

Copie-colle ça et remplis:

```
🔍 DIAGNOSTIC BACKEND

1. Étape 1 - Serveur répond?
   Résultat curl /: [SUCCESS / ERROR / TIMEOUT]
   Si erreur, code: ___
   
2. Étape 2 - Logs Clever Cloud
   "Serveur lancé" visible: [OUI / NON]
   "Connexion MySQL" visible: [OUI / NON]
   Erreur visible: [COLLER L'ERREUR SI OUI]
   
3. Étape 3 - Health DB
   Résultat: [SUCCESS / ERROR]
   Message d'erreur: [SI APPLICABLE]
   
4. Étape 4 - Login
   Résultat: [SUCCESS / ERROR]
   Statut HTTP: ___
   Message d'erreur: [SI APPLICABLE]
   
5. État Global
   Prêt pour Expo: [OUI / NON]
```

---

## 🚀 Si Tout Marche

Une fois que `/api/auth/login` retourne un token:

```bash
# Teste depuis Expo
cd spendioo-new
npx expo start -c

# Dans Expo Go:
# - Clique sur "Se connecter"
# - Email: test@example.com
# - Password: 123456
# - Regarde la console pour les logs
```

---

## ❌ Si Erreur Persiste

Partage:
1. Code d'erreur HTTP
2. Corps de la réponse JSON
3. Les logs Clever Cloud complets (copie tout)
4. Résultat du curl pour chaque étape

Et on va **fixer** le problème! 💪

---

**Vas-y! Exécute les étapes et partage le résultat!** 🔧
