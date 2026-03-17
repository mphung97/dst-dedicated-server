#!/bin/bash
# Container startup script for DST dedicated server

set -e

# Logging function
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

# Configuration paths
GAME_DIR="${GAME_DIR:-/app/game}"
CONFIG_DIR="${CONFIG_DIR:-/app/config}"
INSTALL_DIR="${INSTALL_DIR:-/app/server}"
MODS_DIR="${MODS_DIR:-/app/mods}"

# Determine if running in container
IN_CONTAINER=1
export IN_CONTAINER

log "Starting DST Dedicated Server in container environment"
log "Game Directory: $GAME_DIR"
log "Config Directory: $CONFIG_DIR"
log "Install Directory: $INSTALL_DIR"

# Ensure required directories exist
mkdir -p "$GAME_DIR/Master"
mkdir -p "$GAME_DIR/Caves"
mkdir -p "$MODS_DIR"
mkdir -p "$CONFIG_DIR"

# Initialize configuration from mounted files or environment
log "Initializing server configuration..."
/app/config-helper.sh

# Set up mod configuration if mods directory has content
if [ -f "$MODS_DIR/dedicated_server_mods_setup.lua" ]; then
    log "Mod setup detected, using mods from $MODS_DIR"
fi

# Get configuration parameters
CLUSTER_NAME="${CLUSTER_NAME:-DSTCluster}"
MASTER_SHARD="${MASTER_SHARD:-Master}"
CAVES_SHARD="${CAVES_SHARD:-Caves}"
RUN_CAVES="${RUN_CAVES:-true}"

log "Cluster name: $CLUSTER_NAME"
log "Running Master: yes"
log "Running Caves: $RUN_CAVES"

# Verify cluster files exist
if [ ! -f "$CONFIG_DIR/cluster.ini" ]; then
    log "ERROR: cluster.ini not found in $CONFIG_DIR"
    exit 1
fi

if [ ! -f "$CONFIG_DIR/cluster_token.txt" ]; then
    log "WARNING: cluster_token.txt not found, server will run in offline mode"
fi

# Prepare runtime environment
export LD_LIBRARY_PATH="$INSTALL_DIR/bin64:$LD_LIBRARY_PATH"
cd "$INSTALL_DIR/bin64" || exit 1

# Verify binary exists
if [ ! -f "./dontstarve_dedicated_server_nullrenderer_x64" ]; then
    log "ERROR: DST binary not found at $INSTALL_DIR/bin64"
    exit 1
fi

log "Starting DST server processes..."

# Function to run a shard
run_shard() {
    local shard="$1"
    log "Starting shard: $shard"
    
    ./dontstarve_dedicated_server_nullrenderer_x64 \
        -console \
        -cluster "$CLUSTER_NAME" \
        -monitor_parent_process $$ \
        -shard "$shard" 2>&1 | sed "s/^/$shard: /"
}

# Start Master shard
run_shard "$MASTER_SHARD" &
MASTER_PID=$!

# Start Caves shard if enabled
if [ "$RUN_CAVES" = "true" ]; then
    run_shard "$CAVES_SHARD" &
    CAVES_PID=$!
fi

# Signal handlers for graceful shutdown
trap_handler() {
    log "Received shutdown signal, terminating server processes..."
    if [ -n "$MASTER_PID" ]; then
        kill $MASTER_PID 2>/dev/null || true
    fi
    if [ -n "$CAVES_PID" ]; then
        kill $CAVES_PID 2>/dev/null || true
    fi
    exit 0
}

trap trap_handler SIGTERM SIGINT

# Keep container running
log "Server running. Press Ctrl+C to stop."
wait
