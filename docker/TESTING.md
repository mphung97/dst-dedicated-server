# Docker Testing & Troubleshooting

This guide covers testing Docker deployment and common issues.

## Quick Testing Checklist

After running `docker-compose up -d`, verify:

```bash
# 1. Check containers are running
docker-compose ps
# Expected: both master and caves showing "Up"

# 2. Check health status
docker-compose ps --format "table {{.Names}}\t{{.Status}}"
# Expected: "(healthy)" appearing in status after 40s

# 3. Verify ports are mapped
docker port dst-master
# Expected: 10999/udp mapped to host port
# Expected: 8765/tcp mapped to host port

# 4. Check logs for errors
docker-compose logs --tail 20 master
# Expected: no ERROR lines
```

## Port Testing

### Verify UDP Port (Game Port)

```bash
# Test from another machine (Linux/macOS)
nc -u -z -w1 <server-ip> 10999
echo $?  # 0 = success

# Or use a game client to connect to:
# <server-ip>:10999
```

### Verify TCP Port (Authentication Port)

```bash
# From another machine
nc -z -w1 <server-ip> 8765
echo $?  # 0 = success
```

### Port Forwarding Check (macOS/Linux)

```bash
# List Docker port mappings
docker ps --format "table {{.Names}}\t{{.Ports}}"

# Test local port
lsof -i :10999  # Should show docker or java process

# Test from localhost
telnet localhost 8765  # Should connect
```

## Environment Variable Testing

### Test Configuration Loading

```bash
# Check if config files were created
docker exec dst-master ls -la /app/config/

# Verify environment variables are being read
docker exec dst-master cat /app/config/cluster.ini

# Check specific setting
docker exec dst-master grep "cluster_name" /app/config/cluster.ini
```

### Test Environment Variable Override

```bash
# Add a temporary override
docker-compose exec master bash << 'EOF'
echo "CLUSTER_TOKEN=${CLUSTER_TOKEN}" | head -c 20
echo "..."  # Show it's set but not full value
EOF
```

## Volume Persistence Testing

### Create Test File

```bash
# The test: verify data persists after restart

# 1. Get container ID
docker-compose ps master --quiet

# 2. Create test file in volume
docker exec dst-master touch /app/config/test-file-$(date +%s).txt

# 3. List files
docker exec dst-master ls -la /app/config/test-*.txt
# Note the file names for comparison

# 4. Restart container
docker-compose restart master

# 5. Check file still exists
docker exec dst-master ls -la /app/config/test-*.txt
# Should still show your test files - SUCCESS

# 6. Cleanup
docker exec dst-master rm /app/config/test-*.txt
```

### Test Volume Backup

```bash
# Backup volume data
docker run --rm \
  -v dst-master-data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/master-backup.tar.gz -C /data .

ls -lh ./master-backup.tar.gz
```

## Compose Service Testing

### Test Service Dependencies

```bash
# Stop master (caves should still run but won't connect)
docker-compose stop master

# Check status
docker-compose ps
# caves might exit or show unhealthy

# Restart master
docker-compose start master

# Wait 40s for health check
sleep 45

# Verify both are healthy
docker-compose ps
```

### Test Health Checks

```bash
# Get health status
docker inspect dst-master \
  | jq -r '.[0].State.Health.Status'
# Output: "healthy" or "unhealthy"

# See health check history
docker inspect dst-master \
  | jq -r '.[0].State.Health.Log[] | "\(.End): \(.ExitCode)"'
```

### Test Resource Limits

```bash
# Check Docker stats
docker stats --no-stream dst-master dst-caves

# View memory/CPU usage
docker stats --format "table {{.Container}}\t{{.MemUsage}}\t{{.CPUPerc}}"
```

## Cluster Token Testing

### Verify Token Security

```bash
# Check token is NOT in logs
docker-compose logs | grep -i "token" | grep -v "cluster_token"
# Should return nothing or only mention "cluster_token.txt"

# Verify token file permissions
docker exec dst-master ls -la /app/config/cluster_token.txt
# Should show: -rw------- (600 permissions)

# Check token value is not exposed
docker exec dst-master cat /app/config/cluster_token.txt | wc -c
# Should show character count only, not print value
```

## Common Issues & Solutions

### "connection refused" on port

**Problem:** `docker-compose logs` shows the port isn't listening

**Solutions:**
1. Check if container is running:
   ```bash
   docker-compose ps master  # Should show "Up"
   ```

2. Check if port is exposed:
   ```bash
   docker port dst-master | grep 10999
   ```

3. Check firewall:
   ```bash
   # macOS
   pfctl -sr | grep 10999
   
   # Linux
   sudo iptables -L INPUT | grep 10999
   ```

### "Caves won't connect to Master"

**Problem:** Both containers running but not synchronized

**Solutions:**
1. Ensure Master is healthy:
   ```bash
   docker inspect dst-master | jq '.[0].State.Health.Status'
   ```

2. Check both have same CLUSTER_TOKEN:
   ```bash
   docker exec dst-master wc -c < /app/config/cluster_token.txt
   docker exec dst-caves wc -c < /app/config/cluster_token.txt
   # Should match
   ```

3. Restart both in order:
   ```bash
   docker-compose restart master caves
   sleep 45  # Wait for health check
   docker-compose ps
   ```

### Container exits immediately

**Problem:** Container starts but stops right away

**Solution:** Check logs:
```bash
docker-compose logs master | tail -50
```

Common causes:
- CLUSTER_TOKEN not set: Set in .env
- Missing binary: Try `docker-compose build --no-cache master`
- Permission issue: Try `docker-compose down -v && docker-compose up -d`

### "No such file or directory" errors

**Problem:** Script or file not found in container

**Solution:**
```bash
# Verify files are copied
docker exec dst-master ls -la /app/

# Check Dockerfile COPY statements ran
docker history dst-server:latest | grep COPY

# Rebuild image
docker-compose build --no-cache master
```

## Performance Testing

### Check Startup Time

```bash
# Time container startup
time docker-compose up -d master

# Check when service becomes healthy
docker-compose ps --format "table {{.Names}}\t{{.Status}}"
# Wait ~40-60 seconds for "(healthy)"
```

### Monitor Resource Usage

```bash
# Real-time stats
watch 'docker stats --no-stream'

# Memory baseline
docker exec dst-master ps aux | grep dontstarve

# CPU cores available
docker exec dst-master nproc
```

### Compare Shell Script Performance

```bash
# If running both methods for comparison:

# Docker startup
time docker-compose up -d  # Should be <5s

# Traditional startup
time ./linux.sh            # Varies by system
```

## Logging & Debugging

### Enable Verbose Logging

```bash
# See all compose operations
docker-compose -v debug up -d master

# Follow logs with timestamps
docker-compose logs -f --timestamps master

# View last N lines
docker-compose logs --tail 100 master
```

### Export Logs

```bash
# Save all logs to file
docker-compose logs > dst-logs-$(date +%Y%m%d).txt

# Save specific service logs
docker-compose logs master > master-logs.txt
```

### Container Shell Access

```bash
# Debug inside container
docker exec -it dst-master /bin/bash

# Inside container, check:
# - /app/config/ (mounted config files)
# - /app/server/bin64/ (DST binary location)
# - /app/game/ (world data)
# - /app/mods/ (mod files)
```

## Validation Commands

Quick reference for validation:

```bash
# Full system check
bash docker/build-and-test.sh

# Services running and healthy
docker-compose ps

# Configuration loaded
docker exec dst-master cat /app/config/cluster.ini

# Ports open
docker port dst-master

# No errors in logs
docker-compose logs | grep ERROR

# Volumes mounted correctly
docker inspect dst-master | jq '.[0].Mounts'
```

## Getting Help

If issues persist:

1. Check [DOCKER_GUIDE.md](DOCKER_GUIDE.md) troubleshooting section
2. Review logs: `docker-compose logs`
3. Check Docker health: `docker ps --all`
4. Verify configuration: `cat .env`
5. Try rebuild: `docker-compose build --no-cache && docker-compose up -d`
