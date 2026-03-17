## ADDED Requirements

### Requirement: Build Docker image from source

The system SHALL build a Docker image containing the DST dedicated server and all required dependencies. The image MUST base from a lightweight Linux distribution and include the DST server binary, necessary libraries, and startup scripts.

#### Scenario: Build image successfully
- **WHEN** docker build is executed with the provided Dockerfile
- **THEN** a valid Docker image is created with DST server installed and ready to run

#### Scenario: Image includes dependencies
- **WHEN** the image is built
- **THEN** it includes all required DST dependencies (libc, libraries for the server binary, etc.)

### Requirement: Container networking configuration

The system SHALL configure proper networking to allow the DST server to communicate with game clients. The container MUST expose required game ports (UDP 10999 and TCP 8765) and allow port mapping to host.

#### Scenario: Game port exposure
- **WHEN** a container is run from the image
- **THEN** UDP port 10999 and TCP port 8765 are exposed for game traffic

#### Scenario: Port mapping to host
- **WHEN** container is run with -p flag
- **THEN** container ports can be mapped to host ports for external access

### Requirement: Persistent volume management

The system SHALL support volume mounting for game data, configurations, and mods to ensure data persists across container restarts and enables easy backup/restore.

#### Scenario: Mount game data volume
- **WHEN** container runs with volume mount for /app/game
- **THEN** world data persists after container stops and is accessible from host

#### Scenario: Mount mods volume
- **WHEN** container runs with volume mount for /app/mods
- **THEN** mod files persist and can be updated without rebuilding image

### Requirement: Health check mechanism

The system SHALL provide a health check that allows container orchestration tools to detect if the server process is running correctly.

#### Scenario: Health check passes when running
- **WHEN** health check is executed on a running container
- **THEN** it returns success status

#### Scenario: Health check fails when crashed
- **WHEN** server process has crashed inside the container
- **THEN** health check returns failure status

### Requirement: Container startup with environment awareness

The system SHALL detect when running in a container environment and configure the server appropriately with container-specific paths and settings.

#### Scenario: Initialize in container environment
- **WHEN** container starts
- **THEN** startup script detects container environment and uses /app paths instead of relative paths

#### Scenario: Process runs as container foreground process
- **WHEN** container starts
- **THEN** DST server runs as the main process (PID 1) without daemonization
