# Design: Compose Build Order + Logging

**Date:** 2026-04-03
**Status:** Draft

## Context

The two-image split requires building `Dockerfile.base` before `Dockerfile.cluster`. Currently this is a manual two-step process. Additionally, Docker logs are unbounded and can fill disk over time.

## Changes

### Build Order
Add a `dst-base` service to `docker-compose.yml` that builds `Dockerfile.base` and tags it as `dst-dedicated:local`. The existing `dst-server` service depends on it. The base service uses `profiles: ["build"]` so it only runs during build, not during `docker-compose up`.

### Logging
Add `logging` block to `dst-server` service:
- Driver: `json-file`
- Max size: `10m` per file
- Max files: `3`
- Total cap: 30MB

## Files Modified
- `docker-compose.yml` — add `dst-base` service, add `logging` block to `dst-server`

## Build Flow After Change
```bash
docker compose build dst-base
docker compose up -d
```
Or single command:
```bash
docker compose --profile build build dst-base && docker compose up -d
```
