#!/bin/bash
# Deploy Conversion Virgins GUI customizations to a Cerbo GX
# Usage: ./deploy-to-cerbo.sh <CERBO_IP> [PASSWORD]
#
# This script:
# 1. Builds the WASM (if not already built)
# 2. Deploys WASM to the Cerbo (web/remote console)
# 3. Deploys QML files for local display
# 4. Registers new types in qmldir
# 5. Restarts the GUI

set -e

CERBO_IP="${1:-192.168.86.197}"
PASSWORD="${2:-Lauren1602}"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR="$SCRIPT_DIR/.."

echo "=== Conversion Virgins GUI Deployment ==="
echo "Target: $CERBO_IP"
echo ""

# Check if WASM is built
if [ ! -d "$BASE_DIR/build-wasm_files_to_copy" ]; then
    echo "WASM not built. Building now..."
    cd "$BASE_DIR"
    bash scripts/build-wasm.sh
fi

echo ""
echo "=== Making filesystem writable ==="
sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no root@$CERBO_IP '/opt/victronenergy/swupdate-scripts/remount-rw.sh'

echo ""
echo "=== Deploying WASM (web/remote console) ==="
sshpass -p "$PASSWORD" scp -o StrictHostKeyChecking=no -r "$BASE_DIR/build-wasm_files_to_copy/wasm/"* root@$CERBO_IP:/var/www/venus/gui-v2/

echo ""
echo "=== Deploying QML files (local display) ==="
QML_DIR="/opt/victronenergy/gui-v2/Victron/VenusOS"

# Deploy VirtualSwitchesPage
sshpass -p "$PASSWORD" scp -o StrictHostKeyChecking=no "$BASE_DIR/pages/VirtualSwitchesPage.qml" root@$CERBO_IP:$QML_DIR/pages/

# Deploy modified SwipePageModel
sshpass -p "$PASSWORD" scp -o StrictHostKeyChecking=no "$BASE_DIR/components/SwipePageModel.qml" root@$CERBO_IP:$QML_DIR/components/

# Register VirtualSwitchesPage in qmldir (if not already there)
sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no root@$CERBO_IP "grep -q VirtualSwitchesPage $QML_DIR/qmldir || echo 'VirtualSwitchesPage 2.0 pages/VirtualSwitchesPage.qml' >> $QML_DIR/qmldir"

echo ""
echo "=== Restarting services ==="
sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no root@$CERBO_IP 'svc -t /service/start-gui; svc -t /service/vrmlogger'

echo ""
echo "=== Deployment complete! ==="
echo "Web console: refresh browser with Ctrl+Shift+R"
echo "Local display: will restart automatically"
