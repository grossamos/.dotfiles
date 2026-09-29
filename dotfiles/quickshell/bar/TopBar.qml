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
        implicitHeight: Theme.barSize + 12
        color: "transparent"

        Rectangle {
            id: island
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                topMargin: 6
                bottomMargin: 0
                leftMargin: 10
                rightMargin: 10
            }
            height: Theme.barSize
            radius: Theme.radius
            color: Theme.bar

            Row {
                id: leftCluster
                anchors {
                    left: parent.left
                    leftMargin: 8
                    verticalCenter: parent.verticalCenter
                }
                spacing: 8

                Workspaces {
                    anchors.verticalCenter: parent.verticalCenter
                    targetMonitor: bar.modelData.name
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

            Text {
                anchors.centerIn: parent
                text: Time.time + "  •  " + Time.date
                color: Theme.text
                font.pixelSize: 15
                font.weight: Font.DemiBold
            }

            StatusIcon {
                anchors {
                    right: parent.right
                    rightMargin: 8
                    verticalCenter: parent.verticalCenter
                }
                iconSource: Quickshell.iconPath(Audio.icon)
                label: Audio.percent + "%"
                labelColor: Audio.muted ? Theme.critical : Theme.text
                onActivated: () => Quickshell.execDetached(["hyprpwcenter"])
            }
        }
    }
}
