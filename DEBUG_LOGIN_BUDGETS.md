# 🚀 Guide de Débogage - Login et Budgets

## 🔍 Étape 1: Vérifier que le Serveur Répond

Ouvre ce lien dans le navigateur:

```
https://app-92fbc2c7-21cc-4f40-beb1-ff76864f76f9.cleverapps.io/
```

**Tu devrais voir:** `Bienvenue sur l'API Spendio`

Si tu vois "Cannot GET", le serveur n'est pas prêt encore. **Attends 5 minutes** et réessaye.

---

## 🧪 Étape 2: Tester le Login Directement

Ouvre Postman ou utilise cURL:

```bash
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
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "user": {
    "id": 1,
    "name": "Test User",
    "role": "user"
  }
}
```

**Si erreur 500:** Le backend a un problème. Vérifiez les logs Clever Cloud.

---

## 📱 Étape 3: Tester dans Expo

1. **Lance Expo:**
```bash
cd spendioo-new
npx expo start -c
```

2. **Scanne le QR avec Expo Go**

3. **Va à l'écran de login**

4. **Rentre les identifiants:**
   - Email: `test@example.com`
   - Password: `123456`

5. **Regarde la console Expo** pour les logs:
   - `🔓 [LOGIN] Tentative de connexion: test@example.com`
   - `✅ [LOGIN] Connexion réussie pour: test@example.com`
   - `✅ [LOGIN] Token et utilisateur sauvegardés`

---

## ❌ Dépannage

### "Cannot GET /"
- Le serveur n'est pas en ligne
- Attends que Clever Cloud redéploie (2-5 min)
- Vérifies les logs Clever Cloud

### "Email ou mot de passe incorrect"
- Les identifiants ne sont pas bons
- Utilise: `test@example.com` / `123456`
- Ou enregistre un nouvel utilisateur

### "Erreur serveur" (500)
- Le backend a une erreur interne
- Regarde les logs Clever Cloud → Logs → Stderr
- Cherche le message d'erreur exact

### "Cannot connect to database"
- Les credentials MySQL ne sont pas bons
- Vérifie le `.env` du backend
- Ou Clever Cloud n'a pas déployé correctement

---

## 📋 Checklist

- [ ] `/` répond "Bienvenue sur l'API Spendio"
- [ ] `/api/auth/login` retourne un token valide
- [ ] Expo peut se connecter
- [ ] Token apparaît dans les logs d'Expo
- [ ] Token est sauvegardé (AsyncStorage)
- [ ] Dashboard charge les budgets

---

## 💡 Notes

**Si le login marche mais budgets échouent:**
- Le token est sauvegardé mais pas envoyé dans les headers
- Vérifie que le header `Authorization: Bearer {token}` est bien envoyé

**Si budgets retournent 500:**
- L'endpoint `/api/budgets` a une erreur
- Regarde les logs du backend

---

**Prochaine action:** Teste dans le navigateur et Postman d'abord, puis dans Expo!
