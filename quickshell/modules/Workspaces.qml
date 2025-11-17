import Quickshell
import Quickshell.Hyprland
import QtQuick

Item {
    id: root
    property int maxWorkspaces: 8

    // --- Sizes (dot/pill logic like example) ---
    property int sizeSmall: 12
    property int sizeMedium: 14
    property int sizeLarge: 28  // focused pill width

    implicitWidth: bg.implicitWidth
    implicitHeight: bg.implicitHeight

    Rectangle {
        id: bg
        color: "#313244"
        radius: height / 2
        anchors.centerIn: parent

        implicitWidth: row.implicitWidth + 16
        implicitHeight: row.implicitHeight + 12

        Row {
            id: row
            spacing: 5
            anchors.centerIn: parent

            Repeater {
                model: root.maxWorkspaces

                Rectangle {
                    id: wsBox
                    property int wid: index + 1

                    // These mirror their prefWidth/prefHeight logic
                    property bool isFocused:
                        Hyprland.focusedWorkspace
                        && Hyprland.focusedWorkspace.id === wid

                    property bool isOccupied: Hyprland.isWorkspaceOccupied(wid)

                    // --- THEIR METHOD: SIZES COME FROM PROPERTIES ---
                    property int prefHeight: 12

                    property int prefWidth:
                        isFocused ? root.sizeLarge
                        : isOccupied ? root.sizeMedium
                        : root.sizeSmall

                    width: prefWidth
                    height: prefHeight
                    radius: prefHeight / 2

                    // --- Smooth width animation like theirs ---
                    Behavior on width {
                        NumberAnimation {
                            duration: 400
                            easing.type: Easing.OutCubic
                        }
                    }

                    property color workspaceStateColor: {
                        if (isFocused)
                            return "#b4befe"
                        if (isOccupied)
                            return Qt.darker('#ffffff', 1.4)
                        return "#a2a2a2"
                    }

                    color: workspaceStateColor

                    // Border logic (you already had one)
                    border.width: isOccupied ? 2 : 1
                    border.color: isFocused ? "#b4befe" : "#a2a2a2"

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }

                    // --- Hover overlay identical to theirs ---
                    property bool hovered: false

                    Rectangle {
                        anchors.fill: parent
                        radius: parent.radius
                        color: "#b4befe"
                        opacity: wsBox.hovered ? 0.18 : 0
                        Behavior on opacity { NumberAnimation { duration: 150 } }
                    }

                    // --- Bounce animation from your version ---
                    SequentialAnimation {
                        id: bounceAnim
                        running: false
                        loops: 1

                        NumberAnimation { target: wsBox; property: "scale"; to: 1.20; duration: 120; easing.type: Easing.OutQuad }
                        NumberAnimation { target: wsBox; property: "scale"; to: 0.92; duration: 120; easing.type: Easing.InOutQuad }
                        NumberAnimation { target: wsBox; property: "scale"; to: 1.0; duration: 130; easing.type: Easing.OutBounce }
                    }

                    Connections {
                        target: Hyprland
                        onFocusedWorkspaceChanged: {
                            if (wsBox.isFocused) {
                                wsBox.scale = 1
                                bounceAnim.start()
                            }
                        }
                    }

                    // Mouse handling
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onEntered: wsBox.hovered = true
                        onExited: wsBox.hovered = false
                        onClicked: Hyprland.dispatch("workspace " + wsBox.wid)
                    }
                }
            }
        }
    }
}
