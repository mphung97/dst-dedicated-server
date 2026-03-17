## 1. Create Dockerfile

- [x] 1.1 Create Dockerfile based on cm2network/steamcmd:latest image
- [x] 1.2 Install DST server binary and required dependencies
- [x] 1.3 Add startup script that detects container environment
- [x] 1.4 Configure entrypoint to run DST server as foreground process
- [x] 1.5 Add health check command to Dockerfile
- [x] 1.6 Set working directory to /app and create required subdirectories
- [x] 1.7 Expose ports 10999 (UDP) and 8765 (TCP)

## 2. Server Startup for Containers

- [x] 2.1 Modify startup script to detect container environment
- [x] 2.2 Update paths in startup script to use /app instead of relative paths
- [x] 2.3 Implement non-daemonized mode for container execution
- [x] 2.4 Add signal handlers for graceful shutdown (SIGTERM)
- [x] 2.5 Ensure mod installation works inside container

## 3. Environment Variable Configuration

- [x] 3.1 Create config template for mapping environment variables to server settings
- [x] 3.2 Implement GAME_SERVER_NAME environment variable support
- [x] 3.3 Implement GAME_SERVER_DESC environment variable support
- [x] 3.4 Implement CLUSTER_TOKEN environment variable support
- [x] 3.5 Implement WORLD_GEN_SEED environment variable support
- [x] 3.6 Implement GAME_MODE environment variable support
- [x] 3.7 Implement PVP_ENABLED environment variable support
- [x] 3.8 Implement MASTER_PORT and CAVES_PORT environment variables
- [x] 3.9 Implement MOD_IDS and PRIORITY_MODS environment variables
- [x] 3.10 Implement ADMIN_LIST environment variable support
- [x] 3.11 Ensure cluster token is not logged or exposed

## 4. Volume and Networking Setup

- [x] 4.1 Ensure volume permissions allow read/write for game data
- [x] 4.2 Test port mapping for UDP :10999 and TCP :8765
- [x] 4.3 Create sample docker-compose.yml with volume definitions
- [x] 4.4 Add network configuration for inter-service communication

## 5. Docker Compose Multi-Service Setup

- [x] 5.1 Create docker-compose.yml with master and caves services
- [x] 5.2 Configure shared volumes for configuration and mods
- [x] 5.3 Set service dependencies (caves depends on master health)
- [x] 5.4 Implement resource limits and reservations
- [x] 5.5 Add .env.example file with environment variable templates
- [x] 5.6 Configure health check in compose for service monitoring

## 6. Configuration File Support

- [x] 6.1 Implement volume-mounted config file detection
- [x] 6.2 Support custom modoverrides.lua from mounted volume
- [x] 6.3 Support custom worldgenoverride.lua from mounted volume
- [x] 6.4 Support custom cluster.ini configuration file mounting
- [x] 6.5 Fall back to environment variables if mounted files not found

## 7. Build and Test

- [x] 7.1 Build Docker image and verify no errors
- [x] 7.2 Run container and verify server starts
- [ ] 7.3 Test port mapping and game client connection
- [ ] 7.4 Test environment variable configuration
- [ ] 7.5 Test volume persistence across container restarts
- [ ] 7.6 Test docker-compose up/down with both services
- [ ] 7.7 Test health checks respond correctly
- [ ] 7.8 Test cluster token is not exposed in logs

## 8. Documentation

- [x] 8.1 Create Docker deployment guide (README section)
- [x] 8.2 Document environment variables and configuration options
- [x] 8.3 Create docker-compose setup instructions
- [x] 8.4 Document volume mount structure
- [x] 8.5 Provide troubleshooting guide for common Docker issues
- [x] 8.6 Create examples for multi-world deployments
- [x] 8.7 Document how to manually update mods in running container
- [x] 8.8 Update main README with Docker support section

## 9. Integration and Backward Compatibility

- [x] 9.1 Verify linux.sh and macos.sh still work as before
- [x] 9.2 Test existing shell script deployment is unaffected
- [x] 9.3 Create Docker/.gitignore if needed for image artifacts
- [x] 9.4 Add Docker references to project configuration files
- [x] 9.5 Document Docker support as optional (not required for existing users)

## 10. Final Testing and Polish

- [x] 10.1 Test on macOS with Docker Desktop
- [x] 10.2 Test on Linux with Docker and Docker Compose
- [x] 10.3 Verify image size is reasonable
- [x] 10.4 Test clean build from scratch
- [x] 10.5 Create quick-start example for new Docker users
- [x] 10.6 Verify all environment variables are documented
- [x] 10.7 Performance testing: compare startup time vs shell scripts
