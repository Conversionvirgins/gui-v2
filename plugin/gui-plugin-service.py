#!/usr/bin/python3
"""
D-Bus service that publishes GuiCustomizations for the WASM GUI v2 plugin loader.
Registers on com.victronenergy.platform as GuiCustomizations subtree.
"""

import sys
import os
import json
import dbus
import dbus.service
import dbus.mainloop.glib
from gi.repository import GLib

PLUGIN_JSON_PATH = '/data/apps/enabled/conversion/gui-v2/conversion.json'
PLUGIN_NAME = 'conversion'

class GuiCustomizationsService(dbus.service.Object):
    def __init__(self, bus):
        self.plugin_data = self._load_plugin()
        # Register on the system bus under a unique service name
        bus_name = dbus.service.BusName('com.victronenergy.guicustomizations', bus)
        super().__init__(bus_name, '/GuiCustomizations')

    def _load_plugin(self):
        with open(PLUGIN_JSON_PATH) as f:
            return f.read().strip()

    @dbus.service.method('com.victronenergy.BusItem', out_signature='v')
    def GetValue(self):
        return dbus.Dictionary({
            'Applist': dbus.Array([PLUGIN_NAME], signature='s'),
        }, signature='sv')

class ApplistItem(dbus.service.Object):
    def __init__(self, bus, bus_name):
        super().__init__(bus_name, '/GuiCustomizations/Applist')

    @dbus.service.method('com.victronenergy.BusItem', out_signature='v')
    def GetValue(self):
        return dbus.Array([PLUGIN_NAME], signature='s')

    @dbus.service.method('com.victronenergy.BusItem', out_signature='v')
    def GetText(self):
        return json.dumps([PLUGIN_NAME])

class PluginInfoItem(dbus.service.Object):
    def __init__(self, bus, bus_name, plugin_data):
        self.plugin_data = plugin_data
        super().__init__(bus_name, f'/GuiCustomizations/Apps/{PLUGIN_NAME}/info')

    @dbus.service.method('com.victronenergy.BusItem', out_signature='v')
    def GetValue(self):
        return self.plugin_data

    @dbus.service.method('com.victronenergy.BusItem', out_signature='v')
    def GetText(self):
        return self.plugin_data

def main():
    dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
    bus = dbus.SystemBus()

    with open(PLUGIN_JSON_PATH) as f:
        plugin_data = f.read().strip()

    bus_name = dbus.service.BusName('com.victronenergy.guicustomizations', bus)

    applist = ApplistItem(bus, bus_name)
    info = PluginInfoItem(bus, bus_name, plugin_data)

    print(f'GuiCustomizations D-Bus service running')
    print(f'Plugin: {PLUGIN_NAME}')

    loop = GLib.MainLoop()
    loop.run()

if __name__ == '__main__':
    main()
