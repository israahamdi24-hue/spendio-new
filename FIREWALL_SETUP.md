# 🔥 Configuration Pare-feu Windows - Port 5000

## ⚡ Solution rapide (PowerShell Admin)

Ouvre **PowerShell en tant qu'Administrateur** et exécute:

```powershell
# Ajouter la règle pare-feu
New-NetFirewallRule -DisplayName "Express API 5000" `
  -Direction Inbound `
  -Action Allow `
  -Protocol TCP `
  -LocalPort 5000

# Vérifier que la règle est créée
Get-NetFirewallRule -DisplayName "Express API 5000" | Format-Table DisplayName, Enabled
```

**Résultat attendu:**
```
DisplayName             Enabled
-----------             -------
Express API 5000          True
```

---

## 🖱️ Solution graphique (GUI) - Étapes détaillées

### Étape 1 - Ouvrir le Pare-feu Windows

1. Appuie sur **Windows + R**
2. Tape: `wf.msc`
3. Appuie sur **Entrée**

→ Le **Pare-feu Windows Defender avec sécurité avancée** s'ouvre

### Étape 2 - Créer une nouvelle règle

1. Dans le panneau de gauche, clique sur **Règles de trafic entrant**
2. Dans le panneau de droite, clique sur **Nouvelle règle...**

### Étape 3 - Configuration (Assistant)

#### Écran 1: Type de règle
- ☑️ Sélectionne **Port**
- Clique **Suivant**

#### Écran 2: Protocole et port
- Protocole: **TCP**
- Ports spécifiques: **5000**
- Clique **Suivant**

#### Écran 3: Action
- ☑️ **Autoriser la connexion**
- Clique **Suivant**

#### Écran 4: Profil
- ☑️ **Domaine**
- ☑️ **Privé** (important!)
- ☑️ **Public**
- Clique **Suivant**

#### Écran 5: Nom et Description
- **Nom:** `Express API 5000`
- **Description:** `Permet les connexions au serveur Express sur le port 5000`
- Clique **Terminer**

### Étape 4 - Vérification

La règle doit maintenant apparaître dans la liste **Règles de trafic entrant**:

```
Nom                      État      Direction
Express API 5000         ✅ Activé  Entrant
```

---

## 🧪 Tester que le port est ouvert

### Méthode 1: PowerShell

```powershell
Test-NetConnection -ComputerName 192.168.1.20 -Port 5000 -InformationLevel Detailed
```

**Résultat attendu:**
```
TcpTestSucceeded : True
```

### Méthode 2: Navigateur

1. Lance le backend: `npm run dev` (dans le dossier backend)
2. Ouvre ton navigateur
3. Va à: `http://192.168.1.20:5000/`

**Résultat attendu:**
```
Bienvenue sur l'API Spendio
```

---

## ❌ Dépannage

### "L'accès est refusé" (ErrorAction)

**Cause:** Tu n'as pas ouvert PowerShell en **Admin**

**Solution:**
1. Appuie sur **Windows**
2. Cherche **PowerShell**
3. Clique droit → **Exécuter en tant qu'administrateur**
4. Réessaie la commande

### La règle existe déjà mais ne fonctionne pas

```powershell
# Supprimer la règle existante
Remove-NetFirewallRule -DisplayName "Express API 5000"

# Relancer la création
New-NetFirewallRule -DisplayName "Express API 5000" `
  -Direction Inbound `
  -Action Allow `
  -Protocol TCP `
  -LocalPort 5000
```

### Vérifier si le port 5000 est utilisé

```powershell
# Voir tous les ports utilisés
netstat -ano | findstr "5000"

# Voir quel processus utilise le port
Get-Process | Where-Object {$_.Id -eq [numéro du processus]}
```

---

## 🔄 Retirer la règle (si besoin)

```powershell
# Supprimer la règle
Remove-NetFirewallRule -DisplayName "Express API 5000"

# Vérifier qu'elle a été supprimée
Get-NetFirewallRule -DisplayName "Express API 5000" -ErrorAction SilentlyContinue
```

---

## 📋 Checklist

- [ ] PowerShell ouvert en **Admin**
- [ ] Règle créée: `Express API 5000`
- [ ] Règle est **Activée** (Enabled = True)
- [ ] Direction: **Inbound** (trafic entrant)
- [ ] Port: **5000**
- [ ] Protocole: **TCP**
- [ ] Profil: **Domaine, Privé, Public**
- [ ] Test réussi: `TcpTestSucceeded : True`
- [ ] Backend accessible: `http://192.168.1.20:5000/`

---

## 💡 Notes importantes

✅ **Le port 5000 doit être ouvert AVANT de tester l'app**

✅ **Si tu fermes PowerShell, la règle reste (elle est persistante)**

✅ **La règle s'applique à tous les appareils sur le réseau**

✅ **Si tu relances le PC, la règle est toujours active**

---

## 🔗 Ressources supplémentaires

- Documentation Microsoft Pare-feu: https://docs.microsoft.com/fr-fr/windows/security/threat-protection/windows-defender-firewall/windows-firewall-with-advanced-security
- PowerShell Docs: https://docs.microsoft.com/en-us/powershell/module/netsecurity/
