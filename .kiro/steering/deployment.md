---
inclusion: manual
---

# Cerbo GX Deployment Guide

## Architecture Overview

The Victron Cerbo GX has two GUI paths:
- **Local display**: Runs a compiled ARM binary (`venus-gui-v2`) that loads QML from the filesystem at `/opt/victronenergy/gui-v2/Victron/VenusOS/`
- **Web/Remote Console (WASM)**: A WebAssembly build served from `/var/www/venus/gui-v2/` — this is what you see in the browser

Editing QML files on disk only affects the **local display**. To change the **web view**, you must rebuild the WASM binary.

## Infrastructure

| Component | IP | User | Password |
|-----------|-----|------|----------|
| Main Cerbo (with screen) | 192.168.86.197 | root | Lauren1602 |
| Test Cerbo (no screen) | 192.168.86.166 | root | Lauren1602 |
| Proxmox Host | 192.168.86.233 | root | (via web UI) |
| Ubuntu Build VM (VM 106) | 192.168.86.232 | victron | Lauren1602 |

## Build Server Setup

- Ubuntu 24.04 VM on Proxmox (VM ID 106, hostname "victron")
- Repo location: `/home/victron/gui-v2`
- Qt 6.8.3 WASM toolchain at `/opt/venus/build-gx-hostedtoolcache/`
- SSH key auth configured from Windows machine
- No GX (ARM) SDK installed — only WASM builds are possible from here

## How to Build and Deploy WASM

### From the build server (192.168.86.232):

```bash
cd /home/victron/gui-v2
git fetch conversionvirgins
git checkout feature/virtual-switches-page  # or whichever branch
git pull
bash scripts/build-wasm.sh
```

### Upload to a Cerbo manually:

```bash
# Make filesystem writable
sshpass -p 'Lauren1602' ssh -o StrictHostKeyChecking=no root@192.168.86.166 '/opt/victronenergy/swupdate-scripts/remount-rw.sh'

# Upload WASM files
sshpass -p 'Lauren1602' scp -o StrictHostKeyChecking=no -r /home/victron/gui-v2/build-wasm_files_to_copy/wasm/* root@192.168.86.166:/var/www/venus/gui-v2/

# Restart vrmlogger (makes changes visible in VRM portal)
sshpass -p 'Lauren1602' ssh -o StrictHostKeyChecking=no root@192.168.86.166 'svc -t /service/vrmlogger'
```

Replace `192.168.86.166` with `192.168.86.197` for the main Cerbo.

### From Kiro (automated via SSH):

```
ssh victron@192.168.86.232 "cd /home/victron/gui-v2 && bash scripts/build-wasm.sh 2>&1"
ssh victron@192.168.86.232 "sshpass -p 'Lauren1602' ssh -o StrictHostKeyChecking=no root@<CERBO_IP> '/opt/victronenergy/swupdate-scripts/remount-rw.sh' && sshpass -p 'Lauren1602' scp -o StrictHostKeyChecking=no -r /home/victron/gui-v2/build-wasm_files_to_copy/wasm/* root@<CERBO_IP>:/var/www/venus/gui-v2/ && sshpass -p 'Lauren1602' ssh -o StrictHostKeyChecking=no root@<CERBO_IP> 'svc -t /service/vrmlogger'"
```

## How to Deploy QML-only Changes (Local Display)

For changes that only affect the local screen (not web view):

1. File must be UTF-8, no BOM, Unix line endings (LF)
2. The QML type must be registered in `/opt/victronenergy/gui-v2/Victron/VenusOS/qmldir`
3. The filesystem must be remounted read-write first

```bash
# From build server to Cerbo:
sshpass -p 'Lauren1602' ssh root@<CERBO_IP> '/opt/victronenergy/swupdate-scripts/remount-rw.sh'
sshpass -p 'Lauren1602' scp file.qml root@<CERBO_IP>:/opt/victronenergy/gui-v2/Victron/VenusOS/pages/
sshpass -p 'Lauren1602' ssh root@<CERBO_IP> 'svc -t /service/start-gui'
```

## Adding a New QML Page to the Navigation

To add a new page to the main swipe navigation:

1. Create the page QML file (e.g., `pages/VirtualSwitchesPage.qml`)
2. Add it to `cmake/ModuleVenus_Sources.cmake`
3. Modify `components/SwipePageModel.qml` to include the page
4. Rebuild WASM and deploy

For the **local display** (filesystem-loaded QML), you also need to:
- Add the type to `/opt/victronenergy/gui-v2/Victron/VenusOS/qmldir`:
  ```
  VirtualSwitchesPage 2.0 pages/VirtualSwitchesPage.qml
  ```

## Important Notes

- The Cerbo firmware version matters. v1.3.3 uses `navButtonText`/`navButtonIcon`, newer versions use `title`/`iconSource`
- The main Cerbo is v3.80~9 (gui v1.3.3), test Cerbo is v3.73~1
- `remount-rw.sh` only persists while the SSH session is active or until reboot
- The WASM build takes ~6 minutes on the build server
- Always hard-refresh browser (Ctrl+Shift+R) after deploying WASM changes
- The conversion plugin at `/data/apps/enabled/conversion/gui-v2/` provides the custom settings page via the plugin system (separate from filesystem QML)

## Git Remotes on Build Server

```
origin    https://github.com/victronenergy/gui-v2.git (upstream)
conversionvirgins    https://github.com/Conversionvirgins/gui-v2.git (your fork)
```

## File Encoding (Windows → Linux)

When uploading QML files from Windows to the Cerbo:
- PowerShell's `>` operator creates UTF-16 files — **do not use it**
- Use `[System.IO.File]::WriteAllText()` with `UTF8Encoding($false)` for no BOM
- Replace `\r\n` with `\n` before writing
- Or use `scp` from the build server (Linux) which handles encoding correctly
