pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: root

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    readonly property string time: {
        var d = clock.date;
        var h = d.getHours() % 12;
        if (h === 0)
            h = 12;
        var m = ("0" + d.getMinutes()).slice(-2);
        var suffix = d.getHours() < 12 ? "am" : "pm";
        return h + ":" + m + " " + suffix;
    }

    readonly property string date: Qt.formatDateTime(clock.date, "ddd, MMM d")
}
