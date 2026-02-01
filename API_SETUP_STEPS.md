# 🔗 RÉSOLUTION PROBLÈMES API - Configuration Complète

## 📌 Statut Actuel

✅ **Configuration API corrigée:**
- `src/config/api.config.ts` → `http://192.168.1.20:5000/api`
- `src/services/api.ts` → `http://192.168.1.20:5000/api`

⚠️ **À vérifier:**
- Port 5000 ouvert au pare-feu Windows
- Backend lancé et accessible
- PC et téléphone sur le même réseau Wi-Fi

---

## 🚀 ÉTAPES À SUIVRE (Dans l'ordre!)

### 1️⃣ Ouvrir le Pare-feu Port 5000

**Méthode rapide (PowerShell Admin):**

```powershell
# Exécute PowerShell en tant qu'Admin

New-NetFirewallRule -DisplayName "Express API 5000" `
  -Direction Inbound `
  -Action Allow `
  -Protocol TCP `
  -LocalPort 5000
```

**Méthode graphique:**
→ Voir `FIREWALL_SETUP.md` pour les détails

---

### 2️⃣ Vérifier l'IP Locale (Windows PowerShell)

```powershell
ipconfig
```

**Cherche:**
```
Adresse IPv4: 192.168.1.20      ← C'est ton IP
Masque de sous-réseau: 255.255.255.0
```

**Important:** Cette IP doit être la même que celle utilisée dans la config API!

---

### 3️⃣ Lancer le Backend

**Terminal 1 (PowerShell):**

```powershell
cd c:\Users\israa\spendionvfrontetback\backend
npm run dev
```

**Résultat attendu:**
```
✅ Connexion MySQL réussie
🚀 Serveur lancé sur http://0.0.0.0:5000
📱 Accessible à: http://192.168.1.20:5000
```

**❌ Si tu vois "localhost:5000":** Le backend n'écoute pas sur le réseau
→ Modifie `app.ts` ligne 58: `app.listen(PORT, "0.0.0.0", ...)`

---

### 4️⃣ Tester l'API depuis le navigateur PC

**Ouvre ton navigateur:**

```
http://192.168.1.20:5000/api/auth/login
```

**Résultat attendu:**
- ✅ Erreur JSON (c'est normal, pas de données POST)
- ❌ "Cette page n'est pas accessible" → Continue au dépannage

---

### 5️⃣ Lancer Expo

**Terminal 2 (PowerShell):**

```powershell
cd c:\Users\israa\spendionvfrontetback\spendioo-new
npx expo start -c
```

**Vérifier dans les logs:**
```
🔗 API Service initialisé avec: http://192.168.1.20:5000/api
```

---

### 6️⃣ Tester l'app

**Option A: Sur téléphone**
- Installe Expo Go
- Scanne le QR code
- Accepte la permission réseau

**Option B: Sur émulateur Android**
- Si l'IP ne marche pas, modifie `api.config.ts`:
  ```typescript
  BASE_URL: 'http://10.0.2.2:5000/api',  // Pour émulateur Android
  ```
- Redémarrage Expo avec `-c`

---

## 🧪 Script de Diagnostic Automatique

```powershell
# Télécharge et exécute le diagnostic:
.\test-api-connection.ps1
```

**Il va vérifier automatiquement:**
- ✅ Backend accessible
- ✅ Endpoint API responsive
- ✅ IP locale correcte
- ✅ Pare-feu configuré
- ✅ Configuration API

---

## 📋 Checklist complète

- [ ] PowerShell ouvert en **Admin**
- [ ] Règle pare-feu créée: `Express API 5000`
- [ ] IP locale: `192.168.1.20` (vérifié avec `ipconfig`)
- [ ] Backend lancé: `npm run dev`
- [ ] Backend affiche: `📱 Accessible à: http://192.168.1.20:5000`
- [ ] Navigateur accède: `http://192.168.1.20:5000/api/auth/login` ✅
- [ ] Config API correcte: `http://192.168.1.20:5000/api`
- [ ] Expo lancé avec `-c`
- [ ] Expo affiche: `🔗 API Service initialisé avec: http://192.168.1.20:5000/api`
- [ ] App testée sur téléphone/émulateur

---

## ❌ Dépannage Rapide

| Erreur | Cause | Solution |
|--------|-------|----------|
| "ECONNREFUSED" | Backend pas lancé | `npm run dev` |
| "Network unreachable" | Pare-feu bloque | Ouvrir port 5000 |
| "Cannot fetch" | Mauvaise IP | Vérifier `ipconfig` |
| "Timeout" | Même réseau? | Vérifier Wi-Fi |
| Affiche "localhost:5000" | Backend mauvaise config | Modifie `app.ts` ligne 58 |

---

## 📖 Ressources

- 🔥 **Pare-feu détaillé:** [FIREWALL_SETUP.md](FIREWALL_SETUP.md)
- 🔗 **Config complète:** [CONFIGURATION_API_COMPLETE.md](CONFIGURATION_API_COMPLETE.md)
- 🧪 **Diagnostic auto:** `test-api-connection.ps1`
- 📱 **Notifications:** [NOTIFICATIONS_LOCAL.md](NOTIFICATIONS_LOCAL.md)

---

## 💬 Besoin d'aide?

1. Partage le résultat de `ipconfig`
2. Partage le message exact d'erreur
3. Partage ce que le backend affiche au démarrage
4. Exécute `.\test-api-connection.ps1` et partage le résultat

