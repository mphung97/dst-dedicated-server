# Design: Two-Image Docker Split for DST Dedicated Server

**Date:** 2026-04-03
**Status:** Draft

## Context

The current single Dockerfile combines DST server binary installation with cluster configuration. This makes every rebuild re-download SteamCMD content even when only cluster config changes.

## Goal

Split into two local Docker images:
- **dst-base** — DST server binaries (slow to build, rarely changes)
- **dst-cluster** — Cluster config + launcher (fast to build, changes frequently)

## Architecture

```
┌─────────────────────┐     ┌──────────────────────┐
│   Dockerfile.base   │     │  Dockerfile.cluster  │
│                     │     │                      │
│ steamcmd:latest     │────▶│ dst-base:local       │
│ + apt deps          │     │ + Cluster_1/         │
│ + SteamCMD download │     │ + run script         │
│                     │     │ + ENTRYPOINT         │
└─────────────────────┘     └──────────────────────┘
```

## File Changes

### New: `Dockerfile.base`
- Base: `cm2network/steamcmd:latest`
- Installs `libcurl4-gnutls-dev`
- Downloads DST server (app 343050) via SteamCMD to `$INSTALL_DIR`
- No COPY of cluster data, no ENTRYPOINT
- Sets up directories and permissions

### New: `Dockerfile.cluster`
- Base: `dst-base:local`
- Copies `Cluster_1/` → `$DONTSTARVE_DIR/Cluster_1`
- Copies `run_dedicated_servers.sh` → `/home/steam/run_dedicated_servers.sh`
- Sets executable permission on script
- EXPOSE 10889/udp 10888/udp
- ENTRYPOINT: `/home/steam/run_dedicated_servers.sh`

### Modified: `docker-compose.yml`
- Build references `Dockerfile.cluster`
- Volume mount for mods remains unchanged
- Ports, restart policy, environment unchanged

### Removed: `Dockerfile`
- Replaced by the two new files

## Build Flow

```bash
# Build base image (run once, or when DST server updates)
docker build -t dst-base:local -f Dockerfile.base .

# Build cluster image and run
docker-compose up -d
```

## Environment Variables

Both images share the same ENV vars defined in the original Dockerfile:
- `STEAM_HOME=/home/steam/steamcmd`
- `INSTALL_DIR=/home/steam/dontstarvetogether_dedicated_server`
- `DONTSTARVE_DIR=/home/steam/.klei/DoNotStarveTogether`

These are defined in `Dockerfile.base` and inherited by `Dockerfile.cluster`.

## Trade-offs

- **Pro:** Base image caches SteamCMD download (~2-3 min saved per cluster rebuild)
- **Pro:** Clear separation of concerns
- **Con:** Two-step build process (base must exist before cluster builds)
- **Mitigation:** A Makefile or script can wrap the two commands
