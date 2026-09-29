import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.theme

Rectangle {
    id: root

    property string targetMonitor: ""

    readonly property var workspaces: Hyprland.workspaces.values.filter(w => w && w.id > 0 && w.monitor && w.monitor.name === root.targetMonitor).sort((a, b) => a.id - b.id)

    implicitWidth: row.implicitWidth + 16
    implicitHeight: row.implicitHeight + 10
    radius: height / 2
    color: Theme.pill

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 6

        Repeater {
            model: root.workspaces

            delegate: Rectangle {
                id: ws
                required property var modelData

                width: 18
                height: 18
                radius: 9
                color: modelData.focused ? Theme.accent : modelData.active ? Theme.accentDim : Theme.dot

                Behavior on color {
                    ColorAnimation {
                        duration: 150
                    }
                }

                Text {
                    anchors.centerIn: parent
                    visible: ws.modelData.urgent
                    text: "!"
                    color: Theme.accentText
                    font.pixelSize: 11
                    font.bold: true
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: ws.modelData.activate()
                }
            }
        }
    }
}
