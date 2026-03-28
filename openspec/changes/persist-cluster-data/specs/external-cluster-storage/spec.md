## ADDED Requirements

### Requirement: Cluster data persists outside container
The system SHALL store Cluster_1 game data in a directory mounted from the host, ensuring data survives container rebuilds and removals.

#### Scenario: Container rebuild preserves data
- **WHEN** the container is rebuilt with `docker-compose up --build`
- **THEN** all Cluster_1 data (world saves, player data, mods) remains intact on the host

#### Scenario: Container removal preserves data
- **WHEN** the container is removed with `docker-compose down`
- **THEN** all Cluster_1 data remains in the host directory

#### Scenario: First run creates cluster directory
- **WHEN** docker-compose is started for the first time with no Cluster_1 folder present
- **THEN** the container fails gracefully with instructions to create the cluster folder

### Requirement: Cluster folder is bind-mounted
The system SHALL mount the host's Cluster_1 folder to the container's `.klei/DoNotStarveTogether/Cluster_1` path.

#### Scenario: Volume mount configured correctly
- **WHEN** docker-compose.yml is configured with `./Cluster_1:/home/steam/.klei/DoNotStarveTogether/Cluster_1`
- **THEN** the container can read and write cluster data to the host directory
