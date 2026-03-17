## ADDED Requirements

### Requirement: Environment variable configuration

The system SHALL accept server settings through environment variables, allowing users to configure the DST server without directly editing files. Environment variables MUST map to corresponding configuration file settings.

#### Scenario: Server name via environment variable
- **WHEN** GAME_SERVER_NAME environment variable is set
- **THEN** it populates the server name in cluster.ini

#### Scenario: Server description via environment variable
- **WHEN** GAME_SERVER_DESC environment variable is set
- **THEN** it updates the server description

#### Scenario: World generation seed configuration
- **WHEN** WORLD_GEN_SEED environment variable is set
- **THEN** worldgenoverride.lua is updated with the specified seed

### Requirement: Cluster token configuration

The system SHALL allow setting the cluster token through environment variable for authentication with Klei servers. The cluster token MUST be securely handled and not exposed in logs.

#### Scenario: Set cluster token from environment
- **WHEN** CLUSTER_TOKEN environment variable is provided
- **THEN** cluster.ini is updated with the token

#### Scenario: Token not exposed in logs
- **WHEN** startup scripts execute with cluster token set
- **THEN** token value does not appear in container logs

### Requirement: Port configuration

The system SHALL allow configuring game server ports through environment variables to support custom port mappings and multi-server deployments on same host.

#### Scenario: Override master server port
- **WHEN** MASTER_PORT environment variable is set
- **THEN** master world listens on specified port instead of default

#### Scenario: Override caves server port
- **WHEN** CAVES_PORT environment variable is set
- **THEN** caves world listens on specified port

### Requirement: Configuration file injection

The system SHALL support injecting complete configuration files from volumes, allowing advanced users to provide pre-configured modoverrides.lua, worldgenoverride.lua, or other config files.

#### Scenario: Mount custom configuration file
- **WHEN** custom modoverrides.lua is mounted to container
- **THEN** custom mods are used instead of defaults

#### Scenario: Mount custom world generation
- **WHEN** custom worldgenoverride.lua is mounted
- **THEN** world generation uses custom settings

### Requirement: Mod installation from environment

The system SHALL support specifying mods to install via environment variables that reference mod IDs or paths.

#### Scenario: Install mods from mod IDs
- **WHEN** MOD_IDS environment variable contains space-separated mod IDs
- **THEN** specified mods are installed and enabled

#### Scenario: Priority mods configuration
- **WHEN** PRIORITY_MODS environment variable is set
- **THEN** modoverrides.lua is generated with specified mod priority order

### Requirement: Game mode selection

The system SHALL allow selecting game mode (Survival, Endless, etc.) and campaign through environment variables.

#### Scenario: Set survival mode
- **WHEN** GAME_MODE environment variable is set to "survival"
- **THEN** cluster.ini configures server for survival mode

#### Scenario: Enable PvP mode
- **WHEN** PVP_ENABLED environment variable is "true"
- **THEN** cluster.ini enables PvP

### Requirement: Admin and whitelist configuration

The system SHALL support loading admin list and whitelist from environment or volume-mounted files.

#### Scenario: Add admin via environment
- **WHEN** ADMIN_LIST environment variable contains Steam IDs
- **THEN** adminlist.txt is populated with specified admins

#### Scenario: Load whitelist from mounted file
- **WHEN** whitelist.txt is mounted or specified in CONFIG_PATH
- **THEN** server enforces specified whitelist
