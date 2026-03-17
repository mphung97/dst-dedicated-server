#!/bin/bash
# Configuration helper script for DST dedicated server
# Handles environment variable mapping to server configuration

set -e

GAME_DIR="${GAME_DIR:-/app/game}"
CONFIG_DIR="${CONFIG_DIR:-/app/config}"
MODS_DIR="${MODS_DIR:-/app/mods}"

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

# Copy default cluster.ini if mounted config doesn't exist
if [ ! -f "$CONFIG_DIR/cluster.ini" ] && [ -f "$GAME_DIR/cluster.ini" ]; then
    log "Copying cluster.ini from $GAME_DIR to $CONFIG_DIR"
    cp "$GAME_DIR/cluster.ini" "$CONFIG_DIR/cluster.ini"
elif [ ! -f "$CONFIG_DIR/cluster.ini" ]; then
    log "Creating default cluster.ini"
    cat > "$CONFIG_DIR/cluster.ini" << 'EOF'
[GAMEPLAY]
max_players = 6
pvp = false
pause_when_empty = true
vote_enabled = true

[NETWORK]
server_port = 10999
offline_server = false

[MISC]
console_enabled = true
log_everything = true
EOF
fi

# Copy Master/server.ini if not present
if [ ! -f "$CONFIG_DIR/Master/server.ini" ]; then
    mkdir -p "$CONFIG_DIR/Master"
    log "Creating default Master/server.ini"
    cat > "$CONFIG_DIR/Master/server.ini" << 'EOF'
[MISC]
max_snapshots = 6
console_enabled = true
tick_rate = 15
EOF
fi

# Copy Caves/server.ini if not present
if [ ! -f "$CONFIG_DIR/Caves/server.ini" ]; then
    mkdir -p "$CONFIG_DIR/Caves"
    log "Creating default Caves/server.ini"
    cat > "$CONFIG_DIR/Caves/server.ini" << 'EOF'
[MISC]
max_snapshots = 6
console_enabled = true
tick_rate = 15
shard_enabled = true
shard_role = slave
EOF
fi

# Apply environment variable overrides to cluster.ini
if [ -n "$GAME_SERVER_NAME" ]; then
    log "Setting server name: $GAME_SERVER_NAME"
    sed -i "s/^cluster_name = .*/cluster_name = $GAME_SERVER_NAME/" "$CONFIG_DIR/cluster.ini" 2>/dev/null || true
fi

if [ -n "$GAME_SERVER_DESC" ]; then
    log "Setting server description: $GAME_SERVER_DESC"
    # Add to cluster.ini if not present
    if ! grep -q "cluster_description" "$CONFIG_DIR/cluster.ini"; then
        echo "cluster_description = $GAME_SERVER_DESC" >> "$CONFIG_DIR/cluster.ini"
    else
        sed -i "s/^cluster_description = .*/cluster_description = $GAME_SERVER_DESC/" "$CONFIG_DIR/cluster.ini" 2>/dev/null || true
    fi
fi

if [ -n "$GAME_MODE" ]; then
    log "Setting game mode: $GAME_MODE"
    # Add game_mode if not present
    if ! grep -q "game_mode" "$CONFIG_DIR/cluster.ini"; then
        echo "game_mode = $GAME_MODE" >> "$CONFIG_DIR/cluster.ini"
    else
        sed -i "s/^game_mode = .*/game_mode = $GAME_MODE/" "$CONFIG_DIR/cluster.ini" 2>/dev/null || true
    fi
fi

if [ -n "$PVP_ENABLED" ] && [ "$PVP_ENABLED" = "true" ]; then
    log "Enabling PvP mode"
    sed -i "s/^pvp = .*/pvp = true/" "$CONFIG_DIR/cluster.ini" 2>/dev/null || true
fi

# Configure ports if specified
if [ -n "$MASTER_PORT" ]; then
    log "Setting Master port: $MASTER_PORT"
    if [ ! -f "$CONFIG_DIR/worldgenoverride.lua" ]; then
        mkdir -p "$CONFIG_DIR/Master"
        echo "return { server_port = $MASTER_PORT }" > "$CONFIG_DIR/Master/server.ini"
    fi
fi

if [ -n "$CAVES_PORT" ]; then
    log "Setting Caves port: $CAVES_PORT"
    if [ ! -f "$CONFIG_DIR/Caves/server.ini" ]; then
        mkdir -p "$CONFIG_DIR/Caves"
        echo "return { server_port = $CAVES_PORT }" > "$CONFIG_DIR/Caves/server.ini"
    fi
fi

# Handle cluster token
if [ -n "$CLUSTER_TOKEN" ]; then
    log "Setting cluster token from environment"
    echo "$CLUSTER_TOKEN" > "$CONFIG_DIR/cluster_token.txt"
    chmod 600 "$CONFIG_DIR/cluster_token.txt"
elif [ ! -f "$CONFIG_DIR/cluster_token.txt" ] && [ -f "$GAME_DIR/cluster_token.txt" ]; then
    log "Copying cluster token"
    cp "$GAME_DIR/cluster_token.txt" "$CONFIG_DIR/cluster_token.txt"
    chmod 600 "$CONFIG_DIR/cluster_token.txt"
fi

# Handle admin list
if [ -n "$ADMIN_LIST" ]; then
    log "Setting admin list from environment"
    echo "$ADMIN_LIST" > "$CONFIG_DIR/adminlist.txt"
fi

# Handle whitelist
if [ -n "$WHITELIST_LIST" ]; then
    log "Setting whitelist from environment"
    echo "$WHITELIST_LIST" > "$CONFIG_DIR/whitelist.txt"
fi

# Handle blocklist
if [ -n "$BLOCKLIST" ]; then
    log "Setting blocklist from environment"
    echo "$BLOCKLIST" > "$CONFIG_DIR/blocklist.txt"
fi

# Copy world generation overrides if they exist
if [ -f "$GAME_DIR/Master/worldgenoverride.lua" ] && [ ! -f "$CONFIG_DIR/Master/worldgenoverride.lua" ]; then
    log "Copying Master worldgenoverride.lua"
    cp "$GAME_DIR/Master/worldgenoverride.lua" "$CONFIG_DIR/Master/worldgenoverride.lua"
fi

if [ -f "$GAME_DIR/Caves/worldgenoverride.lua" ] && [ ! -f "$CONFIG_DIR/Caves/worldgenoverride.lua" ]; then
    log "Copying Caves worldgenoverride.lua"
    cp "$GAME_DIR/Caves/worldgenoverride.lua" "$CONFIG_DIR/Caves/worldgenoverride.lua"
fi

# Copy mod overrides if they exist
if [ -f "$GAME_DIR/Master/modoverrides.lua" ] && [ ! -f "$CONFIG_DIR/Master/modoverrides.lua" ]; then
    log "Copying Master modoverrides.lua"
    cp "$GAME_DIR/Master/modoverrides.lua" "$CONFIG_DIR/Master/modoverrides.lua"
fi

if [ -f "$GAME_DIR/Caves/modoverrides.lua" ] && [ ! -f "$CONFIG_DIR/Caves/modoverrides.lua" ]; then
    log "Copying Caves modoverrides.lua"
    cp "$GAME_DIR/Caves/modoverrides.lua" "$CONFIG_DIR/Caves/modoverrides.lua"
fi

# Copy mod settings
if [ -f "$MODS_DIR/modsettings.lua" ] && [ ! -f "$CONFIG_DIR/modsettings.lua" ]; then
    log "Copying modsettings.lua"
    cp "$MODS_DIR/modsettings.lua" "$CONFIG_DIR/modsettings.lua"
fi

log "Configuration initialization complete"
