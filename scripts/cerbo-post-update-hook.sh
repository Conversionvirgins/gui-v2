#!/bin/sh
# Post-firmware-update hook for Cerbo GX
# Place this at: /data/custom/post-update.sh
# It will be called after a firmware update to restore customizations.
#
# To install on Cerbo:
#   scp scripts/cerbo-post-update-hook.sh root@CERBO_IP:/data/custom/post-update.sh
#   ssh root@CERBO_IP 'chmod +x /data/custom/post-update.sh'
#
# NOTE: This restores the WASM from a backup on the data partition.
# You must first deploy the WASM backup:
#   ssh root@CERBO_IP 'mkdir -p /data/custom/gui-v2-wasm-backup'
#   scp -r build-wasm_files_to_copy/wasm/* root@CERBO_IP:/data/custom/gui-v2-wasm-backup/

BACKUP_DIR="/data/custom/gui-v2-wasm-backup"
WASM_DIR="/var/www/venus/gui-v2"
QML_DIR="/opt/victronenergy/gui-v2/Victron/VenusOS"

echo "=== Conversion Virgins: Restoring GUI customizations ==="

# Make filesystem writable
/opt/victronenergy/swupdate-scripts/remount-rw.sh

# Restore WASM
if [ -d "$BACKUP_DIR" ]; then
    echo "Restoring WASM files..."
    cp -r "$BACKUP_DIR/"* "$WASM_DIR/"
    echo "WASM restored."
else
    echo "WARNING: No WASM backup found at $BACKUP_DIR"
fi

# Register VirtualSwitchesPage in qmldir
if [ -f "$QML_DIR/qmldir" ]; then
    grep -q VirtualSwitchesPage "$QML_DIR/qmldir" || echo "VirtualSwitchesPage 2.0 pages/VirtualSwitchesPage.qml" >> "$QML_DIR/qmldir"
fi

# Restart services
svc -t /service/start-gui
svc -t /service/vrmlogger

echo "=== Restoration complete ==="
