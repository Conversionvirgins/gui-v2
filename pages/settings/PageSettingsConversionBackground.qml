/*
** Custom Conversion Settings - Theme
** Allows changing the theme colors on the Cerbo GX.
*/

import QtQuick
import Victron.VenusOS

Page {
	id: root

	readonly property var colorPresets: [
		{ name: "Default (Theme)", color: "", value: 0 },
		{ name: "BMS Tech Theme", color: "#F5B800", value: 1 },
		{ name: "Navy Blue", color: "#1B3A5C", value: 2 },
		{ name: "Charcoal", color: "#2A2A28", value: 3 },
		{ name: "Teal", color: "#1A4D5C", value: 4 },
		{ name: "Forest Green", color: "#1E4D2B", value: 5 },
		{ name: "Slate Grey", color: "#3E4A56", value: 6 },
		{ name: "Burgundy", color: "#4A1A2E", value: 7 },
		{ name: "Steel Blue", color: "#4682B4", value: 8 },
		{ name: "Olive", color: "#556B2F", value: 9 },
	]

	VeQuickItem {
		id: bgColorItem
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/Conversion/BackgroundColor"
	}

	VeQuickItem {
		id: bgColorPresetItem
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/Conversion/BackgroundColorPreset"
	}

	GradientListView {
		model: VisibleItemModel {

			SettingsListHeader {
				text: "Theme"
			}

			ListSwitch {
				id: customBgSwitch
				text: "Use custom theme"
				dataItem.uid: Global.systemSettings.serviceUid + "/Settings/Gui/Conversion/BackgroundEnabled"
			}

			SettingsListHeader {
				text: "Color Preset"
				preferredVisible: customBgSwitch.checked
			}

			ListRadioButtonGroup {
				text: "Theme color"
				preferredVisible: customBgSwitch.checked
				dataItem.uid: Global.systemSettings.serviceUid + "/Settings/Gui/Conversion/BackgroundColorPreset"
				optionModel: root.colorPresets.map(function(p) {
					return { display: p.name, value: p.value }
				})
				onOptionClicked: function(index) {
					if (index === 0) {
						bgColorItem.setValue("")
					} else {
						bgColorItem.setValue(root.colorPresets[index].color)
					}
				}
			}

			SettingsListHeader {
				text: "Reset"
			}

			ListButton {
				text: "Reset to defaults"
				secondaryText: "Reset"
				onClicked: {
					customBgSwitch.dataItem.setValue(0)
					bgColorPresetItem.setValue(0)
					bgColorItem.setValue("")
				}
			}
		}
	}
}
