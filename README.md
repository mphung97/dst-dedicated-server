# 🌙 DON'T STARVE TOGETHER MULTI-SHARD DEDICATED SERVER 🌙

**Survive Together in the Darkness**

---

> **A containerized Don't Starve Together (DST) dedicated server setup with multi-shard support (Master and Caves), Docker deployment, and mod compatibility.**

---

## ⚔️ Features

- 🌍 **Master & Caves Worlds** - Control dual-shard reality with multi-world support
- 🐳 **Docker Containerized** - Deploy anywhere with zero configuration headaches  
- 🔧 **Mod Management System** - Customize your world with powerful modding support
- ⚙️ **Deep Customization** - Tune every aspect: modes, players, PvP, gameplay mechanics
- 🛡️ **Server Security** - Admin lists, whitelists, and blocklists for complete access control

---

## 📜 Project Structure

```
dst-dedicated-server/
├── docker-compose.yml             # Docker Compose configuration
├── Dockerfile                    # Docker container definition
├── run_dedicated_servers.sh       # Main server startup script
├── .gitignore                     # Git ignore rules
├── Cluster_1/                     # Main server cluster
│   ├── cluster_token.txt          # Cluster authentication token (required)
│   ├── cluster_token.example.txt  # Example cluster token
│   ├── cluster.ini                # Cluster-wide configuration
│   ├── adminlist.txt              # Server administrators list
│   ├── whitelist.txt              # Player whitelist (optional)
│   ├── blocklist.txt              # Player blocklist
│   ├── Master/                    # Master world shard
│   │   ├── server.ini             # Master shard configuration
│   │   ├── modoverrides.lua       # Mod overrides for Master
│   │   └── worldgenoverride.lua   # World generation settings for Master
│   └── Caves/                     # Caves world shard
│       ├── server.ini             # Caves shard configuration
│       ├── modoverrides.lua       # Mod overrides for Caves
│       └── worldgenoverride.lua   # World generation settings for Caves
└── mods/                          # Server-side mods directory
    ├── dedicated_server_mods_setup.lua  # Mod setup configuration
    ├── modsettings.lua            # Global mod settings
    ├── INSTALLING_MODS.txt        # Mod installation guide
    └── MAKING_MODS.txt            # Mod creation guide
```

## Prerequisites

- 🐳 **Docker** - Container runtime environment
- 🔐 **Klei Account & Application Key** - Required for server authentication  
- 📦 **SteamCMD** - Automatically included in Docker image

---

## ⚙️ Configuration Guide

### 🎮 Cluster Configuration (`Cluster_1/cluster.ini`)

**Gameplay Settings:**
- `game_mode` - Server mode (survival, wilderness, etc.)
- `max_players` - Maximum concurrent players (default: 6)
- `pvp` - Enable/disable combat between players (default: false)
- `pause_when_empty` - Pause game when players are offline (default: true)

**Network Settings:**
- `cluster_name` - Your server's display name
- `cluster_description` - Server description (shown in server browser)
- `cluster_password` - Optional password protection

**Multi-Shard Settings:**
- `shard_enabled` - Enable multi-shard support (default: true)
- `bind_ip` - Local IP for shard communication
- `master_ip` - Master shard IP address
- `master_port` - Master shard port
- `cluster_key` - Shared key for inter-shard communication

### 🌍 Per-Shard Configuration

**Master Shard** (`Cluster_1/Master/server.ini`)
- `is_master` - Marks this as the master shard
- `server_port` - Port for Master world connections

**Caves Shard** (`Cluster_1/Caves/server.ini`)
- Independent shard configuration

---

## 🚀 Setup Wizard

### Step 1: Retrieve Your Cluster Token 🔐

1. Log in to your **Steam** account
2. Navigate to the [Don't Starve Together Game Servers](https://accounts.klei.com/account/game/serversettings?game=dontstarvetogether) page
3. Generate a new **Cluster Authentication Token**
4. Paste the token into `Cluster_1/cluster_token.txt`

### Step 2: Customize Server Settings ⚙️

Edit `Cluster_1/cluster.ini` and configure:
- Server name & description  
- Gameplay mode and difficulty
- Player limits and PvP settings
- Other game mechanics

### Step 3: Add Mods (Optional) 📦

Place mod files in the `mods/` directory and configure in the mod override files.

---

## 🎯 Deployment Options

### 🐳 Docker Compose (Recommended)

```bash
# ⚡ Launch your server
docker-compose up -d

# 👀 Watch the action unfold
docker-compose logs -f

# 🛑 Shut down your realm
docker-compose down
```

The `docker-compose.yml` automatically handles image building, port exposure, and volume mounting.

### 🐳 Manual Docker Deployment

```bash
# Build your server container
docker build -t dst-dedicated-server .

# Launch the server fortress
docker run -d \
  --name dst-server \
  -p 10889:10889/udp \
  -p 10888:10888/udp \
  -p 11000:11000/udp \
  dst-dedicated-server
```

### ⚡ Direct Execution

```bash
# Run the server script directly (SteamCMD must be installed)
./run_dedicated_servers.sh
```

---

## 🌐 Network Ports

All ports use **UDP protocol**:

| Port | Purpose |
|------|---------|
| **10889** | Cluster communication (Master shard) |
| **10888** | Inter-shard communication |
| **11000** | Master world connections |

---

## 👥 Player Access Control

### 🤝 Admin List (`Cluster_1/adminlist.txt`)

Grant admin privileges to trusted players. Add one player per line:
- Player names
- Klei user IDs

Admins can kick players, change settings, and manage the server.

### ✅ Whitelist (`Cluster_1/whitelist.txt`)

Enable whitelist mode to restrict access. Only listed players can join:
- Player names
- Klei user IDs

### ❌ Blocklist (`Cluster_1/blocklist.txt`)

Permanently ban troublemakers. Blocked players cannot join:

- Player names
- Klei user IDs

---

## 🔮 Modding System

Enhance your realm with powerful mods:

1. **Add Mods** - Download and place mod files in `mods/` directory
2. **Configure Globally** - Edit `mods/modsettings.lua` and `mods/dedicated_server_mods_setup.lua`
3. **Per-World Tweaks** - Customize individual worlds using:
   - `Master/modoverrides.lua` - Master world mod settings
   - `Caves/modoverrides.lua` - Caves world mod settings

📚 **Learn More:** See `mods/INSTALLING_MODS.txt` and `mods/MAKING_MODS.txt` for detailed guides.

---

## ⚠️ Troubleshooting Guide

### 🔴 Server Won't Start

- Check that all files in `Cluster_1/` are present and properly formatted
- Verify `cluster_token.txt` contains a valid token
- Check Docker/SteamCMD logs for error messages

### 🔴 Token Not Found

```
Missing cluster_token.txt: Generate a token from your Klei account and 
place it directly in Cluster_1/cluster_token.txt
```

### 🔴 Connection Problems

- Verify firewall allows **UDP traffic** on ports 10889, 10888, 11000
- Check that your router allows UPnP or manually port-forward
- Confirm shard IP addresses in `cluster.ini` match your network setup

### 🔴 Mods Not Loading

- Verify mod files are in `mods/` directory (must be `.lua` format)
- Check `modsettings.lua` contains correct mod names
- Review `modoverrides.lua` files for syntax errors
- Check Docker logs for lua compilation errors

---

## 🔗 Resources & Community

- 📖 **[Modding Knowledge](http://forums.kleientertainment.com/downloads.php)** - Klei Forum Downloads
- 📚 **[Game Wiki](https://dontstarve.fandom.com/)** - Don't Starve Together Wiki
- 🎮 **[Official Wiki](https://dontstarve.fandom.com/wiki/Don%27t_Starve_Together)** - Complete Gameplay Guide

---

## 📜 License & Credits

This project is a community-created dedicated server configuration for **Don't Starve Together**.

**Don't Starve Together** is developed by **Klei Entertainment**.

---

### 🌙 Happy Surviving! Don't Starve Together! 🌙

---
