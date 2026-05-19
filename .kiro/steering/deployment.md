---
inclusion: manual
---

# Conversion Virgins GUI-v2 Deployment Guide

## Architecture Overview

The Cerbo GX has two GUI paths:
- **Local display**: Loads from compiled binary + QML files on disk at `/opt/victronenergy/gui-v2/Victron/VenusOS/`
- **Web/Remote Console (WASM)**: Loads from compiled WebAssembly at `/var/www/venus/gui-v2/`

Firmware updates will overwrite BOTH. To persist customizations, we rebuild and redeploy after updates.

## Infrastructure

| System | IP | User | Password | Purpose |
|--------|-----|------|----------|---------|
| Proxmox Host | 192.168.86.233 | root | - | VM host |
| Ubuntu Build VM (106) | 192.168.86.232 | victron | Lauren1602 | WASM builds |
| Main Cerbo (einstein) | 192.168.86.197 | root | Lauren1602 | Production with screen |
| Test Cerbo | 192.168.86.166 | root | Lauren1602 | Testing (no screen) |

## Build Server Setup

- VM 106 on Proxmox (Ubuntu 24.04)
- Repo at: `/home/victron/gui-v2`
- Qt 6.8.3 WASM tools at: `/opt/venus/build-gx-hostedtoolcache/`
- SSH key auth configured from Windows machine

## How to Build and Deploy WASM

### 1. SSH into build server
```bash
ssh victron@192.168.86.232
```

### 2. Pull latest changes
```bash
cd /home/victron/gui-v2
git fetch conversionvirgins
git checkout feature/virtual-switches-page
git pull conversionvirgins feature/virtual-switches-page
git submodule update --init
```

### 3. Build WASM
```bash
cd /home/victron/gui-v2
rm -rf build-wasm
bash scripts/build-wasm.sh
```
Build takes ~6 minutes.

### 4. Deploy to Cerbo
```bash
# For test Cerbo (166):
sshpass -p 'Lauren1602' ssh -o StrictHostKeyChecking=no root@192.168.86.166 '/opt/victronenergy/swupdate-scripts/remount-rw.sh'
sshpass -p 'Lauren1602' scp -o StrictHostKeyChecking=no -r /home/victron/gui-v2/build-wasm_files_to_copy/wasm/* root@192.168.86.166:/var/www/venus/gui-v2/
sshpass -p 'Lauren1602' ssh -o StrictHostKeyChecking=no root@192.168.86.166 'svc -t /service/vrmlogger'

# For main Cerbo (197):
sshpass -p 'Lauren1602' ssh -o StrictHostKeyChecking=no root@192.168.86.197 '/opt/victronenergy/swupdate-scripts/remount-rw.sh'
sshpass -p 'Lauren1602' scp -o StrictHostKeyChecking=no -r /home/victron/gui-v2/build-wasm_files_to_copy/wasm/* root@192.168.86.197:/var/www/venus/gui-v2/
sshpass -p 'Lauren1602' ssh -o StrictHostKeyChecking=no root@192.168.86.197 'svc -t /service/vrmlogger'
```

### 5. Deploy QML to local display (main Cerbo only)
The local display also needs the QML files + qmldir entry:
```bash
sshpass -p 'Lauren1602' ssh root@192.168.86.197 '/opt/victronenergy/swupdate-scripts/remount-rw.sh'

# Add VirtualSwitchesPage to qmldir (only needed once, or after firmware update):
sshpass -p 'Lauren1602' ssh root@192.168.86.197 'grep -q VirtualSwitchesPage /opt/victronenergy/gui-v2/Victron/VenusOS/qmldir || echo "VirtualSwitchesPage 2.0 pages/VirtualSwitchesPage.qml" >> /opt/victronenergy/gui-v2/Victron/VenusOS/qmldir'

# Copy the page file:
sshpass -p 'Lauren1602' scp /tmp/VirtualSwitchesPage.qml root@192.168.86.197:/opt/victronenergy/gui-v2/Victron/VenusOS/pages/

# Copy modified SwipePageModel:
sshpass -p 'Lauren1602' scp /tmp/SwipePageModel.qml root@192.168.86.197:/opt/victronenergy/gui-v2/Victron/VenusOS/components/

# Restart GUI:
sshpass -p 'Lauren1602' ssh root@192.168.86.197 'svc -t /service/start-gui'
```

## After a Firmware Update

When Victron pushes a firmware update, it will overwrite the WASM and QML files. To restore:

1. SSH into build server (192.168.86.232)
2. Check if upstream has new changes: `git fetch origin && git log origin/main --oneline -5`
3. If needed, rebase our branch: `git rebase origin/main`
4. Rebuild WASM: `bash scripts/build-wasm.sh`
5. Redeploy to Cerbo(s) using the commands above

## Key Files

| File | Purpose |
|------|---------|
| `pages/VirtualSwitchesPage.qml` | The switches page UI |
| `components/SwipePageModel.qml` | Navigation model (adds switches to swipe pages) |
| `cmake/ModuleVenus_Sources.cmake` | Build system registration |
| `Main.qml` | Custom background support |
| `pages/SettingsPage.qml` | Custom settings menu entries |
| `pages/settings/PageSettingsConversion.qml` | Conversion background settings |
| `plugin/` | GUI plugin for Cerbo (loaded via /data/apps/) |

## Plugin System (survives firmware updates)

The plugin at `/data/apps/enabled/conversion/gui-v2/` survives firmware updates because it's on the data partition. It provides:
- Custom settings page (ConversionSettings.qml)
- Loaded automatically by the GUI binary

To update the plugin:
```bash
scp plugin/ConversionSettings.qml root@CERBO_IP:/data/apps/enabled/conversion/gui-v2/
```

## Notes

- The Cerbo filesystem is read-only by default. Always run `remount-rw.sh` before writing.
- The WASM build is what the web/remote console uses.
- The local display reads QML from `/opt/victronenergy/gui-v2/Victron/VenusOS/` but types must be registered in the `qmldir` file.
- Files uploaded from Windows MUST be UTF-8 with Unix line endings (LF, not CRLF). Use the build server for file transfers.
- The `octopus/` directory contains API keys and is excluded from git pushes.
