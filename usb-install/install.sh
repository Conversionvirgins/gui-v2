#!/bin/sh
# Conversion mod installer for Cerbo GX
# Usage: Plug USB into Cerbo, SSH in, then run this script from the USB mount.

GUI_DIR="/opt/victronenergy/gui-v2"
BACKUP_DIR="/data/custom/gui-v2-backup"
USB_DIR="$(dirname "$0")"

echo "=== Conversion Mod Installer ==="
echo ""

# Create backup
if [ ! -d "$BACKUP_DIR" ]; then
    echo "Backing up original files to $BACKUP_DIR ..."
    mkdir -p "$BACKUP_DIR/pages/settings"
    cp "$GUI_DIR/Main.qml" "$BACKUP_DIR/Main.qml"
    cp "$GUI_DIR/pages/SettingsPage.qml" "$BACKUP_DIR/pages/SettingsPage.qml"
    echo "Backup complete."
else
    echo "Backup already exists at $BACKUP_DIR, skipping."
fi

echo ""
echo "Installing modified files..."

# Copy modified files
cp "$USB_DIR/Main.qml" "$GUI_DIR/Main.qml"
cp "$USB_DIR/pages/SettingsPage.qml" "$GUI_DIR/pages/SettingsPage.qml"

# Copy new files
cp "$USB_DIR/pages/settings/PageSettingsConversion.qml" "$GUI_DIR/pages/settings/"
cp "$USB_DIR/pages/settings/PageSettingsConversionBackground.qml" "$GUI_DIR/pages/settings/"

# Create custom assets directory
mkdir -p /data/custom

echo "Files installed."
echo ""
echo "Restarting GUI..."
svc -t /service/gui

echo ""
echo "Done! The display will reload in a moment."
echo "To revert: run the restore.sh script from this USB."
