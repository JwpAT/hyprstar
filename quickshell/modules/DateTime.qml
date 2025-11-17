import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root
    implicitHeight: bg.implicitHeight
    implicitWidth: bg.implicitWidth

    // --- Background ---
    Rectangle {
        id: bg
        radius: height / 2
        color: "#313244"
        border.color: "transparent"
        border.width: 0
        anchors.fill: parent
        implicitHeight: timeText.implicitHeight + 6
        implicitWidth: timeText.implicitWidth + 12
    }

    // --- Time + Date Text ---
    Text {
        id: timeText
        anchors.centerIn: parent
        color: "#f1f5ff"
        font.pointSize: 10
        text: currentTime
    }

    // --- Logic ---
    property string currentTime: ""

    function updateDateTime() {
        const d = new Date()
        // HH = 24h, dddd = full weekday, MM/dd = zero-padded month/day
        currentTime = Qt.formatDateTime(d, "HH:mm • ddd, MM/dd")
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: updateDateTime()
    }

    Component.onCompleted: updateDateTime()
}
