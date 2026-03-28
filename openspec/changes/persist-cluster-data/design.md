## Context

Currently, Cluster_1 data is copied into the Docker image at build time (Dockerfile line 26). This makes data ephemeral - container rebuilds or removal causes data loss. The ROADMAP's "Automated Backup System" requires data to exist outside the container.

## Goals / Non-Goals

**Goals:**
- Persist Cluster_1 data outside the container using Docker volumes
- Ensure game data survives container rebuilds/removals
- Enable the Automated Backup System to work (prerequisite)

**Non-Goals:**
- Implement the backup system itself (future work)
- Support multiple clusters simultaneously (covered by Multi-Cluster Support item)
- Change the server startup mechanism

## Decisions

1. **Use bind mount vs named volume**
   - Decision: Bind mount (`./Cluster_1:/home/steam/.klei/DoNotStarveTogether/Cluster_1`)
   - Rationale: Easier to inspect and backup manually, simpler for development, works well with volume backup tools
   - Alternative considered: Named volume - harder to inspect but more portable

2. **Remove COPY instruction from Dockerfile**
   - Decision: Remove `COPY --chown=steam:steam Cluster_1 "$DONTSTARVE_DIR/Cluster_1"`
   - Rationale: Data now comes from volume mount, not baked into image
   - Must ensure Cluster_1 folder exists locally before first run

3. **Create Cluster_1 scaffold if missing**
   - Decision: Create a basic Cluster_1 folder with required config files (cluster.ini, cluster_token.txt)
   - Rationale: First-time users need these files; prevents container crash on startup

## Risks / Trade-offs

- **Risk**: First-time setup requires creating Cluster_1 folder with config → **Mitigation**: Provide instructions/scaffold in README
- **Risk**: Permissions issues with bind mount → **Mitigation**: Ensure host folder is readable/writable by the steam user (UID 1000)
- **Risk**: Data loss if volume not backed up → **Mitigation**: Document backup procedures; enable Automated Backup System in ROADMAP
