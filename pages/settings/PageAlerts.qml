/*
** Alerts Configuration
** Configure battery and price alert thresholds.
*/

import QtQuick
import Victron.VenusOS

Page {
	id: root

	VeQuickItem {
		id: battLowAlert
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/OctopusBattLowAlert"
	}
	VeQuickItem {
		id: cheapPriceAlert
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/OctopusCheapPriceAlert"
	}
	VeQuickItem {
		id: lastAlert
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/OctopusLastAlert"
	}

	GradientListView {
		model: VisibleItemModel {

			SettingsListHeader {
				text: "Battery Alerts"
			}

			ListText {
				text: "Low battery threshold"
				secondaryText: "20%"
			}

			ListText {
				text: "Status"
				secondaryText: {
					if (!Global.system || !Global.system.battery) return "--"
					var soc = Global.system.battery.stateOfCharge
					if (isNaN(soc)) return "--"
					if (soc <= 20) return "⚠ LOW BATTERY"
					if (soc <= 50) return "OK - Monitor"
					return "OK - Good"
				}
			}

			SettingsListHeader {
				text: "Price Alerts"
			}

			ListText {
				text: "Cheap price threshold"
				secondaryText: "5p/kWh"
			}

			ListText {
				text: "Negative price alert"
				secondaryText: "Enabled"
			}

			ListText {
				text: "Current Agile price"
				secondaryText: {
					var p = Global.systemSettings.serviceUid + "/Settings/Gui/OctopusCurrentPrice"
					return "See Octopus Energy page"
				}
			}

			SettingsListHeader {
				text: "Last Alert"
			}

			ListText {
				text: "Last alert"
				secondaryText: lastAlert.valid && lastAlert.value !== "" ? lastAlert.value : "No alerts yet"
			}

			SettingsListHeader {
				text: "Alerts show as notifications on the Cerbo"
			}
		}
	}
}
