/*
** Copyright (C) 2023 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

import QtQuick
import Victron.VenusOS

Item {
        id: gauges

        property alias value: arc.value
        property alias startAngle: arc.startAngle
        property alias endAngle: arc.endAngle
        property int status
        property alias animationEnabled: arc.animationEnabled
        property alias shineAnimationEnabled: arc.shineAnimationEnabled

        readonly property bool _bmsTheme: _convBgEnabled.value === 1 && _convBgColor.value === "#F5B800"

        VeQuickItem {
                id: _convBgEnabled
                uid: !!Global.systemSettings ? Global.systemSettings.serviceUid + "/Settings/Gui/Conversion/BackgroundEnabled" : ""
        }
        VeQuickItem {
                id: _convBgColor
                uid: !!Global.systemSettings ? Global.systemSettings.serviceUid + "/Settings/Gui/Conversion/BackgroundColor" : ""
        }

        Item {
                id: antialiased
                anchors.fill: parent

                layer.enabled: !BackendConnection.msaaEnabled
                layer.smooth: true
                layer.textureSize: Qt.size(antialiased.width*2, antialiased.height*2)

                ShinyProgressArc {
                        id: arc

                        width: gauges.width
                        height: width
                        anchors.centerIn: parent
                        radius: width/2
                        startAngle: 0
                        endAngle: 359
                        progressColor: gauges._bmsTheme ? "#F5B800" : Theme.statusColorValue(gauges.status)
                        remainderColor: gauges._bmsTheme ? "#3D3000" : Theme.statusColorValue(gauges.status, true)
                        strokeWidth: Theme.geometry_circularSingularGauge_strokeWidth
                }
        }
}
