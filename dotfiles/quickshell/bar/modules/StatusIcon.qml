import QtQuick
import Quickshell.Widgets
import qs.theme

Rectangle {
    id: root

    property string iconSource: ""
    property string label: ""
    property color labelColor: Theme.text
    signal activated()

    implicitHeight: 26
    implicitWidth: row.implicitWidth + 18
    radius: 13
    color: area.containsMouse ? Theme.hover : "transparent"

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 6

        IconImage {
            anchors.verticalCenter: parent.verticalCenter
            implicitSize: 16
            source: root.iconSource
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            visible: root.label.length > 0
            text: root.label
            color: root.labelColor
            font.pixelSize: 13
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.activated()
    }
}
