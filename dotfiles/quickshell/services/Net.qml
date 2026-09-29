pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Networking

Singleton {
    id: root

    readonly property var devices: Networking.devices?.values ?? []
    readonly property var connectedDevice: root.devices.find(d => d && d.connected) ?? null
    readonly property bool connected: root.connectedDevice !== null
    readonly property bool isWifi: root.connectedDevice?.type === DeviceType.Wifi
    readonly property var wifiDevice: root.devices.find(d => d && d.type === DeviceType.Wifi) ?? null
    readonly property var activeWifi: root.isWifi ? (root.wifiDevice.networks?.values.find(n => n && n.connected) ?? null) : null
    readonly property string name: root.activeWifi?.name ?? root.connectedDevice?.name ?? ""
    readonly property real strength: root.activeWifi?.signalStrength ?? 0

    readonly property string icon: {
        if (!root.connected)
            return "network-wireless-offline-symbolic";
        if (!root.isWifi)
            return "network-wired-symbolic";
        if (root.strength > 0.66)
            return "network-wireless-signal-excellent-symbolic";
        if (root.strength > 0.4)
            return "network-wireless-signal-good-symbolic";
        if (root.strength > 0.2)
            return "network-wireless-signal-ok-symbolic";
        return "network-wireless-signal-weak-symbolic";
    }
}
