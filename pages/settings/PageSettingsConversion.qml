/*
** Conversion Virgins Tools
** Custom modifications and tools for the Cerbo GX.
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
				text: "Theme"
				secondaryText: {
					if (bgCustomEnabled.value === 1) {
						return "Custom"
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
			}

			SettingsListHeader {
				text: "Branding"
			}

			ListSwitch {
				text: "Show logo on Brief page"
				dataItem.uid: Global.systemSettings.serviceUid + "/Settings/Gui/Conversion/LogoEnabled"
			}

			SettingsListHeader {
				text: "Energy"
			}

			ListNavigation {
				text: "Campervan Overview"
				secondaryText: "Battery, solar, loads"
				onClicked: Global.pageManager.pushPage(
					"/pages/settings/PageCampervanOverview.qml",
					{"title": text})
			}

			ListNavigation {
				text: "Energy Log"
				secondaryText: "Daily yield and consumption"
				onClicked: Global.pageManager.pushPage(
					"/pages/settings/PageEnergyLog.qml",
					{"title": text})
			}

			ListNavigation {
				text: "Octopus Energy"
				secondaryText: "Agile tariff prices"
				onClicked: Global.pageManager.pushPage(
					"/pages/settings/PageOctopusEnergy.qml",
					{"title": text})
			}

			ListNavigation {
				text: "Octopus Account"
				secondaryText: "Account, tariff, usage"
				onClicked: Global.pageManager.pushPage(
					"/pages/settings/PageOctopusAccount.qml",
					{"title": text})
			}

			SettingsListHeader {
				text: "Monitoring"
			}

			ListNavigation {
				text: "Alerts"
				secondaryText: "Battery and price alerts"
				onClicked: Global.pageManager.pushPage(
					"/pages/settings/PageAlerts.qml",
					{"title": text})
			}

			ListNavigation {
				text: "AI Assistant"
				secondaryText: "Ask about your energy system"
				onClicked: Global.pageManager.pushPage(
					"/pages/settings/PageAiAssistant.qml",
					{"title": text})
			}

			SettingsListHeader {
				text: "System"
			}

			ListNavigation {
				text: "System Info"
				secondaryText: "Device, firmware, support"
				onClicked: Global.pageManager.pushPage(
					"/pages/settings/PageSystemInfo.qml",
					{"title": text})
			}

			SettingsListHeader { }

			SettingsListHeader {
				text: "Version 1.0 | Created by Conversion Virgins | www.conversionvirgins.co.uk"
			}
		}
	}
}
