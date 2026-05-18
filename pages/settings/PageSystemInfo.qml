/*
** System Information
** Shows Cerbo details, firmware, and conversion info.
*/

import QtQuick
import Victron.VenusOS

Page {
	id: root

	VeQuickItem {
		id: firmwareVersion
		uid: Global.venusPlatform.serviceUid + "/Firmware/Installed/Version"
	}
	VeQuickItem {
		id: deviceModel
		uid: Global.venusPlatform.serviceUid + "/Device/Model"
	}
	VeQuickItem {
		id: serialNumber
		uid: Global.venusPlatform.serviceUid + "/Device/Serial"
	}

	GradientListView {
		model: VisibleItemModel {

			SettingsListHeader {
				text: "Device"
			}

			ListText {
				text: "Model"
				secondaryText: deviceModel.valid ? deviceModel.value : "--"
			}

			ListText {
				text: "Serial"
				secondaryText: serialNumber.valid ? serialNumber.value : "--"
			}

			ListText {
				text: "Firmware"
				secondaryText: firmwareVersion.valid ? firmwareVersion.value : "--"
			}

			SettingsListHeader {
				text: "Conversion"
			}

			ListText {
				text: "Mod Version"
				secondaryText: "1.0"
			}

			ListText {
				text: "Created by"
				secondaryText: "Conversion Virgins"
			}

			ListText {
				text: "Website"
				secondaryText: "www.conversionvirgins.co.uk"
			}

			ListText {
				text: "Powered by"
				secondaryText: "BMS Technologies"
			}

			ListText {
				text: "BMS Website"
				secondaryText: "www.bmstechnologies.co.uk"
			}

			SettingsListHeader {
				text: "Support"
			}

			ListText {
				text: "Contact"
				secondaryText: "info@conversionvirgins.co.uk"
			}
		}
	}
}
