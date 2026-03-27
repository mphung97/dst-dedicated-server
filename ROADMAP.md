# Roadmap

## Overview
This document outlines the planned enhancements and future development directions for the Don't Starve Together Dedicated Server project.

---

## In Progress

### [ ] Multi-Cluster Support
- Add support for running multiple game clusters from a single deployment
- Implement cluster selection via environment variables
- Create isolated data directories per cluster

### [ ] Automated Backup System
- Implement scheduled world save backups
- Add backup retention policy (configurable number of snapshots)
- Support for backup compression and offsite storage options

---

## Planned

### [ ] Advanced Mod Management
- Mod configuration TUI for easier mod selection and configuration

---

## Considered

### [ ] Discord/Telegram Bot Integration
- Server status notifications
- Player join/leave alerts
- Remote management commands

---

## Completed

- [x] Docker containerization
- [x] Dual-shard (Master + Caves) support
- [x] Mod support system
- [x] Admin/Whitelist/Blocklist configuration
- [x] Docker Compose orchestration
