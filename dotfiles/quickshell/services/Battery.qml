pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.UPower

Singleton {
    id: root

    readonly property var device: UPower.displayDevice
    readonly property bool ready: root.device?.ready ?? false
    readonly property real percent: Math.round((root.device?.percentage ?? 0) * 100)
    readonly property bool charging: root.device?.state === UPowerDeviceState.Charging
    readonly property bool full: root.device?.state === UPowerDeviceState.FullyCharged

    readonly property string icon: {
        var base;
        if (root.charging)
            base = root.percent > 85 ? "battery-full-charging" : root.percent > 55 ? "battery-good-charging" : root.percent > 25 ? "battery-low-charging" : "battery-caution-charging";
        else
            base = root.percent > 90 ? "battery-full" : root.percent > 55 ? "battery-good" : root.percent > 25 ? "battery-low" : "battery-caution";
        return base + "-symbolic";
    }
}
