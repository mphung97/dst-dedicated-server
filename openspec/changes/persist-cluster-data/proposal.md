## Why

Currently, Cluster_1 data is baked into the Docker image at build time (Dockerfile line 26 copies it into the container). This means game data (world saves, player data, mods) is lost when the container is rebuilt or removed. The ROADMAP lists "Automated Backup System" as in-progress, which requires external data storage to work. Making Cluster_1 a volume mount is a prerequisite for both data persistence and automated backups.

## What Changes

- Modify Dockerfile to remove the hardcoded Cluster_1 COPY instruction
- Update docker-compose.yml to mount Cluster_1 as a named volume
- Create initial Cluster_1 folder structure with required config files if not exists
- Document volume backup procedures for the ROADMAP backup system

## Capabilities

### New Capabilities
- `external-cluster-storage`: Persist Cluster_1 data outside the container using Docker volumes, enabling data survival across rebuilds and supporting the automated backup system

### Modified Capabilities
- None

## Impact

- **Dockerfile**: Remove `COPY --chown=steam:steam Cluster_1 "$DONTSTARVE_DIR/Cluster_1"` line
- **docker-compose.yml**: Add volume mount for Cluster_1 directory
- **ROADMAP**: Enables the "Automated Backup System" feature to work
