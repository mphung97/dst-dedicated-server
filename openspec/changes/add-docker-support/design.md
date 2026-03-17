## Context

The DST dedicated server currently relies on shell scripts (linux.sh, macos.sh) for deployment and has complex setup involving modding, configuration files, and environment-specific settings. Users deploying to production environments (particularly in cloud infrastructure) need containerized support. The existing startup scripts handle mod installation, server configuration, and process management.

## Goals / Non-Goals

**Goals:**
- Enable deployment via Docker and Docker Compose
- Support both Master and Caves worlds as separate services
- Maintain backward compatibility with existing shell script deployments
- Simplify server initialization through environment variables and mounted volumes
- Enable horizontal scaling and orchestration in Kubernetes/cloud environments
- Provide health checks for container orchestration

**Non-Goals:**
- Replace existing shell scripts (they remain the primary deployment method)
- Implement Kubernetes-specific configurations (Docker Compose is the primary orchestration target)
- Automate mod management beyond environment variable configuration
- Create custom registry/authentication systems

## Decisions

**1. Multi-container architecture (Master + Caves as separate services)**
- _Why_: Allows independent scaling, restarts, and resource allocation for each world
- _Alternative_: Single container with both worlds - rejected because it creates tight coupling and prevents independent management
- _Implementation_: docker-compose.yml defines two services with shared volumes for config/mods

**2. Use environment variables for configuration**
- _Why_: Follows Docker best practices, integrates with container orchestration systems, supports secrets management
- _Alternative_: Config file injection - accepted but primary method is env vars
- _Implementation_: Startup script reads env vars and populates config files

**3. Dockerfile based on lightweight Linux base (Alpine preferred, Ubuntu fallback)**
- _Why_: Smallest image size, faster pulls, reduced attack surface
- _Alternative_: CentOS, Debian - rejected due to larger image size
- _Implementation_: Multi-stage build to minimize final image size

**4. Volume mounts for persistence**
- _Why_: Separates runtime data from image, enables easy backups and config management
- _Structure_:
  - `/app/game/Master` - Master world data
  - `/app/game/Caves` - Caves world data
  - `/app/mods` - Mod files
  - `/app/config` - Configuration files (cluster token, etc.)

**5. Health checks via status endpoints**
- _Why_: Enables Docker/orchestration to detect stuck/crashed containers
- _Implementation_: Simple check that server process is running

## Risks / Trade-offs

- **Risk**: Larger image than needed for users who only need Master world
  - **Mitigation**: Use build-time arguments to conditionally build worlds
  
- **Risk**: Mod management complexity in containers
  - **Mitigation**: Document mod mounting and initialization process; provide examples
  
- **Risk**: Performance overhead vs direct installation
  - **Mitigation**: Accept minimal overhead; users can use shell scripts if performance-critical
  
- **Risk**: Users unfamiliar with Docker may find it harder to debug issues
  - **Mitigation**: Provide comprehensive documentation and troubleshooting guide

## Migration Plan

1. Create Dockerfile with DST server setup and dependencies
2. Create docker-compose.yml template
3. Update startup to support containerized environment detection
4. Create documentation with examples
5. Test locally with Docker Desktop
6. Gradual user adoption; shell scripts remain primary method
