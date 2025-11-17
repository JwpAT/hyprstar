import Quickshell
import QtQuick
import QtQuick.Effects
import qs.modules

PanelWindow {
    id: topBar
    implicitHeight: 36
    color: "transparent"

    anchors {
        top: true
        left: true
        right: true
    }

    // -------- LEFT --------

    Row {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        spacing: 5
        padding: 5
        DateTime {}
        Battery {}
        }
    // ---------- CENTER ---------

    Workspaces {
        id: workspaces
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
    }

    // --------- RIGHT -------

}
