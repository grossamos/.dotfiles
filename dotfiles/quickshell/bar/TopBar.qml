import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import "modules"
import qs.services
import qs.theme

Variants {
    model: Quickshell.screens

    delegate: PanelWindow {
        id: bar
        required property var modelData
        screen: modelData

        anchors {
            top: true
            left: true
            right: true
        }
        implicitHeight: Theme.barSize
        color: Theme.bar

        Workspaces {
            anchors {
                left: parent.left
                leftMargin: 12
                verticalCenter: parent.verticalCenter
            }
            targetMonitor: bar.modelData.name
        }

        Text {
            anchors.centerIn: parent
            text: Time.time + "  •  " + Time.date
            color: Theme.text
            font.pixelSize: 13
        }

        Row {
            anchors {
                right: parent.right
                rightMargin: 12
                verticalCenter: parent.verticalCenter
            }
            spacing: 8

            StatusIcon {
                anchors.verticalCenter: parent.verticalCenter
                iconSource: Quickshell.iconPath(Audio.icon)
                label: Audio.percent + "%"
                labelColor: Audio.muted ? Theme.accent : Theme.text
                onActivated: () => Quickshell.execDetached(["hyprpwcenter"])
            }

            StatusIcon {
                anchors.verticalCenter: parent.verticalCenter
                iconSource: Quickshell.iconPath(Net.icon)
                label: Net.connected ? Net.name : "offline"
                onActivated: () => Quickshell.execDetached(["nmrs-gui"])
            }

            StatusIcon {
                anchors.verticalCenter: parent.verticalCenter
                iconSource: Quickshell.iconPath(Battery.icon)
                label: Battery.ready ? Battery.percent + "%" : ""
                labelColor: !Battery.charging && !Battery.full && Battery.percent <= 20 ? Theme.critical : Theme.text
            }
        }
    }
}
