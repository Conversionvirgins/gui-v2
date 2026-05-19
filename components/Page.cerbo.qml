/*
** Copyright (C) 2023 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

import QtQuick
import Victron.VenusOS

FocusScope {
        id: root

        property string title
        property color backgroundColor: {
                if (_convBgEnabled.value === 1 && _convBgColor.value && _convBgColor.value !== "") {
                        return _convBgColor.value
                }
                return Theme.color_page_background
        }
        property bool fullScreenWhenIdle
        readonly property bool isCurrentPage: !!Global.mainView && Global.mainView.currentPage === root
        readonly property bool defaultAnimationEnabled: !!Global.mainView
                        && Global.mainView.allowPageAnimations
                        && !ScreenBlanker.blanked
        property bool animationEnabled: defaultAnimationEnabled && isCurrentPage

        property int topLeftButton: VenusOS.StatusBar_LeftButton_None
        property int topRightButton: VenusOS.StatusBar_RightButton_None

        property var tryPop

        readonly property bool __is_venus_gui_page__: true

        implicitWidth: Theme.geometry_screen_width
        implicitHeight: Theme.geometry_screen_height
        focus: isCurrentPage

        VeQuickItem {
                id: _convBgEnabled
                uid: !!Global.systemSettings ? Global.systemSettings.serviceUid + "/Settings/Gui/Conversion/BackgroundEnabled" : ""
        }
        VeQuickItem {
                id: _convBgColor
                uid: !!Global.systemSettings ? Global.systemSettings.serviceUid + "/Settings/Gui/Conversion/BackgroundColor" : ""
        }
}
