# 🚀 Guide Complet - Tester l'App Complète

## ✅ Ce qui a été Amélioré

1. **Logging du Token** - Middleware d'authentification affiche maintenant tous les détails
2. **Logging des Budgets** - Contrôleur affiche où ça échoue exactement
3. **Gestion d'Erreurs** - Messages plus détaillés pour déboguer

---

## 🧪 Étape 1: Vérifier l'API (Serveur Online)

Ouvre ce lien dans le navigateur:

```
https://app-92fbc2c7-21cc-4f40-beb1-ff76864f76f9.cleverapps.io/
```

**Tu devrais voir:** `Bienvenue sur l'API Spendio`

Si erreur, attends que Clever Cloud redéploie (2-5 min).

---

## 🧪 Étape 2: Tester le Login

### Via Postman/cURL:

```
POST https://app-92fbc2c7-21cc-4f40-beb1-ff76864f76f9.cleverapps.io/api/auth/login
Content-Type: application/json

{
  "email": "test@example.com",
  "password": "123456"
}
```

**Réponse attendue:**
```json
{
  "message": "Connexion réussie",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "name": "Test User",
    "email": "test@example.com",
    "role": "user"
  }
}
```

**Copie le token** - tu en auras besoin pour la prochaine étape!

---

## 🧪 Étape 3: Tester les Budgets (Sans Token)

```
GET https://app-92fbc2c7-21cc-4f40-beb1-ff76864f76f9.cleverapps.io/api/budgets
```

**Réponse attendue:**
```json
{
  "message": "Token manquant"
}
```

---

## 🧪 Étape 4: Tester les Budgets (Avec Token)

```
GET https://app-92fbc2c7-21cc-4f40-beb1-ff76864f76f9.cleverapps.io/api/budgets
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

(Remplace le token par celui du step 2)

**Réponse attendue:**
```json
[]
```

(Liste vide au départ, c'est normal)

---

## 📱 Étape 5: Tester dans Expo

### 1. Redémarre Expo avec cache clean:
```bash
cd spendioo-new
npx expo start -c
```

### 2. Scanne le QR avec Expo Go

### 3. Regarde les logs dans le terminal:
Cherche:
```
🔓 [LOGIN] Tentative de connexion: test@example.com
✅ [LOGIN] Connexion réussie pour: test@example.com
🎫 [LOGIN] Token reçu, sauvegarde...
✅ [LOGIN] Token et utilisateur sauvegardés
```

### 4. Se connecter avec:
- Email: `test@example.com`
- Password: `123456`

### 5. Après login, cherche dans les logs Expo:
```
📊 [BUDGETS] Requête GET /budgets
✅ [BUDGETS] 0 budget(s) trouvé(s)
```

---

## ❌ Dépannage

### "Token manquant"
- Le frontend n'envoie pas le token
- Vérifies que le token est bien sauvegardé dans AsyncStorage
- Vérifie que l'API service ajoute le header `Authorization: Bearer {token}`

### "Format de token invalide"
- Le token n'a pas le format "Bearer <token>"
- Vérifie que tu envoies `Authorization: Bearer eyJ...`

### "Token invalide"
- Le JWT_SECRET du backend ne correspond pas
- Ou le token a expiré
- Fais un nouveau login

### "Non autorisé" (401)
- Le middleware d'auth rejette la requête
- Cherche le log `🔐 [AUTH]` pour voir pourquoi

### "Erreur serveur" (500)
- Il y a une erreur dans le code
- Regarde le log `❌ [BUDGETS]` pour le message d'erreur exact
- Ou regarde les logs Clever Cloud

---

## 📋 Checklist

- [ ] `/` répond "Bienvenue sur l'API Spendio"
- [ ] `/api/auth/login` retourne un token valide
- [ ] `/api/budgets` sans token retourne "Token manquant"
- [ ] `/api/budgets` avec token retourne une liste (vide ou avec données)
- [ ] Expo peut se connecter sans erreur
- [ ] Les logs d'Expo montrent `✅ [LOGIN] ...`
- [ ] Les logs d'Expo montrent `✅ [BUDGETS] ...`
- [ ] Le dashboard affiche les budgets (même si vides)

---

## 🎯 Résumé

| Étape | Vérification | Status |
|-------|------------|--------|
| 1 | API répond | ? |
| 2 | Login fonctionne | ? |
| 3 | Token nécessaire | ? |
| 4 | Budgets accessibles | ? |
| 5 | App Expo fonctionne | ? |

---

**Prochaine étape:** Teste étape par étape et dis-moi où ça échoue exactement! 🔍
