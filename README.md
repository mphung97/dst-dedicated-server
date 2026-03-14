# World of PopPop - Don't Starve Together Dedicated Server

A Don't Starve Together (DST) dedicated server setup for macOS and Linux with dual-shard support (Master + Caves).

## Features

- **Dual Shard**: Master world + Caves dimension
- **Multiplayer**: Up to 6 players (non-PvP, survival mode)
- **Cross-Platform**: macOS and Linux startup scripts
- **Mod Support**: Easy mod management and configuration
- **Player Management**: Admin list, whitelist, and blocklist support

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
- `mods/dedicated_server_mods_setup.lua`: Dedicated server mod configuration
- World-specific overrides in `Master/modoverrides.lua` and `Caves/modoverrides.lua`

### macOS Dedicated Server

To install mods on the macOS dedicated server, copy the mods folder to the dedicated server installation:

```bash
cp -r ~/dev/MyDediServer/mods ~/dontstarvetogether_dedicated_server/dontstarve_dedicated_server_nullrenderer.app/Contents/Resources/mods
```


## Directory Structure

```
├── linux.sh                 # Linux startup script
├── macos.sh                 # macOS startup script
├── README.md                # This file
├── game/                    # Game configuration and world data
│   ├── cluster.ini          # Main server configuration
│   ├── cluster_token.txt    # Cluster authentication token
│   ├── adminlist.txt        # Server administrators
│   ├── whitelist.txt        # Whitelisted players (optional)
│   ├── blocklist.txt        # Banned players
│   ├── Master/              # Master world files
│   │   ├── server.ini       # Master shard configuration
│   │   ├── modoverrides.lua # Master-specific mod overrides
│   │   └── worldgenoverride.lua # Master world generation settings
│   └── Caves/               # Caves world files
│       ├── server.ini       # Caves shard configuration
│       ├── modoverrides.lua # Caves-specific mod overrides
│       └── worldgenoverride.lua # Caves world generation settings
└── mods/                    # Mod configuration and setup
    ├── modsettings.lua      # Global mod settings
    ├── dedicated_server_mods_setup.lua # Mod setup script
    ├── INSTALLING_MODS.txt  # Mod installation guide
    └── MAKING_MODS.txt      # Mod creation guide
```

## Requirements

- Don't Starve Together Dedicated Server
- Valid cluster token (`cluster_token.txt`)
