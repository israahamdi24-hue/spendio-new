# 📱 Guide de Connectivité Réseau pour SPENDIOO

**Status:** ✅ Serveur backend démarré avec succès  
**URL Backend:** `http://192.168.1.20:5000/api`  
**Date:** 27 Janvier 2026

---

## 🔧 Configuration Requise

### 1. **Vérifier l'adresse IP du serveur**
```bash
# Depuis le terminal du backend, on voit:
📱 Accessible à: http://192.168.1.20:5000
```

**Si l'adresse est différente**, elle s'affiche au démarrage du serveur.

### 2. **Vérifier que le téléphone est sur le même WiFi**
```bash
# Sur votre téléphone
Settings → WiFi → (connecté à votre réseau WiFi)
```

### 3. **Vérifier la connectivité**
```bash
# Depuis le téléphone, ouvrir un navigateur et tester:
http://192.168.1.20:5000/
# Vous devriez voir: "Bienvenue sur l'API Spendio"
```

---

## 📋 Checklist de Configuration

- [ ] Serveur backend lancé (`npm run dev` ou `npx ts-node-dev ...`)
- [ ] IP affichée au démarrage: `192.168.1.20` (ou votre IP locale)
- [ ] Téléphone connecté au même WiFi que le PC
- [ ] API URL dans `spendioo-new/src/services/api.ts`:
  ```typescript
  const API_BASE_URL = "http://192.168.1.20:5000/api";
  ```
- [ ] Firewall Windows: Autoriser le port 5000
  - [ ] Ou désactiver temporairement
  - [ ] Ou créer une règle pour ts-node-dev

---

## 🚨 Problèmes Courants

### ❌ "Cannot connect to 192.168.1.20:5000"
**Cause:** IP incorrecte ou téléphone pas sur le même WiFi

**Solution:**
```bash
# Vérifier l'IP affichée au démarrage du serveur
# Tester depuis navigateur du téléphone:
http://<IP_DU_SERVEUR>:5000/
```

### ❌ "Connection refused"
**Cause:** Serveur pas lancé

**Solution:**
```bash
# Terminal backend
cd backend
npx ts-node-dev --respawn --transpile-only src/app.ts
```

### ❌ "Firewall blocked"
**Cause:** Windows Defender bloque le port 5000

**Solution:**
```powershell
# Option 1: Créer une règle (comme admin)
New-NetFirewallRule -DisplayName "Node.js Dev" `
  -Direction Inbound -LocalPort 5000 -Protocol TCP -Action Allow

# Option 2: Désactiver le firewall temporairement
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled $False
```

### ❌ "192.168.1.20 not found"
**Cause:** IP locale changée

**Solution:**
```bash
# Relancer le serveur et copier la nouvelle IP
# Puis mettre à jour API_BASE_URL dans le frontend
```

---

## ✅ Procédure de Démarrage Complète

### **Étape 1: Terminal 1 - Backend**
```bash
cd c:\Users\israa\spendionvfrontetback\backend
npx ts-node-dev --respawn --transpile-only src/app.ts

# Vous devriez voir:
# 🚀 Serveur lancé sur http://0.0.0.0:5000
# 📱 Accessible à: http://192.168.1.20:5000
# ✅ Connexion MySQL réussie
```

### **Étape 2: Terminal 2 - Frontend**
```bash
cd c:\Users\israa\spendionvfrontetback\spendioo-new
npm run dev

# Attend la compilation, puis affiche:
# › Metro waiting on exp://192.168.x.x:19000
```

### **Étape 3: Téléphone**
```
1. Installer Expo Go (gratuit sur Play Store / App Store)
2. Ouvrir Expo Go
3. Scanner le QR code du terminal 2
4. Attendre le chargement (1-2 minutes)
5. Tester: Login → Add transaction → View activity
```

---

## 🔐 Vérification de la Sécurité

### Routes Protégées (Nécessitent JWT)
```
✅ GET    /api/budgets
✅ POST   /api/budgets
✅ GET    /api/budgets/history
✅ GET    /api/budgets/:month

✅ GET    /api/categories
✅ POST   /api/categories
✅ DELETE /api/categories/:id

✅ GET    /api/transactions
✅ POST   /api/transactions
✅ PUT    /api/transactions/:id
✅ DELETE /api/transactions/:id

✅ GET    /api/profile
✅ PUT    /api/profile
✅ PUT    /api/profile/password
```

### Routes Publiques
```
❌ POST   /api/auth/register
❌ POST   /api/auth/login
✅ GET    / (test de connectivité)
```

---

## 📡 Test de Connectivité avec cURL

```bash
# 1. Test simple (no auth)
curl http://192.168.1.20:5000/

# 2. Test avec token (exemple)
curl -H "Authorization: Bearer <YOUR_TOKEN>" \
     http://192.168.1.20:5000/api/budgets

# 3. Depuis PowerShell
$headers = @{"Authorization"="Bearer <YOUR_TOKEN>"}
Invoke-WebRequest -Uri "http://192.168.1.20:5000/api/budgets" `
                  -Headers $headers -Method Get
```

---

## 🆘 Si Ça Ne Fonctionne Pas

1. **Vérifier que le backend s'est bien démarré**
   ```bash
   # Voir dans le terminal:
   # ✅ Connexion MySQL réussie
   # 🚀 Serveur lancé sur http://0.0.0.0:5000
   ```

2. **Vérifier l'IP locale**
   ```bash
   # Windows
   ipconfig /all
   # Chercher "IPv4 Address" 192.168.x.x
   
   # Linux/Mac
   ifconfig
   ```

3. **Ping depuis le téléphone**
   ```bash
   # App terminal sur téléphone
   ping 192.168.1.20
   ```

4. **Consulter les logs du backend**
   ```
   Ils s'affichent directement dans le terminal
   Chercher "❌ Erreur" ou "error"
   ```

---

## 🎯 État Final

Quand tout est configuré correctement, vous devriez voir:

```
✅ Backend démarré: http://192.168.1.20:5000
✅ Frontend en dev: exp://192.168.x.x:19000
✅ Téléphone connecté à Expo Go
✅ Login réussi
✅ Transactions s'ajoutent et s'affichent
✅ Budgets & catégories s'affichent
```

---

**Besoin d'aide?** Consulte le fichier terminal pour les erreurs.
