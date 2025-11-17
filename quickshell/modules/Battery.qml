import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

Item {
    id: root

    // The module reports its real size correctly
    implicitHeight: 24
    implicitWidth: bg.implicitWidth

    // Colors
    property color normalFillColor: "#b4befe"
    property color lowFillColor: "#f38ba8"
    property color chargingFillColor: '#a6e3a1'
    property color bgColor: "#313244"
    property color textColor: '#f1f5ff'

    // Battery values
    property int batteryPercent: 87
    property string batteryStatus: "Unknown"
    property string lastStatus: "Unknown"

    // Startup animation control
    property bool startupDone: false
    property real animatedPercent: 100.0

    onBatteryPercentChanged: {
        if (!startupDone) {
            animPercent.from = 100
            animPercent.to = batteryPercent
            animPercent.running = true
            startupDone = true
        } else {
            animatedPercent = batteryPercent
        }
    }

    onBatteryStatusChanged: {
        if (lastStatus !== batteryStatus) {
            icon.scale = 0.7
            iconPop.from = 0.7
            iconPop.to = 1.0
            iconPop.running = true
        }
        lastStatus = batteryStatus
    }

    NumberAnimation {
        id: animPercent
        target: root
        property: "animatedPercent"
        duration: 700
        easing.type: Easing.InOutQuad
    }

    NumberAnimation {
        id: iconPop
        target: icon
        property: "scale"
        duration: 180
        easing.type: Easing.OutBack
    }

    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: {
            readerPercent.running = true
            readerStatus.running = true
        }
    }

    Process {
        id: readerPercent
        running: true
        command: ["bash", "-c", "cat /sys/class/power_supply/BAT0/capacity"]

        stdout: StdioCollector {
            onStreamFinished: {
                let pct = parseInt(this.text.trim())
                if (!isNaN(pct)) root.batteryPercent = pct
            }
        }
    }

    Process {
        id: readerStatus
        running: true
        command: ["bash", "-c", "cat /sys/class/power_supply/BAT0/status"]

        stdout: StdioCollector {
            onStreamFinished: root.batteryStatus = this.text.trim()
        }
    }

    // BACKGROUND PILL (with proper implicit size for layout engines)
    ClippingRectangle {
        id: bg
        anchors.centerIn: parent
        height: 24
        radius: height / 2
        color: bgColor

        width: contentRow.implicitWidth + 16
        implicitWidth: width    // <-- critical fix

        // FILL BAR
        Rectangle {
            id: fill
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            width: parent.width * (animatedPercent / 100.0)

            radius: 0
            color: batteryStatus === "Charging"
                   ? chargingFillColor
                   : (batteryPercent <= 20 ? lowFillColor : normalFillColor)

            Behavior on width {
                NumberAnimation { duration: 450; easing.type: Easing.InOutQuad }
            }

            Behavior on color {
                ColorAnimation { duration: 200; easing.type: Easing.InOutQuad }
            }
        }

        // CONTENT
        Row {
            id: contentRow
            anchors.centerIn: parent
            spacing: 6

            Text {
                id: icon
                text: batteryStatus === "Charging" ? "󰚥" : ""
                font.pixelSize: 14
                color: textColor
            }

            Text {
                text: batteryPercent + "%"
                font.pixelSize: 14
                color: textColor
            }
        }
    }
}
