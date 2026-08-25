import QtQuick

import Quickshell

Item {
    id: root
    implicitWidth: 26
    implicitHeight: 26

    Rectangle {
        anchors.fill: parent
        color: hover.hovered ? (theme.colors.surface0 || "black") : (theme.colors.crust || "black")
        radius: height / 2

        Text {
            anchors.centerIn: parent
            text: "⏻"
            color: theme.colors.red || "red"
            font.family: theme.fontFamily
            font.pixelSize: 15
        }

        HoverHandler { id: hover }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: Quickshell.execDetached(["sh", "-c", "~/.config/hypr/scripts/powermenu.sh"])
        }
    }
}
