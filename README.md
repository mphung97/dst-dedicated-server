# World of PopPop - Don't Starve Together Dedicated Server

A Don't Starve Together (DST) dedicated server setup for macOS and Linux with dual-shard support (Master + Caves).

## Features

- **Dual Shard**: Master world + Caves dimension
- **Multiplayer**: Up to 6 players (non-PvP, survival mode)
- **Cross-Platform**: macOS and Linux startup scripts
- **Mod Support**: Easy mod management and configuration
- **Player Management**: Admin list, whitelist, and blocklist support

## Quick Start

### macOS
```bash
./macos.sh
```

### Linux
```bash
bash linux.sh
```

## Configuration

### Main Settings
Edit `cluster.ini`:
- `cluster_name`: Server name (default: "World of PopPop")
- `cluster_password`: Server password
- `max_players`: Max concurrent players (default: 6)
- `pvp`: Enable/disable PvP (default: false)

### Shard Configuration
- **Master**: `Master/server.ini` and `Master/modoverrides.lua`
- **Caves**: `Caves/server.ini` and `Caves/modoverrides.lua`

### Player Lists
- `whitelist.txt`: Allowed players (optional)
- `adminlist.txt`: Admin/moderator access
- `blocklist.txt`: Banned players

## Mods

Add mods to the `mods/` folder. Mods are configured in:
- `mods/modsettings.lua`: Global mod settings
- World-specific overrides in `Master/modoverrides.lua` and `Caves/modoverrides.lua`

See `mods/INSTALLING_MODS.txt` for detailed instructions.

## Directory Structure

```
├── cluster.ini              # Main server configuration
├── Master/                  # Master world files
├── Caves/                   # Caves world files
├── mods/                    # Mod configuration
├── adminlist.txt            # Server admins
└── startup scripts          # Platform-specific launchers
```

## Requirements

- Don't Starve Together Dedicated Server
- Valid cluster token (`cluster_token.txt`)
