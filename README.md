# DST Dedicated Server

A containerized Don't Starve Together (DST) dedicated server setup with multi-shard support (Master and Caves), Docker deployment, and mod compatibility.

## Features

- **Multi-Shard Cluster**: Run both Master and Caves worlds in a single cluster
- **Docker Support**: Containerized setup for easy deployment across different environments
- **Mod Support**: Built-in mod management system for custom gameplay
- **Configurable**: Highly customizable server settings including gameplay mode, player limits, PvP settings, and more
- **Access Control**: Built-in support for admin lists, whitelists, and blocklists

## Project Structure

```
dst-dedicated-server/
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

- **Docker** (for containerized deployment)
- **Don't Starve Together Application Key** (for cluster authentication - placed in `Cluster_1/cluster_token.txt`)
- **SteamCMD** (included in Docker image)

## Configuration

### Cluster Configuration (`Cluster_1/cluster.ini`)

Key settings in the cluster configuration:

- **GAMEPLAY**
  - `game_mode`: Server mode (survival, wilderness, etc.)
  - `max_players`: Maximum concurrent players (default: 6)
  - `pvp`: Enable/disable PvP combat (default: false)
  - `pause_when_empty`: Pause game when no players are online (default: true)

- **NETWORK**
  - `cluster_name`: Display name of your server
  - `cluster_description`: Server description
  - `cluster_password`: Server password (optional)

- **SHARD**
  - `shard_enabled`: Enable multi-shard support (default: true)
  - `bind_ip`: Local IP for shard communication
  - `master_ip`: Master shard IP address
  - `master_port`: Master shard port
  - `cluster_key`: Shared key for inter-shard communication

### Shard-Specific Configuration

- **Master** (`Cluster_1/Master/server.ini`)
  - `is_master`: Designates this as the master shard
  - `server_port`: Port for Master world connections

- **Caves** (`Cluster_1/Caves/server.ini`)
  - Standalone shard configuration

## Setup

### 1. Obtain Cluster Token

1. Log in to your Steam account
2. Visit the [Don't Starve Together Game Servers](https://accounts.klei.com/account/game/serversettings?game=dontstarvetogether) page
3. Generate a new Cluster Authentication Token
4. Copy the token to `Cluster_1/cluster_token.txt`

### 2. Configure Server Settings

Edit `Cluster_1/cluster.ini` with your desired server name, description, gameplay settings, and other preferences.

### 3. (Optional) Add Mods

Place mod files in the `mods/` directory and configure them in the mod override files.

## Deployment

### Using Docker Compose (Recommended)

```bash
# Start the server
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the server
docker-compose down
```

The `docker-compose.yml` file handles building the image, exposing ports, and mounting configuration volumes automatically.

### Using Docker

```bash
# Build the Docker image
docker build -t dst-dedicated-server .

# Run the container
docker run -d \
  --name dst-server \
  -p 10889:10889/udp \
  -p 10888:10888/udp \
  -p 11000:11000/udp \
  dst-dedicated-server
```

### Direct Execution

```bash
# Run the startup script directly (requires SteamCMD installed)
./run_dedicated_servers.sh
```

## Server Ports

The server uses the following UDP ports:

- **10889**: Cluster communication (Master shard default)
- **10888**: Shard communication
- **11000**: Master world connections (configurable in `Master/server.ini`)

## Access Control

### Admin List (`Cluster_1/adminlist.txt`)

Add player names or Klei user IDs (one per line) to grant admin privileges.

### Whitelist (`Cluster_1/whitelist.txt`)

If configured, only whitelisted players can join. Add player names or Klei user IDs.

### Blocklist (`Cluster_1/blocklist.txt`)

Players listed here are blocked from joining the server.

## Mods

Mods are configured through the `mods/` directory:

1. **Adding Mods**: Place downloaded mod files in `mods/`
2. **Configuration**: Edit `mods/modsettings.lua` and `mods/dedicated_server_mods_setup.lua`
3. **Shard-Specific Overrides**: Use `modoverrides.lua` in Master and Caves directories for world-specific mod settings

For more information, see `mods/INSTALLING_MODS.txt` and `mods/MAKING_MODS.txt`.

## Troubleshooting

- **Missing cluster_token.txt**: Generate a token from your Klei account and place it in `Cluster_1/cluster_token.txt`
- **Server won't start**: Check that all required configuration files are present and properly formatted
- **Connection issues**: Verify firewall rules allow UDP traffic on the configured ports
- **Mods not loading**: Check mod configuration in `modsettings.lua` and the `modoverrides.lua` files

## Additional Resources

- [Klei Forum - Don't Starve Together Modding](http://forums.kleientertainment.com/downloads.php)
- [Don't Starve Together Wiki](https://dontstarve.fandom.com/)

## License

This project is a community-created dedicated server configuration for Don't Starve Together.
Don't Starve Together is developed by Klei Entertainment.
