/*
** Energy Log
** Shows daily solar yield, battery energy, and consumption.
*/

import QtQuick
import Victron.VenusOS

Page {
	id: root

	VeQuickItem {
		id: solarToday
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/OctopusSolarToday"
	}
	VeQuickItem {
		id: battCharged
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/OctopusBattCharged"
	}
	VeQuickItem {
		id: battDischarged
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/OctopusBattDischarged"
	}
	VeQuickItem {
		id: acConsumed
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/OctopusAcConsumed"
	}
	VeQuickItem {
		id: solarYesterday
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/OctopusSolarYesterday"
	}

	GradientListView {
		model: VisibleItemModel {

			SettingsListHeader {
				text: "Today"
			}

			ListText {
				text: "Solar Yield"
				secondaryText: solarToday.valid && solarToday.value !== "" && solarToday.value !== "0"
					? solarToday.value + " kWh" : "0.00 kWh"
			}

			ListText {
				text: "Battery Charged"
				secondaryText: battCharged.valid && battCharged.value !== "" && battCharged.value !== "0"
					? battCharged.value + " kWh" : "0.00 kWh"
			}

			ListText {
				text: "Battery Discharged"
				secondaryText: battDischarged.valid && battDischarged.value !== "" && battDischarged.value !== "0"
					? battDischarged.value + " kWh" : "0.00 kWh"
			}

			ListText {
				text: "AC Consumed"
				secondaryText: acConsumed.valid && acConsumed.value !== "" && acConsumed.value !== "0"
					? acConsumed.value + " kWh" : "0.00 kWh"
			}

			SettingsListHeader {
				text: "Yesterday"
			}

			ListText {
				text: "Solar Yield"
				secondaryText: solarYesterday.valid && solarYesterday.value !== "" && solarYesterday.value !== "0"
					? solarYesterday.value + " kWh" : "--"
			}

			SettingsListHeader {
				text: "Live"
			}

			ListText {
				text: "Solar Power"
				secondaryText: Global.system && Global.system.solar && !isNaN(Global.system.solar.power)
					? Math.round(Global.system.solar.power) + "W" : "--"
			}

			ListText {
				text: "Battery Power"
				secondaryText: Global.system && Global.system.battery && !isNaN(Global.system.battery.power)
					? Math.round(Global.system.battery.power) + "W" : "--"
			}

			SettingsListHeader {
				text: "Energy tracking resets at midnight"
			}
		}
	}
}
