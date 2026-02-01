# ⚡ AIDE RAPIDE - Copie/Colle

## 🎯 Tu as 2 minutes? Fais ça:

### 1. Ouvrir Pare-feu (Copie/Colle PowerShell Admin)

```powershell
# Ouvre PowerShell en tant qu'Admin et exécute:
New-NetFirewallRule -DisplayName "Express API 5000" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5000
```

### 2. Lancer Backend (Terminal 1)

```powershell
cd c:\Users\israa\spendionvfrontetback\backend
npm run dev
```

**Attends:**
```
✅ Connexion MySQL réussie
📱 Accessible à: http://192.168.1.20:5000
```

### 3. Tester dans navigateur

```
http://192.168.1.20:5000/api/auth/login
```

**Résultat:** JSON (erreur ou données) = OK ✅

### 4. Lancer Expo (Terminal 2)

```powershell
cd c:\Users\israa\spendionvfrontetback\spendioo-new
npx expo start -c
```

### 5. Teste l'app!

Scanne le QR code avec Expo Go sur ton téléphone.

---

## 🧪 Si ça ne marche pas:

```powershell
# Exécute le diagnostic complet
.\test-api-connection.ps1
```

**Partage le résultat** + voir [INDEX_SOLUTIONS.md](INDEX_SOLUTIONS.md)

---

## 🔥 Pare-feu bloque toujours?

### Vérifier la règle

```powershell
Get-NetFirewallRule -DisplayName "Express API 5000"
```

**Résultat attendu:**
```
DisplayName             Enabled
Express API 5000        True
```

### Supprimer et recréer

```powershell
Remove-NetFirewallRule -DisplayName "Express API 5000"

New-NetFirewallRule -DisplayName "Express API 5000" `
  -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5000
```

---

## 💻 Vérifier l'IP

```powershell
ipconfig | findstr "IPv4"
```

**Doit afficher:**
```
Adresse IPv4: 192.168.1.20
```

---

## 📱 Pour Émulateur Android

Modifie `src/config/api.config.ts`:

```typescript
BASE_URL: 'http://10.0.2.2:5000/api',  // ← Pour émulateur!
```

Puis redémarrage Expo:
```powershell
npx expo start -c
```

---

## 🆘 Vraiment stuck?

1. **Lire:** [VISUAL_GUIDE.md](VISUAL_GUIDE.md) (guide visuel avec flux)
2. **Exécuter:** `.\test-api-connection.ps1` (diagnostic)
3. **Consulter:** [API_SETUP_STEPS.md](API_SETUP_STEPS.md) (détails)

---

**C'est tout! 🎉**
