#!/bin/sh
# Restore original GUI files on Cerbo GX

GUI_DIR="/opt/victronenergy/gui-v2"
BACKUP_DIR="/data/custom/gui-v2-backup"

echo "=== Conversion Mod Restore ==="
echo ""

if [ ! -d "$BACKUP_DIR" ]; then
    echo "No backup found at $BACKUP_DIR. Cannot restore."
    exit 1
fi

echo "Restoring original files..."

cp "$BACKUP_DIR/Main.qml" "$GUI_DIR/Main.qml"
cp "$BACKUP_DIR/pages/SettingsPage.qml" "$GUI_DIR/pages/SettingsPage.qml"

# Remove added files
rm -f "$GUI_DIR/pages/settings/PageSettingsConversion.qml"
rm -f "$GUI_DIR/pages/settings/PageSettingsConversionBackground.qml"

echo "Files restored."
echo ""
echo "Restarting GUI..."
svc -t /service/gui

echo ""
echo "Done! Original GUI restored."
