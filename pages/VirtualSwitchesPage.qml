/*
** Copyright (C) 2025 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

import QtQuick
import Victron.VenusOS

SwipeViewPage {
	id: root

	topLeftButton: VenusOS.StatusBar_LeftButton_ControlsInactive
	fullScreenWhenIdle: true
	focusPolicy: Qt.TabFocus
	//% "Switches"
	title: qsTrId("nav_switches")
	iconSource: "qrc:/images/icon_switch_24.svg"
	url: "qrc:/qt/qml/Victron/VenusOS/pages/VirtualSwitchesPage.qml"

	clip: cardsView.contentWidth > cardsView.width

	onActiveFocusChanged: {
		if (root.view.focusEdgeHint === Qt.TopEdge) {
			cardsView.focus = true
		} else if (root.view.focusEdgeHint === Qt.BottomEdge) {
			cardsView.focus = true
		}
	}

	BaseListView {
		id: cardsView

		function scrollToControl(item) {
			const itemContentX = contentItem.mapFromItem(item, 0, 0).x
			let distance
			if (itemContentX + item.width > contentX + width) {
				distance = (itemContentX + item.width) - (contentX + width)
			} else if (itemContentX < contentX) {
				distance = (itemContentX - contentX)
			} else {
				return
			}
			if (Math.abs(distance) > width * 2) {
				contentX += distance
				returnToBounds()
			} else {
				let velocity = Math.sqrt(2 * Math.abs(distance) * flickDeceleration)
				if (distance > 0) {
					velocity = -velocity
				}
				flick(velocity, 0)
			}
		}

		anchors {
			fill: parent
			leftMargin: Theme.geometry_controlCardsPage_horizontalMargin
			rightMargin: Theme.geometry_controlCardsPage_horizontalMargin
			topMargin: Global.pageManager?.expandLayout
					? Theme.geometry_levelsPage_gaugesView_expanded_topMargin
					: Theme.geometry_levelsPage_gaugesView_compact_topMargin
			bottomMargin: Theme.geometry_controlCardsPage_bottomMargin
		}
		spacing: Theme.geometry_controlCardsPage_spacing
		orientation: ListView.Horizontal
		highlightFollowsCurrentItem: false

		model: SortedIOChannelGroupModel { sourceModel: Global.switches.groups }
		delegate: IOChannelGroupCard {
			height: cardsView.height
			onCurrentItemChanged: {
				if (currentItem) {
					cardsView.scrollToControl(currentItem)
				}
			}
		}

		WheelHandler {
			enabled: Qt.platform.os === "wasm" || Global.isDesktop
			onWheel: (wheel) => {
				cardsView.flick((cardsView.flickDeceleration * 2.0*wheel.angleDelta.y/360) - cardsView.horizontalVelocity, 0)
				wheel.accepted = true
			}
		}
	}

	// Show gradients on the left/right edges to indicate the page bounds
	ViewGradient {
		x: -(width / 2) + (height / 2)
		rotation: 90
		visible: root.clip
	}
	ViewGradient {
		x: (width / 2) - (height / 2)
		rotation: 270
		visible: root.clip
	}
}
