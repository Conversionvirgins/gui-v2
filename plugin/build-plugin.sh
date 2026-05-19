#!/bin/sh
cd /data/apps/enabled/conversion/gui-v2

echo '<RCC><qresource prefix="/conversion"><file>ConversionSettings.qml</file></qresource></RCC>' > conversion.qrc

/usr/libexec/rcc -binary -compress-algo zlib -o conversion.rcc conversion.qrc

python3 << 'EOF'
import base64, json
with open('conversion.rcc','rb') as f:
    r = base64.b64encode(f.read()).decode()
d = {
    'name': 'conversion',
    'version': '1.0',
    'minRequiredVersion': '',
    'maxRequiredVersion': '',
    'translations': [],
    'integrations': [{'type': 1, 'url': 'qrc:/conversion/ConversionSettings.qml'}],
    'resource': r
}
with open('conversion.json','w') as f:
    json.dump(d, f, indent=4)
print('Plugin JSON built successfully')
EOF

echo "Restarting GUI..."
svc -t /service/start-gui
echo "Done!"
