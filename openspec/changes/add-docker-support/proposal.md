## Why

Docker containerization enables consistent, reproducible deployments of the DST dedicated server across different environments (development, staging, production). This eliminates the "works on my machine" problem and simplifies server setup for new users with complex dependencies and platform-specific configurations.

## What Changes

- Add Dockerfile for container image building
- Create docker-compose.yml for multi-container orchestration (master world, caves world, optional utilities)
- Add container configuration and environment variable support
- Create documentation for Docker-based deployment
- Add health checks and container monitoring capabilities

## Capabilities

### New Capabilities
- `docker-containerization`: Build and run DST server as Docker containers with proper networking and volume management
- `docker-compose-setup`: Deploy master and caves worlds as coordinated services using Docker Compose
- `container-configuration`: Configure server through environment variables and volume-mounted config files

### Modified Capabilities

## Impact

- Deployment infrastructure and tooling
- Server startup and configuration process
- New dependencies: Docker, Docker Compose (optional but recommended for local development)
- Backward compatibility maintained: existing shell script deployments continue to work
