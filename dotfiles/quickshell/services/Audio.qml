pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    readonly property var sink: Pipewire.defaultAudioSink

    PwObjectTracker {
        objects: root.sink ? [root.sink] : []
    }

    readonly property bool muted: root.sink?.audio?.muted ?? false
    readonly property int percent: Math.round((root.sink?.audio?.volume ?? 0) * 100)

    readonly property string icon: {
        if (root.muted || root.percent === 0)
            return "audio-volume-muted-symbolic";
        if (root.percent > 66)
            return "audio-volume-high-symbolic";
        if (root.percent > 33)
            return "audio-volume-medium-symbolic";
        return "audio-volume-low-symbolic";
    }
}
