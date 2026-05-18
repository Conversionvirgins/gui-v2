/*
** Campervan System Overview
** Shows battery, solar, and load data in a clean layout.
*/

import QtQuick
import Victron.VenusOS

Page {
	id: root

	readonly property var bat: Global.system ? Global.system.battery : null
	readonly property var sol: Global.system ? Global.system.solar : null
	readonly property var acl: Global.system ? Global.system.load.ac : null

	GradientListView {
		model: VisibleItemModel {

			SettingsListHeader {
				text: "Battery"
			}

			ListText {
				text: "State of Charge"
				secondaryText: root.bat && !isNaN(root.bat.stateOfCharge)
					? Math.round(root.bat.stateOfCharge) + "%"
					: "--"
			}

			ListText {
				text: "Voltage"
				secondaryText: root.bat && !isNaN(root.bat.voltage)
					? root.bat.voltage.toFixed(2) + "V"
					: "--"
			}

			ListText {
				text: "Current"
				secondaryText: root.bat && !isNaN(root.bat.current)
					? root.bat.current.toFixed(1) + "A"
					: "--"
			}

			ListText {
				text: "Power"
				secondaryText: root.bat && !isNaN(root.bat.power)
					? Math.round(root.bat.power) + "W"
					: "--"
			}

			ListText {
				text: "Temperature"
				secondaryText: root.bat && !isNaN(root.bat.temperature)
					? root.bat.temperature.toFixed(1) + "°C"
					: "--"
			}

			ListText {
				text: "Status"
				secondaryText: {
					if (!root.bat) return "--"
					switch(root.bat.mode) {
						case VenusOS.Battery_Mode_Idle: return "Idle"
						case VenusOS.Battery_Mode_Charging: return "Charging"
						case VenusOS.Battery_Mode_Discharging: return "Discharging"
						default: return "--"
					}
				}
			}

			SettingsListHeader {
				text: "Solar"
			}

			ListText {
				text: "Solar Power"
				secondaryText: root.sol && !isNaN(root.sol.power)
					? Math.round(root.sol.power) + "W"
					: "--"
			}

			SettingsListHeader {
				text: "AC"
			}

			ListText {
				text: "AC Loads"
				secondaryText: root.acl && !isNaN(root.acl.power)
					? Math.round(root.acl.power) + "W"
					: "--"
			}
		}
	}
}
