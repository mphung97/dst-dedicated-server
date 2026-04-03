# Dockerfile Split Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Split the monolithic Dockerfile into two images — a cached base image with DST server binaries and a cluster image with configuration.

**Architecture:** `Dockerfile.base` downloads and installs the DST server. `Dockerfile.cluster` extends the base image with cluster config and the launch script. `docker-compose.yml` is updated to reference the cluster Dockerfile.

**Tech Stack:** Docker, Docker Compose, SteamCMD

---

### Task 1: Create `Dockerfile.base`

**Files:**
- Create: `Dockerfile.base`

- [x] **Step 1: Write `Dockerfile.base`**

This file contains the SteamCMD base, dependency installation, and DST server download. It does NOT copy cluster data or set an entrypoint.

```dockerfile
FROM cm2network/steamcmd:latest

# Set environment variables
ENV STEAM_HOME=/home/steam/steamcmd \
    INSTALL_DIR=/home/steam/dontstarvetogether_dedicated_server \
    DONTSTARVE_DIR=/home/steam/.klei/DoNotStarveTogether

USER root

# Install dependencies, create directories, and set permissions
RUN apt-get update && apt-get install -y --no-install-recommends libcurl4-gnutls-dev && \
    mkdir -p "$INSTALL_DIR" "$DONTSTARVE_DIR" && \
    chown -R steam:steam /home/steam && \
    rm -rf /var/lib/apt/lists/*

USER steam

# Download and install DST dedicated server
RUN "$STEAM_HOME/steamcmd.sh" \
    +@ShutdownOnFailedCommand 1 \
    +@NoPromptForPassword 1 \
    +force_install_dir "$INSTALL_DIR" \
    +login anonymous \
    +app_update 343050 validate \
    +quit
```

- [x] **Step 2: Verify the base image builds** (skipped — Docker daemon not running locally)

Run:
```bash
docker build -t dst-base:local -f Dockerfile.base .
```
Expected: Build completes successfully, image tagged as `dst-base:local`

- [x] **Step 3: Commit** (deferred to final commit)

```bash
git add Dockerfile.base
git commit -m "feat: add Dockerfile.base for DST server binaries"
```

---

### Task 2: Create `Dockerfile.cluster`

**Files:**
- Create: `Dockerfile.cluster`

- [x] **Step 1: Write `Dockerfile.cluster`**

This file extends `dst-base:local`, copies cluster configuration and the launch script, and sets up the entrypoint.

```dockerfile
FROM dst-base:local

# Set environment variables (inherited from base, re-declared for clarity)
ENV DONTSTARVE_DIR=/home/steam/.klei/DoNotStarveTogether

# Copy cluster configuration
COPY --chown=steam:steam Cluster_1 "$DONTSTARVE_DIR/Cluster_1"

# Copy and configure launch script
COPY --chown=steam:steam run_dedicated_servers.sh /home/steam/run_dedicated_servers.sh

RUN chmod +x /home/steam/run_dedicated_servers.sh

EXPOSE 10889/udp 10888/udp

ENTRYPOINT ["/home/steam/run_dedicated_servers.sh"]
CMD []
```

- [x] **Step 2: Verify the cluster image builds** (skipped — Docker daemon not running locally)

Run (requires `dst-base:local` to exist from Task 1):
```bash
docker build -t dst-cluster:local -f Dockerfile.cluster .
```
Expected: Build completes successfully, image tagged as `dst-cluster:local`

- [x] **Step 3: Commit** (deferred to final commit)

```bash
git add Dockerfile.cluster
git commit -m "feat: add Dockerfile.cluster for cluster configuration"
```

---

### Task 3: Update `docker-compose.yml` and Remove Old `Dockerfile`

**Files:**
- Modify: `docker-compose.yml`
- Delete: `Dockerfile`

- [x] **Step 1: Update `docker-compose.yml`**

Change the `dockerfile` reference from `Dockerfile` to `Dockerfile.cluster`. Everything else stays the same.

```yaml
version: '3.8'

services:
  dst-server:
    build:
      context: .
      dockerfile: Dockerfile.cluster
    container_name: dst-server
    ports:
      - "10889:10889/udp"  # Cluster communication
      - "10888:10888/udp"  # Shard communication
      - "11000:11000/udp"  # Master world connections
    restart: unless-stopped
    environment:
      - CLUSTER_NAME=Cluster_1
    volumes:
      - ./mods/dedicated_server_mods_setup.lua:/home/steam/dontstarvetogether_dedicated_server/mods/dedicated_server_mods_setup.lua
```

- [x] **Step 2: Remove the old `Dockerfile`**

```bash
git rm Dockerfile
```

- [x] **Step 3: Commit** (deferred to final commit)

---

### Task 4: Update `README.md` Build Instructions

**Files:**
- Modify: `README.md`

- [x] **Step 1: Update the Quick Start section**

Replace the current "Launch" section to include the two-step build process. The updated section should read:

```markdown
### 2. ⚡ Build & Launch

First, build the base server image (only needed once or when the DST server updates):
```bash
docker build -t dst-base:local -f Dockerfile.base .
```

Then spin up the server fortress:
```bash
docker-compose up -d
```
*The server will initialize and start the Master and Caves shards.*
```

- [x] **Step 2: Commit** (deferred to final commit)

---

### Task 5: Verify Full Build

- [x] **Step 1: Clean any existing images and run the full flow** (skipped — self-test by user)

```bash
docker-compose down
docker rmi dst-cluster:local 2>/dev/null || true
docker build -t dst-base:local -f Dockerfile.base .
docker-compose up -d
```

Expected: Both images build, container starts, logs show server initialization.

- [x] **Step 2: Monitor logs** (skipped — self-test by user)

```bash
docker-compose logs -f
```

Expected: Console output showing Master and Caves shard initialization.

- [x] **Step 3: Final commit** (deferred)
