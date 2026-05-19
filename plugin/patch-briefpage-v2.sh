#!/bin/sh
BRIEF="/opt/victronenergy/gui-v2/Victron/VenusOS/pages/BriefPage.qml"
LINE=$(grep -n 'GaugeModel {' "$BRIEF" | head -n 1 | cut -d: -f1)

if [ -z "$LINE" ]; then
    echo "ERROR: Could not find GaugeModel"
    exit 1
fi

sed -i "${LINE}i\\
\\
\t// BMS Technologies branding\\
\tVeQuickItem {\\
\t\tid: _logoEnabled\\
\t\tuid: !!Global.systemSettings ? Global.systemSettings.serviceUid + \"/Settings/Gui/Conversion/LogoEnabled\" : \"\"\\
\t}\\
\tImage {\\
\t\tsource: \"file:///opt/victronenergy/gui-v2/Victron/VenusOS/images/bms-technologies-logo.png\"\\
\t\tanchors.top: parent.top\\
\t\tanchors.topMargin: 8\\
\t\tanchors.right: parent.right\\
\t\tanchors.rightMargin: 120\\
\t\theight: 28\\
\t\tfillMode: Image.PreserveAspectFit\\
\t\topacity: root._gaugeLabelOpacity\\
\t\tvisible: root.state !== \"panelOpened\" && _logoEnabled.value === 1\\
\t}" "$BRIEF"

echo "Done"
grep -c 'LogoEnabled' "$BRIEF"
