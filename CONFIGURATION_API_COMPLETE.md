# 🔗 Configuration Backend-Frontend - Guide de Dépannage

## 📊 Configuration actuelle

**Backend:** `http://192.168.1.20:5000/api`  
**Frontend:** Expo App  
**Fichier config:** `src/config/api.config.ts`

---

## ✅ Étape 1 - Vérifier que le backend tourne

### Lancer le backend

```bash
cd c:\Users\israa\spendionvfrontetback\backend
npm run dev
```

**Résultat attendu:**
```
✅ Connexion MySQL réussie
🚀 Serveur lancé sur http://0.0.0.0:5000
📱 Accessible à: http://192.168.1.20:5000
```

### ❌ Si tu vois une autre IP (localhost ou 127.0.0.1)

Cela signifie que ton backend n'écoute pas sur l'adresse réseau. Modifie `backend/src/app.ts`:

```typescript
app.listen(PORT, "0.0.0.0", () => {  // ← Doit être "0.0.0.0"
  console.log(`🚀 Serveur lancé sur http://0.0.0.0:${PORT}`);
  console.log(`📱 Accessible à: http://${localIP}:${PORT}`);
});
```

---

## ✅ Étape 2 - Tester l'API manuellement

### Sur ton PC (dans le navigateur)

Accède à : **http://192.168.1.20:5000/api/auth/login**

#### Si ça fonctionne ✅
Tu verras une erreur JSON (c'est normal, pas de données):
```json
{
  "message": "Erreur lors du login",
  "error": "..."
}
```

#### Si ça dit "site inaccessible" ❌
→ Ton serveur n'est pas accessible sur le réseau réseau  
→ Va à **Étape 4** (ouvrir pare-feu)

---

## ✅ Étape 3 - Vérifier le réseau

### Sur Windows - Trouve ton IP locale

```powershell
ipconfig
```

**Cherche cette ligne:**
```
Adresse IPv4: 192.168.1.20
Masque de sous-réseau: 255.255.255.0
```

### Sur ton téléphone ou émulateur

Il doit avoir une IP du type **192.168.1.XXX**

#### Vérifier l'IP de l'émulateur Android

```bash
adb shell ip addr show
```

Cherche une ligne du type:
```
inet 192.168.1.xxx/24
```

---

## ✅ Étape 4 - Ouvrir le port 5000 au pare-feu Windows

### Méthode 1: Interface graphique (facile)

1. Ouvre **Panneau de configuration** → **Pare-feu Windows Defender**
2. Clique sur **Paramètres avancés** (à gauche)
3. Clique sur **Règles de trafic entrant** (à gauche)
4. Clique sur **Nouvelle règle** (à droite)

#### Configurer la règle

1. **Type de règle:** Sélectionne **Port**
2. **Protocole et port:**
   - Protocole: **TCP**
   - Port spécifique: **5000**
3. **Action:** **Autoriser la connexion**
4. **Profil:** Coche **Domaine**, **Privé**, **Public**
5. **Nom:** Entre `Express API 5000`
6. Clique **Terminer**

### Méthode 2: PowerShell (rapide)

```powershell
# Ouvrir PowerShell en tant qu'Admin

# Ajouter la règle de pare-feu
New-NetFirewallRule -DisplayName "Express API 5000" `
  -Direction Inbound `
  -Action Allow `
  -Protocol TCP `
  -LocalPort 5000

# Vérifier que la règle est créée
Get-NetFirewallRule -DisplayName "Express API 5000"
```

---

## ✅ Étape 5 - Vérifier la configuration Frontend

### Fichier: `src/config/api.config.ts`

```typescript
export const API_CONFIG = {
  BASE_URL: 'http://192.168.1.20:5000/api',  // ✅ Correcte
};
```

### Fichier: `src/services/api.ts`

```typescript
const BASE_URL = "http://192.168.1.20:5000/api";  // ✅ Correcte
```

---

## ⚠️ Cas spéciaux

### 🤖 Si tu utilises un ÉMULATEUR ANDROID

L'adresse `192.168.1.20` ne marche parfois pas depuis l'émulateur.

**Solution:** Utilise l'adresse spéciale `10.0.2.2`

Modifie `src/config/api.config.ts`:

```typescript
export const API_CONFIG = {
  // Pour émulateur Android
  BASE_URL: 'http://10.0.2.2:5000/api',
};
```

### 📱 Si tu utilises un VRAI TÉLÉPHONE

Assure-toi que le téléphone et le PC sont sur le **même réseau Wi-Fi**.

**Vérification:**
```bash
# Sur ton PC
ipconfig

# Sur ton téléphone (Paramètres → Wi-Fi)
# L'adresse IP doit commencer par 192.168.1
```

---

## 🧪 Test de connexion API

### Via Expo / Console

```bash
cd c:\Users\israa\spendionvfrontetback\spendioo-new

# Redémarrer avec cache nettoyé
npx expo start -c
```

### Vérifier les logs Expo

Dans le terminal Expo, tu dois voir:

```
🔗 API Service initialisé avec: http://192.168.1.20:5000/api
```

### Si tu vois des erreurs de connexion

```
❌ Network Error
❌ ECONNREFUSED
❌ Cannot fetch
```

→ Va à **Étape 2** et teste manuellement dans le navigateur

---

## 🔍 Checklist de dépannage

- [ ] Backend lancé avec `npm run dev`
- [ ] Backend affiche: `📱 Accessible à: http://192.168.1.20:5000`
- [ ] Navigateur accède à: `http://192.168.1.20:5000/api/auth/login`
- [ ] PC et téléphone/émulateur sur le même réseau
- [ ] Port 5000 ouvert au pare-feu Windows
- [ ] `api.config.ts` a la bonne IP: `192.168.1.20:5000/api`
- [ ] Expo redémarré avec `-c` (cache nettoyé)
- [ ] Console Expo affiche: `🔗 API Service initialisé avec: http://192.168.1.20:5000/api`

---

## 💡 Tips supplémentaires

### Voir les requêtes API en détail

Le backend affiche les requêtes:

```
📨 POST /api/auth/login from 192.168.x.x
📨 GET /api/categories from 192.168.x.x
```

Si tu ne vois rien dans le backend → la requête n'arrive pas du frontend

### Vider le cache Expo complètement

```bash
npx expo start --clear
```

### Tester l'API avec cURL (Windows PowerShell)

```powershell
# Test de ping
Invoke-WebRequest -Uri "http://192.168.1.20:5000/api/auth/login" -Method POST

# Avec JSON
$body = @{
    email = "test@example.com"
    password = "test123"
} | ConvertTo-Json

Invoke-WebRequest -Uri "http://192.168.1.20:5000/api/auth/login" `
  -Method POST `
  -Headers @{"Content-Type"="application/json"} `
  -Body $body
```

---

## 📞 Besoin d'aide?

1. Partage le résultat de la commande `ipconfig`
2. Partage l'IP affichée au démarrage du backend
3. Teste l'API manuellement et partage l'erreur
4. Partage les logs du terminal Expo
