/*
** Octopus Energy Agile Prices
** Shows current and upcoming Agile tariff prices.
*/

import QtQuick
import Victron.VenusOS

Page {
	id: root

	VeQuickItem {
		id: currentPrice
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/OctopusCurrentPrice"
	}
	VeQuickItem {
		id: nextPrice
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/OctopusNextPrice"
	}
	VeQuickItem {
		id: currentPeriod
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/OctopusCurrentPeriod"
	}
	VeQuickItem {
		id: nextPeriod
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/OctopusNextPeriod"
	}
	VeQuickItem {
		id: minPrice
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/OctopusMinPrice"
	}
	VeQuickItem {
		id: maxPrice
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/OctopusMaxPrice"
	}
	VeQuickItem {
		id: avgPrice
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/OctopusAvgPrice"
	}
	VeQuickItem {
		id: lastUpdate
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/OctopusLastUpdate"
	}
	VeQuickItem {
		id: status
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/OctopusStatus"
	}

	GradientListView {
		model: VisibleItemModel {

			SettingsListHeader {
				text: "Current Price"
			}

			ListText {
				text: "Now"
				secondaryText: currentPrice.valid && currentPrice.value !== "0"
					? currentPrice.value + "p/kWh"
					: "Waiting for data..."
			}

			ListText {
				text: "Period"
				secondaryText: currentPeriod.valid && currentPeriod.value !== "" ? currentPeriod.value : "--"
			}

			SettingsListHeader {
				text: "Next Period"
			}

			ListText {
				text: "Next"
				secondaryText: nextPrice.valid && nextPrice.value !== "0"
					? nextPrice.value + "p/kWh"
					: "--"
			}

			ListText {
				text: "Period"
				secondaryText: nextPeriod.valid && nextPeriod.value !== "" ? nextPeriod.value : "--"
			}

			SettingsListHeader {
				text: "Today's Summary"
			}

			ListText {
				text: "Lowest"
				secondaryText: minPrice.valid && minPrice.value !== "0" ? minPrice.value + "p/kWh" : "--"
			}

			ListText {
				text: "Highest"
				secondaryText: maxPrice.valid && maxPrice.value !== "0" ? maxPrice.value + "p/kWh" : "--"
			}

			ListText {
				text: "Average"
				secondaryText: avgPrice.valid && avgPrice.value !== "0" ? avgPrice.value + "p/kWh" : "--"
			}

			SettingsListHeader {
				text: "Service"
			}

			ListText {
				text: "Status"
				secondaryText: status.valid ? status.value : "Not running"
			}

			ListText {
				text: "Last update"
				secondaryText: lastUpdate.valid && lastUpdate.value !== "" ? lastUpdate.value : "--"
			}

			SettingsListHeader {
				text: "Octopus Energy Agile | Region F (North East)"
			}
		}
	}
}
