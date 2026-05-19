#!/bin/sh
# Patch BriefPage.qml to add BMS Technologies logo
BRIEF="/opt/victronenergy/gui-v2/Victron/VenusOS/pages/BriefPage.qml"
STOCK="${BRIEF}.stock"

# Restore from stock first
cp "$STOCK" "$BRIEF"

# Find the line number of "GaugeModel {"
LINE=$(grep -n 'GaugeModel {' "$BRIEF" | head -n 1 | cut -d: -f1)

if [ -z "$LINE" ]; then
    echo "ERROR: Could not find GaugeModel in BriefPage.qml"
    exit 1
fi

# Insert the logo block before GaugeModel
sed -i "${LINE}i\\
\\
\t// BMS Technologies branding\\
\tImage {\\
\t\tsource: \"qrc:/images/bms-technologies-logo.png\"\\
\t\tanchors.top: parent.top\\
\t\tanchors.topMargin: 8\\
\t\tanchors.right: parent.right\\
\t\tanchors.rightMargin: 120\\
\t\theight: 28\\
\t\tfillMode: Image.PreserveAspectFit\\
\t\topacity: root._gaugeLabelOpacity\\
\t\tvisible: root.state !== \"panelOpened\"\\
\t}" "$BRIEF"

echo "Patched BriefPage.qml successfully"
grep -c 'BMS Technologies' "$BRIEF"
