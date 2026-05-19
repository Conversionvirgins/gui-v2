#!/bin/sh
BRIEF="/opt/victronenergy/gui-v2/Victron/VenusOS/pages/BriefPage.qml"

# Replace the current logo block with one that reads the toggle setting
sed -i '/\/\/ BMS Technologies branding/,/^        GaugeModel {/c\
\
        // BMS Technologies branding\
        Image {\
                source: "file:///opt/victronenergy/gui-v2/Victron/VenusOS/images/bms-technologies-logo.png"\
                anchors.top: parent.top\
                anchors.topMargin: 8\
                anchors.right: parent.right\
                anchors.rightMargin: 120\
                height: 28\
                fillMode: Image.PreserveAspectFit\
                opacity: root._gaugeLabelOpacity\
                visible: root.state !== "panelOpened" \&\& _logoEnabled.value === 1\
\
                VeQuickItem {\
                        id: _logoEnabled\
                        uid: !!Global.systemSettings ? Global.systemSettings.serviceUid + "/Settings/Gui/Conversion/LogoEnabled" : ""\
                }\
        }\
        GaugeModel {' "$BRIEF"

echo "Patched logo toggle"
grep -c 'logoEnabled\|LogoEnabled' "$BRIEF"
