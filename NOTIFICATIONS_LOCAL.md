# 📱 Notifications Locales - Guide d'utilisation

## 🔧 Changement Expo SDK 53

Depuis **Expo SDK 53**, les notifications push distantes ne sont **plus supportées dans Expo Go**.

### ✅ Ce qui fonctionne maintenant

- **Notifications locales** ✅
- Tout le frontend (auth, API, budget, statistiques, etc.) ✅
- Hot reload dans Expo Go ✅

### ❌ Ce qui ne fonctionne plus dans Expo Go

- Notifications push distantes (depuis un serveur) ❌
- Messages push reçus lors de l'app fermée ❌

---

## 🎯 Comment utiliser les notifications locales

### 1️⃣ **Importer le hook**

```tsx
import { useLocalNotifications } from '@/src/hooks/pushToken';
```

### 2️⃣ **Utiliser dans un composant**

```tsx
export default function AddExpenseScreen() {
  const { sendLocalNotification, sendImmediateNotification, isLoading } = useLocalNotifications();

  const handleAddExpense = async () => {
    // ... logique d'ajout de dépense ...
    
    // Notifier l'utilisateur immédiatement
    await sendImmediateNotification(
      '💸 Dépense ajoutée',
      'Vous venez d\'ajouter une nouvelle transaction.'
    );
  };

  return (
    <Button 
      onPress={handleAddExpense}
      disabled={isLoading}
      title="Ajouter"
    />
  );
}
```

### 3️⃣ **Avec délai programmé**

```tsx
// Notification dans 5 secondes
await sendLocalNotification(
  '📅 Rappel budgétaire',
  'N\'oublie pas de tracker tes dépenses!',
  5 // délai en secondes
);
```

---

## 📚 Exemples pratiques

### Budget dépassé
```tsx
if (totalSpent > totalBudget) {
  await sendImmediateNotification(
    '⚠️ Budget dépassé!',
    `Tu as dépassé ton budget de ${(totalSpent - totalBudget).toFixed(2)} DT`
  );
}
```

### Transaction ajoutée
```tsx
await sendImmediateNotification(
  '✅ Transaction enregistrée',
  `${amount} DT dans ${categoryName}`
);
```

### Rappel quotidien
```tsx
// Programmer une notification pour demain à 9h
const tomorrow = new Date();
tomorrow.setDate(tomorrow.getDate() + 1);
tomorrow.setHours(9, 0, 0);

const delaySeconds = Math.floor((tomorrow.getTime() - Date.now()) / 1000);

await sendLocalNotification(
  '📊 Temps de tracker tes dépenses',
  'Ajoute tes dépenses d\'aujourd\'hui dans Spendioo',
  delaySeconds
);
```

---

## 🔙 Migration future

Si tu veux restaurer les **push notifications distantes** à l'avenir, tu auras deux options :

### Option 1 : Développement Build Expo (Recommandé)
```bash
# Crée une app Expo complète avec tous les modules natifs
npx expo prebuild
npx expo run:android
```

### Option 2 : Build EAS
```bash
# Crée un build dans le cloud Expo
npx eas build --platform android
```

Ces approches te permettront de sortir d'Expo Go et d'avoir accès aux notifications push distantes.

---

## 📋 API du hook `useLocalNotifications`

```typescript
const {
  sendLocalNotification,    // (title: string, body: string, delaySeconds?: number) => Promise<void>
  sendImmediateNotification, // (title: string, body: string) => Promise<void>
  isLoading                  // boolean - true pendant l'envoi
} = useLocalNotifications();
```

---

## 🚀 Avantages des notifications locales

✅ **Pas de serveur requis**  
✅ **Fonctionne hors ligne**  
✅ **Peut programmer des notifications**  
✅ **Contrôle total sur le timing**  
✅ **Pas de dépendance externe**  
✅ **Parfait pour les rappels en-app**

---

## 📞 Support

- **Documentation officielle** : https://docs.expo.dev/versions/latest/sdk/notifications/
- **Forum Expo** : https://forums.expo.dev/
- **Issues GitHub** : https://github.com/expo/expo/issues
