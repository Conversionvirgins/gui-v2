/*
** Octopus Energy Account Details
** Shows account info, tariff, and usage data.
*/

import QtQuick
import Victron.VenusOS

Page {
	id: root

	VeQuickItem {
		id: accountNumber
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/OctopusAccountNumber"
	}
	VeQuickItem {
		id: tariffCode
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/OctopusTariffCode"
	}
	VeQuickItem {
		id: region
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/OctopusRegion"
	}
	VeQuickItem {
		id: mpan
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/OctopusMpan"
	}
	VeQuickItem {
		id: meterSerial
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/OctopusMeterSerial"
	}
	VeQuickItem {
		id: standingCharge
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/OctopusStandingCharge"
	}
	VeQuickItem {
		id: tariffEnd
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/OctopusTariffEnd"
	}
	VeQuickItem {
		id: todayUsage
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/OctopusTodayUsage"
	}
	VeQuickItem {
		id: todayCost
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/OctopusTodayCost"
	}
	VeQuickItem {
		id: yesterdayUsage
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/OctopusYesterdayUsage"
	}
	VeQuickItem {
		id: yesterdayCost
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/OctopusYesterdayCost"
	}
	VeQuickItem {
		id: gasRate
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/OctopusGasRate"
	}
	VeQuickItem {
		id: gasTariff
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/OctopusGasTariff"
	}

	GradientListView {
		model: VisibleItemModel {

			SettingsListHeader {
				text: "Account"
			}

			ListText {
				text: "Account"
				secondaryText: accountNumber.valid && accountNumber.value !== "" ? accountNumber.value : "--"
			}

			ListText {
				text: "MPAN"
				secondaryText: mpan.valid && mpan.value !== "" ? mpan.value : "--"
			}

			ListText {
				text: "Meter"
				secondaryText: meterSerial.valid && meterSerial.value !== "" ? meterSerial.value : "--"
			}

			SettingsListHeader {
				text: "Electricity Tariff"
			}

			ListText {
				text: "Tariff"
				secondaryText: tariffCode.valid && tariffCode.value !== "" ? tariffCode.value : "--"
			}

			ListText {
				text: "Region"
				secondaryText: region.valid && region.value !== "" ? region.value : "--"
			}

			ListText {
				text: "Standing Charge"
				secondaryText: standingCharge.valid && standingCharge.value !== "" && standingCharge.value !== "0"
					? standingCharge.value + "p/day" : "--"
			}

			ListText {
				text: "Tariff Ends"
				secondaryText: tariffEnd.valid && tariffEnd.value !== "" ? tariffEnd.value : "--"
			}

			SettingsListHeader {
				text: "Gas"
			}

			ListText {
				text: "Gas Tariff"
				secondaryText: gasTariff.valid && gasTariff.value !== "" ? gasTariff.value : "--"
			}

			ListText {
				text: "Gas Rate"
				secondaryText: gasRate.valid && gasRate.value !== "" && gasRate.value !== "0"
					? gasRate.value + "p/kWh" : "--"
			}

			SettingsListHeader {
				text: "Usage"
			}

			ListText {
				text: "Today"
				secondaryText: todayUsage.valid && todayUsage.value !== "" && todayUsage.value !== "0"
					? todayUsage.value + " kWh" : "Waiting..."
			}

			ListText {
				text: "Today Cost"
				secondaryText: todayCost.valid && todayCost.value !== "" && todayCost.value !== "0"
					? "£" + todayCost.value : "--"
			}

			ListText {
				text: "Yesterday"
				secondaryText: yesterdayUsage.valid && yesterdayUsage.value !== "" && yesterdayUsage.value !== "0"
					? yesterdayUsage.value + " kWh" : "--"
			}

			ListText {
				text: "Yesterday Cost"
				secondaryText: yesterdayCost.valid && yesterdayCost.value !== "" && yesterdayCost.value !== "0"
					? "£" + yesterdayCost.value : "--"
			}

			SettingsListHeader {
				text: "Octopus Energy | Agile"
			}
		}
	}
}
