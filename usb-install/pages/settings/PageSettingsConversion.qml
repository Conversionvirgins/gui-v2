/*
** Custom Conversion Settings
** A separate area for custom modifications to the Cerbo GX UI.
*/

import QtQuick
import Victron.VenusOS

Page {
	id: root

	GradientListView {
		model: VisibleItemModel {

			SettingsListHeader {
				text: "Appearance"
			}

			ListNavigation {
				text: "Background"
				secondaryText: {
					if (bgImagePath.value && bgImagePath.value !== "") {
						return "Custom image"
					}
					if (bgCustomEnabled.value === 1) {
						return "Custom color"
					}
					return "Default"
				}
				onClicked: Global.pageManager.pushPage(
					"/pages/settings/PageSettingsConversionBackground.qml",
					{"title": text})

				VeQuickItem {
					id: bgCustomEnabled
					uid: Global.systemSettings.serviceUid + "/Settings/Gui/Conversion/BackgroundEnabled"
				}
				VeQuickItem {
					id: bgImagePath
					uid: Global.systemSettings.serviceUid + "/Settings/Gui/Conversion/BackgroundImagePath"
				}
			}

			SettingsListHeader {
				text: "More Customizations"
			}

			ListText {
				text: "Custom features"
				secondaryText: "Add more conversion mods here"
			}
		}
	}
}
