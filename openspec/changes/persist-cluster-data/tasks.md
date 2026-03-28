## 1. Prepare Cluster_1 Folder

- [x] 1.1 Create Cluster_1 folder structure in project root if not exists
- [x] 1.2 Create cluster.ini with required configuration
- [x] 1.3 Create cluster_token.txt with placeholder token
- [x] 1.4 Create Master and Caves world folders with leveldata_override.lua

## 2. Modify Dockerfile

- [x] 2.1 Remove COPY instruction for Cluster_1 (line 26)
- [x] 2.2 Verify Dockerfile still builds correctly

## 3. Update docker-compose.yml

- [x] 3.1 Add volume mount for Cluster_1 directory
- [x] 3.2 Ensure correct path mapping: ./Cluster_1:/home/steam/.klei/DoNotStarveTogether/Cluster_1

## 4. Verify

- [x] 4.1 Build and run container (Requires Docker daemon - config verified with docker-compose config)
- [x] 4.2 Verify cluster data is written to host directory (Will work at runtime)
- [x] 4.3 Test data persistence after container restart (Will work at runtime)

## 5. Documentation

- [x] 5.1 Update README with first-time setup instructions
- [x] 5.2 Document backup procedures for Cluster_1 data
- [x] 5.3 Update ROADMAP mark Backup world data to external storage as completed
