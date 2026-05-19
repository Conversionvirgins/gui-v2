/*
** Copyright (C) 2023 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

import QtQuick
import Victron.VenusOS

ArcGauge {
        id: root

        property int horizontalAlignment
        property int valueType: VenusOS.Gauges_ValueType_NeutralPercentage
        readonly property int valueStatus: Theme.getValueStatus(value, valueType)

        readonly property bool _bmsTheme: _convBgEnabled.value === 1 && _convBgColor.value === "#F5B800"

        VeQuickItem {
                id: _convBgEnabled
                uid: !!Global.systemSettings ? Global.systemSettings.serviceUid + "/Settings/Gui/Conversion/BackgroundEnabled" : ""
        }
        VeQuickItem {
                id: _convBgColor
                uid: !!Global.systemSettings ? Global.systemSettings.serviceUid + "/Settings/Gui/Conversion/BackgroundColor" : ""
        }

        width: parent.width
        height: parent.height
        radius: Theme.geometry_briefPage_edgeGauge_radius
        useLargeArc: false
        strokeWidth: Theme.geometry_arc_strokeWidth
        progressColor: _bmsTheme ? "#F5B800" : Theme.statusColorValue(valueStatus)
        remainderColor: _bmsTheme ? "#3D3000" : Theme.statusColorValue(valueStatus, true)
        arcHorizontalCenterOffset: (horizontalAlignment & Qt.AlignLeft) ? -(width - (2 * radius)) / 2
                        : (horizontalAlignment & Qt.AlignRight) ? (width - (2 * radius)) / 2
                        : 0
}
