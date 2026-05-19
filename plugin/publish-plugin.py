#!/usr/bin/python3
"""
Publishes the conversion GUI plugin to MQTT so the WASM GUI v2 can load it.
Run this once after boot, or add to /data/rc.local for persistence.
"""

import json
import time
import paho.mqtt.client as mqtt

PORTAL_ID = open('/data/venus/unique-id').read().strip()
PLUGIN_NAME = 'conversion'
PLUGIN_JSON_PATH = '/data/apps/enabled/conversion/gui-v2/conversion.json'
BROKER = 'localhost'
PORT = 1883

def main():
    with open(PLUGIN_JSON_PATH) as f:
        plugin_data = f.read()

    client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
    client.connect(BROKER, PORT, 60)

    base = f'N/{PORTAL_ID}/platform/0/GuiCustomizations'

    # Publish the app list
    client.publish(
        f'{base}/Applist',
        json.dumps({'value': [PLUGIN_NAME]}),
        retain=True
    )

    # Publish the plugin info
    client.publish(
        f'{base}/Apps/{PLUGIN_NAME}/info',
        json.dumps({'value': plugin_data}),
        retain=True
    )

    client.loop(timeout=2.0)
    client.disconnect()
    print(f'Published plugin "{PLUGIN_NAME}" to MQTT')
    print(f'Portal ID: {PORTAL_ID}')

if __name__ == '__main__':
    main()
