import QtQuick
import QtQuick.Layouts

import Quickshell

import "../widgets"

PanelWindow {
    id: topBar
    screen: modelData
    implicitHeight: 36
    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        top: 5
        left: 5
        right: 5
        bottom: 0
    }

    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: theme.colors.background || "black"
        radius: 15

        RowLayout {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 10
            spacing: 10

            Item {
                Layout.preferredWidth: 28
                Layout.preferredHeight: 28

                Text {
                    anchors.centerIn: parent
                    text: ""
                    color: theme.colors.sapphire || "white"
                    font.family: theme.fontFamily
                    font.pixelSize: 19
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Quickshell.execDetached(["rofi", "-show", "drun"])
                }
            }

            CPU {}
            MEM {}
            Disk {}
        }

        Item {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            Workspaces {
                monitorName: topBar.screen?.name ?? ""
            }
        }

        RowLayout {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 10
            spacing: 10

            SystemTray {}

            Connectivity {}

            Volume {}

            Clock {}

            LockToggle {}

            Notifications {}

            PowerMenu {}
        }
    }
}
