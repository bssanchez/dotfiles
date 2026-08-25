import QtQuick
import QtCore

import Quickshell
import Quickshell.Io

Item {
    id: root
    implicitWidth: 26
    implicitHeight: 26

    readonly property string statePath: StandardPaths.writableLocation(StandardPaths.HomeLocation) + "/.cache/idle_enabled"

    readonly property bool enabled: (stateFile.text() || "enabled").indexOf("disabled") === -1

    FileView {
        id: stateFile
        path: root.statePath
        watchChanges: true
        blockLoading: true
        onFileChanged: this.reload()
    }

    Process { id: toggleProc }

    Rectangle {
        anchors.fill: parent
        color: hover.hovered ? (theme.colors.surface0 || "black") : (theme.colors.crust || "black")
        radius: height / 2

        Text {
            anchors.centerIn: parent
            text: root.enabled ? "󰒲" : "󰒳"
            color: theme.colors.yellow || "orange"
            font.family: theme.fontFamily
            font.pixelSize: 16
        }

        HoverHandler { id: hover }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                toggleProc.command = ["sh", "-c", "~/.config/hypr/scripts/toggle_idle.sh"];
                toggleProc.running = true;
            }
        }
    }
}
