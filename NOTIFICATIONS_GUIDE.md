# 🔔 Guide Complet - Notifications Locales

## ✅ Ce qui a été Amélioré

### 1️⃣ Hook useLocalNotifications (pushToken.tsx)
- ✅ Meilleure gestion des erreurs
- ✅ Logging détaillé pour chaque notification
- ✅ Support priorité HIGH pour Android
- ✅ Ajout de `sendDelayedNotification()`
- ✅ Retour de l'ID de la notification

### 2️⃣ Configuration Globale (app/index.tsx)
- ✅ Canal Android optimisé avec son et vibration
- ✅ Listeners robustes pour notifications reçues
- ✅ Listeners pour quand l'utilisateur clique
- ✅ Nettoyage propre des listeners
- ✅ Logging détaillé de chaque étape

### 3️⃣ Utilisation dans Add Transaction (add.tsx)
- ✅ Try-catch pour éviter blocage si notification échoue
- ✅ Logging détaillé avec l'ID de notification
- ✅ Gestion non-bloquante: la transaction se sauvegarde même si notification échoue

---

## 🚀 Comment Tester

### Option 1: Avec Expo Go (Le plus simple)

#### Étape 1: Redémarrer Expo
```bash
cd spendioo-new
npx expo start -c
```

#### Étape 2: Scanner le QR code
- Sur Android: Ouvre Expo Go → Scanner QR
- Sur iOS: Ouvre l'appareil photo → Scanner QR

#### Étape 3: Tester une notification
1. Connecte-toi avec un compte
2. Va dans l'onglet "Ajouter"
3. Remplis un formulaire:
   - Montant: 50
   - Catégorie: Nourriture
   - Type: Dépense
   - Date: Aujourd'hui
4. Clique "Ajouter"

#### Étape 4: Vérifier la notification
- ✅ Une notification rose doit apparaître
- ✅ Elle doit dire: "💸 Dépense ajoutée(e)"
- ✅ Corps: "50 DT dans Nourriture"

### Option 2: Avec cURL (Pour tester le backend seul)

```bash
# Envoyer une notification de test
curl -X POST http://192.168.1.36:5000/api/notifications/test \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Test Notification",
    "body": "Ceci est une notification de test"
  }'
```

---

## 🔍 Vérifier les Logs

### Dans le Terminal Expo (où tu as lancé `npx expo start`)

#### 🟢 Si tout fonctionne:
```
🔧 [NOTIFICATIONS] Configuration du canal Android...
✅ [NOTIFICATIONS] Canal Android configuré
📢 [NOTIFICATION] Envoi: "💸 Dépense ajoutée(e)" - "50 DT dans Nourriture"
✅ [NOTIFICATION] Programmée avec ID: 12345
📬 [NOTIFICATIONS] Reçue: {
  title: "💸 Dépense ajoutée(e)",
  body: "50 DT dans Nourriture",
  timestamp: "2026-01-30T..."
}
```

#### 🔴 Si ça ne marche pas:
```
❌ [NOTIFICATION] Erreur: ...
   Message: ...
   Code: ...
```
**→ Copie ce message et je peux aider!**

---

## 📋 Checklist

- [ ] Redémarrer Expo avec `-c` pour clear cache
- [ ] Scanner le QR code dans Expo Go
- [ ] Se connecter avec un compte
- [ ] Ajouter une transaction
- [ ] Vérifier qu'une notification apparaît
- [ ] Vérifier les logs dans le terminal Expo
- [ ] La transaction est bien sauvegardée?

---

## 🛠️ Dépannage Rapide

| Problème | Solution |
|----------|----------|
| Aucune notification | `npx expo start -c` + scanner QR |
| Notification bloquée sur Android | Vérifier permissions (Paramètres > Applis > Expo Go > Notifications) |
| Erreur dans logs | Copie le message d'erreur complet |
| App crash | Vérifier la console pour erreur TypeScript |
| Notification mais sans son | Vérifier volume du téléphone |

---

## 📞 Si Ça Ne Marche Pas

**Partage-moi ces infos:**
1. Le log exact du terminal Expo
2. Qu'est-ce qui se passe exactement?
3. Quel téléphone/emulateur tu utilises?
4. Quel est le système d'exploitation (Android/iOS)?

---

## 💡 Infos Techniques

### Notification Immédiate
```typescript
const { sendImmediateNotification } = useLocalNotifications();
await sendImmediateNotification("Titre", "Message");
```

### Notification Programmée
```typescript
const { sendDelayedNotification } = useLocalNotifications();
// Afficher après 5 secondes
await sendDelayedNotification("Titre", "Message", 5);
```

### Properties de Notification
- **title**: Titre (string)
- **body**: Message principal (string)
- **sound**: true (son activé)
- **badge**: 1 (affiche badge notification)
- **priority**: HIGH (important sur Android)
- **vibrationPattern**: [0, 250, 250, 250] (vibration)

---

## 🎉 Prochaine Étape

**Maintenant teste les notifications:**

1. `npx expo start -c`
2. Scanner QR
3. Ajouter une transaction
4. Vérifier la notification

**Dis-moi ce qui se passe!** ✨
