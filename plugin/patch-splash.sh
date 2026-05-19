#!/bin/sh
SPLASH="/opt/victronenergy/gui-v2/Victron/VenusOS/components/SplashView.qml"
LINE=$(grep -n 'source: "qrc:/images/splash-logo-text.svg"' "$SPLASH" | head -n 1 | cut -d: -f1)

if [ -z "$LINE" ]; then
    echo "ERROR: Could not find splash logo text line"
    exit 1
fi

# Insert BMS logo after the logo text source line
NEXT=$((LINE + 1))
sed -i "${NEXT}i\\
\\
\t\t// BMS Technologies branding on splash\\
\t\tImage {\\
\t\t\tsource: \"file:///opt/victronenergy/gui-v2/Victron/VenusOS/images/bms-technologies-logo.png\"\\
\t\t\tanchors.bottom: parent.bottom\\
\t\t\tanchors.bottomMargin: 5\\
\t\t\tanchors.horizontalCenter: parent.horizontalCenter\\
\t\t\theight: 40\\
\t\t\tfillMode: Image.PreserveAspectFit\\
\t\t}" "$SPLASH"

echo "Splash patched"
grep -c 'BMS Technologies' "$SPLASH"
