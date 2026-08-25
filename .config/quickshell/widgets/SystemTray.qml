import QtQuick
import QtQuick.Layouts

import Quickshell
import Quickshell.Io
import Quickshell.Services.SystemTray

import "../components"

RowLayout {
    id: root

    property var colors: theme.colors

    visible: SystemTray.items.values.length > 0
    spacing: 4

    Rectangle {
        clip: true
        height: 26
        radius: 10

        color: colors.mantle || "black"

        Layout.preferredWidth: trayInner.implicitWidth + 20

        RowLayout {
            id: trayInner
            anchors.centerIn: parent
            spacing: 8

            Tray {
                iconSize: 14
                colors: root.colors
            }
        }
    }
}
