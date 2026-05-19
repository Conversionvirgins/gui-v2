/*
** Custom Conversion Settings - Background
** Allows changing the background color or setting a background image on the Cerbo GX.
*/

import QtQuick
import Victron.VenusOS

Page {
	id: root

	readonly property var colorPresets: [
		{ name: "Default (Theme)", color: "", value: 0 },
		{ name: "Deep Navy", color: "#0A1628", value: 1 },
		{ name: "Charcoal", color: "#1A1A2E", value: 2 },
		{ name: "Dark Teal", color: "#0B2027", value: 3 },
		{ name: "Midnight Purple", color: "#1A0A2E", value: 4 },
		{ name: "Forest Dark", color: "#0A1F0A", value: 5 },
		{ name: "Slate", color: "#2F3640", value: 6 },
		{ name: "Dark Red", color: "#1A0505", value: 7 },
		{ name: "Ocean Blue", color: "#051937", value: 8 },
	]

	VeQuickItem {
		id: bgColorItem
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/Conversion/BackgroundColor"
	}

	VeQuickItem {
		id: bgImagePathItem
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/Conversion/BackgroundImagePath"
	}

	VeQuickItem {
		id: bgColorPresetItem
		uid: Global.systemSettings.serviceUid + "/Settings/Gui/Conversion/BackgroundColorPreset"
	}

	GradientListView {
		model: VisibleItemModel {

			SettingsListHeader {
				text: "Background Mode"
			}

			ListSwitch {
				id: customBgSwitch
				text: "Use custom background"
				dataItem.uid: Global.systemSettings.serviceUid + "/Settings/Gui/Conversion/BackgroundEnabled"
			}

			SettingsListHeader {
				text: "Color Preset"
				preferredVisible: customBgSwitch.checked
			}

			ListRadioButtonGroup {
				text: "Background color"
				preferredVisible: customBgSwitch.checked
				dataItem.uid: Global.systemSettings.serviceUid + "/Settings/Gui/Conversion/BackgroundColorPreset"
				optionModel: root.colorPresets.map(function(p) {
					return { display: p.name, value: p.value }
				})
				onOptionClicked: function(index) {
					// Store the actual color hex for easy retrieval by Main.qml
					if (index === 0) {
						bgColorItem.setValue("")
					} else {
						bgColorItem.setValue(root.colorPresets[index].color)
					}
				}
			}

			SettingsListHeader {
				text: "Color Preview"
				preferredVisible: customBgSwitch.checked
						&& bgColorItem.value && bgColorItem.value !== ""
			}

			ListItem {
				preferredVisible: customBgSwitch.checked
						&& bgColorItem.value && bgColorItem.value !== ""
				contentItem: Rectangle {
					implicitWidth: 200
					implicitHeight: 60
					radius: 8
					color: bgColorItem.value || Theme.color_page_background
					border.color: Theme.color_font_secondary
					border.width: 1
				}
			}

			SettingsListHeader {
				text: "Background Image"
				preferredVisible: customBgSwitch.checked
			}

			ListTextField {
				text: "Image path"
				preferredVisible: customBgSwitch.checked
				placeholderText: "/data/custom/background.png"
				dataItem.uid: Global.systemSettings.serviceUid + "/Settings/Gui/Conversion/BackgroundImagePath"
			}

			ListText {
				text: "Image tip"
				preferredVisible: customBgSwitch.checked
				secondaryText: "Upload image to /data/custom/ via SSH"
			}

			ListButton {
				text: "Clear image"
				secondaryText: "Remove"
				preferredVisible: customBgSwitch.checked
						&& bgImagePathItem.value && bgImagePathItem.value !== ""
				onClicked: bgImagePathItem.setValue("")
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
					bgImagePathItem.setValue("")
				}
			}
		}
	}
}
