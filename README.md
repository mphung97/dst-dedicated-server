<div align="center">

# 🌑 Don't Starve Together: Dedicated Server 🌑

### *Multi-Shard • Dockerized • Mod-Ready*

[![Docker](https://img.shields.io/badge/Docker-Containerized-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![SteamCMD](https://img.shields.io/badge/SteamCMD-Included-171a21?style=for-the-badge&logo=steam&logoColor=white)](https://developer.valvesoftware.com/wiki/SteamCMD)
[![Lua](https://img.shields.io/badge/Lua-Configurable-000080?style=for-the-badge&logo=lua&logoColor=white)](https://www.lua.org/)

*Forge your own world in the constant darkness. Control Master and Cave shards seamlessly.*

[✨ Features](#-features) • [🚀 Quick Start](#-quick-start) • [⚙️ Configuration](#-configuration) • [🔮 Mods](#-modding-system)

</div>

---

## ✨ Features

| Feature | Description |
| :--- | :--- |
| **🌍 Dual Worlds** | Seamless **Master** & **Caves** shard support. |
| **🐳 Docker First** | Zero-headache deployment with `docker-compose`. |
| **🛡️ Security** | Integrated **Admin**, **Whitelist**, and **Blocklist** controls. |
| **🔧 Mod Support** | Easy-to-use mod injection system for custom gameplay. |
| **⚡ Performance** | Optimized configuration for stable, low-latency play. |

---

## 📂 Architecture

```bash
dst-dedicated-server/
├── 🐳 docker-compose.yml       # Orchestration logic
├── 🏗️ Dockerfile               # Container definition
├── 📜 run_dedicated_servers.sh # Boot script
├── 📂 Cluster_1/               # Main Game Data
│   ├── 🔑 cluster_token.txt    # Auth Token (Required)
│   ├── ⚙️ cluster.ini          # Core Settings
│   ├── 📜 adminlist.txt        # Admin UUIDs
│   ├── 🏰 Master/              # Overworld Shard
│   └── 🦇 Caves/               # Underworld Shard
└── 📦 mods/                    # Mod Configuration
    ├── ⚙️ dedicated_server_mods_setup.lua
    └── 📜 modsettings.lua
```

---

## 🚀 Quick Start

### 1. 🔑 Get Your Token
Generate a cluster token from the [Klei Account Page](https://accounts.klei.com/account/game/serversettings?game=dontstarvetogether).
Paste it into:
`Cluster_1/cluster_token.txt`

### 2. ⚡ Launch
Spin up the server fortress:
```bash
docker-compose up -d
```
*The server will initialize, download SteamCMD files, and update the game.*

### 3. 👀 Monitor
Watch the console for the "Server Started" message:
```bash
docker-compose logs -f
```

---

## 💾 Data Persistence & Backups

Game data (world saves, player data, mods) is stored in the `Cluster_1` folder on the host machine and mounted into the container. This ensures data survives container rebuilds and removals.

### First-Time Setup

1. Ensure `Cluster_1/cluster_token.txt` contains your Klei server token
2. Run `docker-compose up -d` to start the server
3. The server will create required subdirectories (Master/, Caves/) on first run

### Backing Up Data

To backup your server data:
```bash
# Stop the container first
docker-compose down

# Backup the Cluster_1 folder
cp -r Cluster_1 Cluster_1.backup.$(date +%Y%m%d)

# Restart the server
docker-compose up -d
```

To restore from a backup:
```bash
docker-compose down
rm -rf Cluster_1
cp -r Cluster_1.backup.20240101 Cluster_1
docker-compose up -d
```

---

## ⚙️ Configuration

### 🎮 Gameplay Settings
Edit `Cluster_1/cluster.ini` to tune your experience.

```ini
[GAMEPLAY]
game_mode = survival   ; survival, wilderness, or endless
max_players = 6        ; Scale for your group size
pvp = false            ; Friendly fire?
pause_when_empty = true ; Save resources when idle
```

### 🕸️ Network Ports (UDP)

| Port | Service | Description |
| :--- | :--- | :--- |
| `10889` | **Master** | Main connection point |
| `10888` | **Inter-Shard** | Caves <-> Master link |
| `11000` | **Steam** | Authentication |

---

## 🔮 Modding System

Customize your world by editing the files in `mods/`.

1.  **Define Mods:** Add IDs to `dedicated_server_mods_setup.lua`.
    ```lua
    ServerModSetup("345692228") -- Minimap HUD
    ```
2.  **Enable Mods:** Configure settings in `Master/modoverrides.lua` and `Caves/modoverrides.lua`.

---

## 🛠️ Troubleshooting

<details>
<summary><strong>⚠️ Server Won't Start</strong></summary>

*   Ensure `cluster_token.txt` exists and is valid.
*   Check write permissions on the `Cluster_1` folder.
</details>

<details>
<summary><strong>⚠️ "Cluster Token Not Found"</strong></summary>

*   The file must be named exactly `cluster_token.txt` (not `.txt.txt`).
*   It must reside in the root of `Cluster_1/`.
</details>

<details>
<summary><strong>⚠️ Mods Not Downloading</strong></summary>

*   Check internet connectivity within the container.
*   Verify Workshop IDs on Steam.
</details>
