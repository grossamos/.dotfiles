import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import qs.services
import qs.theme

Variants {
    model: Quickshell.screens

    delegate: PanelWindow {
        id: popup
        required property var modelData
        screen: modelData

        property var cards: []
        readonly property bool onFocusedScreen: Hyprland.focusedMonitor?.name === modelData.name
        readonly property int cardWidth: 380

        function setHover(id, hover) {
            popup.cards = popup.cards.map(c => c.id === id ? Object.assign({}, c, {
                        hover: hover
                    }) : c);
        }

        function dismiss(id) {
            const card = popup.cards.find(c => c.id === id);
            if (card)
                card.notif.close();
            popup.cards = popup.cards.filter(c => c.id !== id);
        }

        Timer {
            interval: 1000
            running: popup.cards.length > 0
            repeat: true
            onTriggered: {
                const now = Date.now();
                popup.cards = popup.cards.filter(c => c.hover || c.sticky || now - c.time < c.ttl);
            }
        }

        Connections {
            target: NotifServer

            function onNotification(notification) {
                const ttl = notification.expireTimeout > 0 ? notification.expireTimeout : 6000;
                const card = {
                    id: notification.id,
                    notif: notification,
                    time: Date.now(),
                    ttl: ttl,
                    sticky: notification.expireTimeout === 0,
                    hover: false
                };
                if (popup.cards.some(c => c.id === card.id)) {
                    popup.cards = popup.cards.map(c => c.id === card.id ? card : c);
                } else {
                    popup.cards = [card].concat(popup.cards);
                }
            }
        }

        visible: popup.cards.length > 0 && popup.onFocusedScreen
        implicitWidth: popup.cardWidth
        implicitHeight: visible ? stack.implicitHeight : 0

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "quickshell-notifications"
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

        mask: Region {
            item: stack
        }

        color: "transparent"

        anchors {
            top: true
            right: true
        }

        margins {
            top: 60
            right: 12
        }

        Column {
            id: stack
            width: popup.cardWidth
            spacing: 10

            add: Transition {
                NumberAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 200
                }
            }

            populate: Transition {
                NumberAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 200
                }
            }

            move: Transition {
                NumberAnimation {
                    property: "y"
                    duration: 250
                    easing.type: Easing.OutCubic
                }
            }

            Repeater {
                model: popup.cards

                delegate: Rectangle {
                    id: card
                    required property var modelData
                    readonly property var notif: modelData.notif

                    width: popup.cardWidth
                    height: Math.max(iconBox.height, textCol.implicitHeight) + 24
                    radius: 18
                    color: Theme.card

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onContainsMouseChanged: popup.setHover(card.modelData.id, containsMouse)
                        onClicked: popup.dismiss(card.modelData.id)
                    }

                    Row {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 12

                        Rectangle {
                            id: iconBox
                            width: 40
                            height: 40
                            radius: 20
                            anchors.verticalCenter: parent.verticalCenter
                            color: Theme.accent

                            IconImage {
                                anchors.centerIn: parent
                                implicitSize: 22
                                visible: card.notif.appIcon.length > 0
                                source: card.notif.appIcon.startsWith("file:") ? card.notif.appIcon : Quickshell.iconPath(card.notif.appIcon)
                            }

                            Text {
                                anchors.centerIn: parent
                                visible: card.notif.appIcon.length === 0
                                text: "!"
                                color: Theme.onAccent
                                font.pixelSize: 20
                                font.bold: true
                            }
                        }

                        Column {
                            id: textCol
                            width: parent.width - iconBox.width - parent.spacing - 24
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 2

                            Text {
                                width: parent.width
                                visible: card.notif.appName.length > 0
                                text: card.notif.appName
                                color: Theme.textDim
                                font.pixelSize: 11
                                elide: Text.ElideRight
                            }

                            Text {
                                width: parent.width
                                text: card.notif.summary
                                color: Theme.text
                                font.pixelSize: 14
                                font.bold: true
                                elide: Text.ElideRight
                            }

                            Text {
                                width: parent.width
                                visible: card.notif.body.length > 0
                                text: card.notif.body
                                color: Theme.textDim
                                font.pixelSize: 12
                                wrapMode: Text.Wrap
                            }
                        }
                    }

                    Text {
                        anchors {
                            top: parent.top
                            topMargin: 8
                            right: parent.right
                            rightMargin: 12
                        }
                        text: "×"
                        color: Theme.textDim
                        font.pixelSize: 16

                        MouseArea {
                            anchors.fill: parent
                            anchors.margins: -8
                            cursorShape: Qt.PointingHandCursor
                            onClicked: popup.dismiss(card.modelData.id)
                        }
                    }
                }
            }
        }
    }
}
