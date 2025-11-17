import Quickshell
import QtQuick

PanelWindow {
    anchors {
        left: true
        top: true
        bottom: true
    }

    color: "transparent"
    implicitWidth: 7  // wider so the button fits

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        // --- Simple Button ---
        Rectangle {
            id: button
            width: 7
            height: 240
            anchors.centerIn: parent
            color: "transparent"

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    console.log("You fucking clicked me.")
                    
                }
                onEntered: {
                    console.log("Hi Cami!")
                }
                onExited: {
                    console.log("Bye Cami!")
                }
            }
        }
    }
}
