# Docker Deployment Guide

This guide explains how to deploy Don't Starve Together Dedicated Server using Docker.

## Quick Start

### Prerequisites

- Docker 20.10+
- Docker Compose 1.29+
- A Klei cluster token (obtain from your Klei account)

### One-Liner Setup

```bash
# Copy the environment template and add your cluster token
cp .env.example .env
# Edit .env and set CLUSTER_TOKEN
nano .env

# Start the server
docker-compose up -d

# View logs
docker-compose logs -f
```

## Container Configuration

### Environment Variables

The server can be configured entirely through environment variables set in `.env`:

#### Required Variables
- **CLUSTER_TOKEN**: Your Klei cluster authentication token (required)
- **CLUSTER_NAME**: Name of your cluster (default: `DSTCluster`)

#### Server Settings
| Variable | Description | Default | Example |
|----------|-------------|---------|---------|
| `GAME_SERVER_NAME` | Server name shown in browser | `World of PopPop` | `My DST Server` |
| `GAME_SERVER_DESC` | Server description | `A DST dedicated server` | `PvE survival` |
| `GAME_MODE` | Game mode | `survival` | `survival`, `endless`, `sandbox` |
| `PVP_ENABLED` | Enable PvP combat | `false` | `true` or `false` |
| `MAX_PLAYERS` | Max concurrent players | `6` | `1-64` |

#### Network Configuration
| Variable | Description | Default |
|----------|-------------|---------|
| `MASTER_PORT` | Master world UDP port | `10999` |
| `MASTER_TCP_PORT` | Master world TCP port | `8765` |
| `CAVES_PORT` | Caves world UDP port | `11000` |
| `CAVES_TCP_PORT` | Caves world TCP port | `8766` |

#### Player Management
| Variable | Description | Format |
|----------|-------------|--------|
| `ADMIN_LIST` | Admin player IDs | Space or comma-separated KU IDs |
| `WHITELIST_LIST` | Allowed players | Space or comma-separated KU IDs |
| `BLOCKLIST` | Banned players | Space or comma-separated KU IDs |

### Example .env Configuration

```bash
CLUSTER_NAME=PopPopCluster
GAME_SERVER_NAME=World of PopPop
GAME_SERVER_DESC=Community Server - PvE Survival
GAME_MODE=survival
PVP_ENABLED=false
CLUSTER_TOKEN=your_actual_token_here_12345
ADMIN_LIST=KU_abc123 KU_def456
WHITELIST_LIST=
BLOCKLIST=
MASTER_PORT=10999
CAVES_PORT=11000
```

## Volume Mounting

### Default Volumes

The docker-compose setup creates several volumes for persistence:

- **dst-config**: Cluster configuration and tokens
- **dst-mods**: Mod files and settings
- **dst-master-data**: Master world save data
- **dst-caves-data**: Caves world save data

### Custom Configuration Files

To use custom configuration files:

```bash
# 1. Create a local directory with your configs
mkdir -p game/Master game/Caves

# 2. Copy your config files
cp /path/to/cluster.ini game/
cp /path/to/cluster_token.txt game/
cp /path/to/modoverrides.lua game/Master/
cp /path/to/worldgenoverride.lua game/Master/

# 3. Update docker-compose.yml to mount them
# The compose file already includes read-only mounts from LOCAL_GAME_DIR

# 4. Start the containers
docker-compose up -d
```

### Persistent Mods

Add mods to a volume mount:

```bash
# 1. Create mods directory
mkdir -p mods

# 2. Copy mod files
cp /path/to/modoverrides.lua mods/
cp -r /path/to/mod_folder mods/

# 3. Define volume in docker-compose or use:
docker run -v $(pwd)/mods:/app/mods ...
```

## Docker Compose Usage

### Start Services

```bash
# Start both Master and Caves
docker-compose up -d

# Start with logging output
docker-compose up

# Rebuild images before starting
docker-compose up -d --build
```

### View Logs

```bash
# View all service logs
docker-compose logs

# Follow logs in real-time
docker-compose logs -f

# View specific service logs
docker-compose logs -f master
docker-compose logs -f caves
```

### Stop Services

```bash
# Gracefully stop
docker-compose down

# Stop without removing volumes (data persists)
docker-compose stop

# Stop and remove volumes (warning: deletes data)
docker-compose down -v
```

### Service Health

```bash
# Check service status
docker-compose ps

# Inspect service health
docker inspect --format='{{json .State.Health}}' dst-master
```

## Dockerfile Details

### Build Process

The Dockerfile:
1. Uses `cm2network/steamcmd:latest` as base image (includes SteamCMD)
2. Creates directory structure at `/app`
3. Installs DST server using SteamCMD
4. Copies startup scripts
5. Exposes ports 10999 (UDP) and 8765 (TCP)
6. Sets health checks

### Manual Build

```bash
# Build image
docker build -t dst-server:latest .

# Run single container
docker run -d \
  -e CLUSTER_TOKEN=your_token \
  -p 10999:10999/udp \
  -p 8765:8765/tcp \
  -v dst-config:/app/config \
  dst-server:latest
```

## Troubleshooting

### Server Won't Start

**Symbol error or binary not found:**
- The SteamCMD installation failed
- Check build logs: `docker-compose build --no-cache master`
- Verify base image is available: `docker pull cm2network/steamcmd:latest`

**Container exits immediately:**
- Check logs: `docker-compose logs master`
- Verify `CLUSTER_TOKEN` is set correctly
- Ensure `cluster.ini` is present in mounted config

### Connection Issues

**Clients can't connect:**
- Verify firewall allows ports 10999/UDP and 8765/TCP
- Check `docker-compose ps` shows "healthy"
- Verify port mapping: `docker port dst-master`

**"Shards not connected":**
- Master must start before Caves (docker-compose handles this)
- Check both services are running: `docker-compose ps`
- Review health checks: `docker inspect dst-master`

### Performance

**High memory usage:**
- Set resource limits in docker-compose:
  ```yaml
  resources:
    limits:
      memory: 2G
  ```

**Network lag:**
- Reduce tick rate in `server.ini`: `tick_rate = 15`
- Check Docker network: `docker network inspect dst-network`

### Token Issues

**"Invalid cluster_token":**
- Token is expired or incorrect
- Obtain fresh token from Klei
- Ensure `CLUSTER_TOKEN` env var is set without quotes or extra whitespace

**Token visible in logs (security issue):**
- Check `config-helper.sh` hides token: `chmod 600 cluster_token.txt`
- Verify logs don't include token: `docker-compose logs | grep -i token` (should be empty)

## Advanced Configuration

### Custom World Generation

Create a `game/Master/worldgenoverride.lua`:

```lua
return {
  override_enabled = true,
  preset = "default",
  overrides = {
    terrain_type = "default",
    forest = "default",
  }
}
```

Mount it in docker-compose volumes.

### Mod Management

Create `game/Master/modoverrides.lua`:

```lua
return {
  {mod_id="workshop-123456", enabled=true},
  {mod_id="workshop-789012", enabled=true},
}
```

### Resource Limits

In `docker-compose.yml`:

```yaml
services:
  master:
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 2G
        reservations:
          cpus: '1'
          memory: 1G
```

## Production Deployment

### Networking

For external access, use port forwarding:

```bash
# Use fixed ports for stable connections
MASTER_PORT=10999
CAVES_PORT=11000

# Forward on host firewall:
# ufw allow 10999/udp
# ufw allow 11000/udp
# ufw allow 8765/tcp
# ufw allow 8766/tcp
```

### Backups

```bash
# Backup volumes
docker run --rm \
  -v dst-master-data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/master-data.tar.gz -C /data .

# Restore from backup
docker run --rm \
  -v dst-master-data:/data \
  -v $(pwd):/backup \
  alpine tar xzf /backup/master-data.tar.gz -C /data
```

### Monitoring

Using health checks:

```bash
# Automatic restart on failure
docker-compose down
docker-compose up -d --restart=on-failure:3
```

## Comparison: Shell Scripts vs Docker

| Feature | Shell Script | Docker |
|---------|------|---------|
| Setup | Manual on each machine | Single build for all |
| Dependencies | System-dependent | Containerized |
| Scaling | Run multiple times | `docker-compose up` |
| Isolation | None | Full process isolation |
| Backups | Manual copy | Volume snapshots |
| Updates | Manual script update | Rebuild image |
| Multi-world | Manual coordination | docker-compose services |

Both methods are supported. Docker is recommended for production and cloud deployments.
