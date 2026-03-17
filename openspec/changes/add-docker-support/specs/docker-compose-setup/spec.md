## ADDED Requirements

### Requirement: Docker Compose multi-service orchestration

The system SHALL support defining and running multiple DST services (Master world and Caves world) as coordinated containers using docker-compose.yml. Container services SHALL share common configuration, volumes, and network namespaces.

#### Scenario: Compose file defines multiple services
- **WHEN** docker-compose.yml is examined
- **THEN** it defines separate services for master and caves worlds

#### Scenario: Start all services together
- **WHEN** docker-compose up is executed
- **THEN** both master and caves world containers start and initialize

#### Scenario: Services communicate via container network
- **WHEN** both services are running
- **THEN** they can communicate with each other via service names (e.g., master:10999)

### Requirement: Shared configuration volumes

The system SHALL allow Master and Caves services to share configuration data through volume mounts. Configuration files (cluster token, admin list, etc.) MUST be accessible from both services.

#### Scenario: Cluster token shared between worlds
- **WHEN** cluster token is placed in shared volume
- **THEN** both master and caves services can read it for authentication

#### Scenario: Admin list accessible to both services
- **WHEN** admin list is in shared volume
- **THEN** both services enforce the same admin permissions

### Requirement: Service dependency management

The system SHALL define startup order and dependencies between services. Master world service SHOULD be ready before Caves service attempts to connect.

#### Scenario: Master service starts before Caves
- **WHEN** docker-compose starts services
- **THEN** master world is fully initialized before caves world begins connection attempts

#### Scenario: Service health check integration
- **WHEN** docker-compose monitors services
- **THEN** it respects health checks and waits for healthy state before proceeding

### Requirement: Compose environment configuration

The system SHALL support .env files for configuring service parameters (cluster token, world settings, resource limits) without editing docker-compose.yml.

#### Scenario: Load environment from .env file
- **WHEN** docker-compose runs
- **THEN** it loads variables from .env file

#### Scenario: Override settings via environment variables
- **WHEN** DOCKER_* environment variables are set
- **THEN** they override defaults from .env file

### Requirement: Scaling and resource allocation

The system SHALL allow specifying resource limits and reservations per service (CPU, memory) in the compose configuration.

#### Scenario: Resource limits configured
- **WHEN** docker-compose.yml specifies limits
- **THEN** containers are constrained to those resource maximums

### Requirement: Easy stop and cleanup

The system SHALL support stopping all services and cleaning up resources with simple commands.

#### Scenario: Stop all services
- **WHEN** docker-compose down is executed
- **THEN** all services stop and network is removed

#### Scenario: Volume cleanup
- **WHEN** docker-compose down -v is executed
- **THEN** named volumes are removed while mounted data persists
