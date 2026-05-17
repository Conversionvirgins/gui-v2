import QtQuick
import QtQml.Models
import Victron.VenusOS
import Victron.Boat as Boat

ObjectModel {
	id: root

	required property SwipeView view
	readonly property list<SwipeViewPage> pages: {
		let p = []
		if (showBoatPage) p.push(boatPageLoader.item)
		p.push(briefPage)
		p.push(overviewPage)
		if (showLevelsPage) p.push(levelsPageLoader.item)
		if (showSwitchesPage) p.push(switchesPageLoader.item)
		p.push(notificationsPage)
		p.push(settingsPage)
		return p
	}
	readonly property bool showLevelsPage: levelsPageLoader.active && !!levelsPageLoader.item
	readonly property bool showSwitchesPage: switchesPageLoader.active && !!switchesPageLoader.item
	readonly property bool showBoatPage: boatPageLoader.active && !!boatPageLoader.item
	readonly property int tankCount: Global.tanks ? Global.tanks.totalTankCount : 0
	readonly property int environmentInputCount: Global.environmentInputs ? Global.environmentInputs.model.count : 0
	readonly property int switchGroupCount: Global.switches ? Global.switches.groups.count : 0

	readonly property bool completed: _completed
		&& Global.dataManagerLoaded
		&& Global.systemSettings
		&& Global.tanks
		&& Global.environmentInputs
		&& Global.switches
		&& pages.length === (4 + (showBoatPage ? 1 : 0) + (showLevelsPage ? 1 : 0) + (showSwitchesPage ? 1 : 0))

	property bool _completed: false

	Loader {
		id: boatPageLoader

		active: showBoatPageItem.value ?? false
		sourceComponent: Boat.BoatPage {
			view: root.view
		}

		VeQuickItem {
			id: showBoatPageItem
			uid: !!Global.systemSettings ? Global.systemSettings.serviceUid + "/Settings/Gui/ElectricPropulsionUI/Enabled" : ""
		}
	}

	BriefPage {
		id: briefPage
		view: root.view

		Image {
			width: status === Image.Null ? 0 : Theme.geometry_screen_width
			fillMode: Image.PreserveAspectFit
			source: BackendConnection.demoImageFileName
			onStatusChanged: {
				if (status === Image.Ready) {
					console.info("Loaded demo image:", source)
				}
			}
		}
	}

	OverviewPage {
		id: overviewPage
		view: root.view
	}

	Loader {
		id: levelsPageLoader

		active: root.tankCount > 0 || root.environmentInputCount > 0
		sourceComponent: LevelsPage {
			view: root.view
		}
	}

	Loader {
		id: switchesPageLoader

		active: root.switchGroupCount > 0
		sourceComponent: VirtualSwitchesPage {
			view: root.view
		}
	}

	NotificationsPage {
		id: notificationsPage
		view: root.view
	}

	SettingsPage {
		id: settingsPage
		view: root.view
	}

	Component.onCompleted: Qt.callLater(function() { root._completed = true })
}
