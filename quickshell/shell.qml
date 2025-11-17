//@pragma UseQApplication

import QtQuick
import Quickshell
import qs.bar
import qs.bar.placeholders
import qs.widgets

ShellRoot {
    id: root

    Loader {
        active: true
        sourceComponent: Bar {}
    }

    Loader {
        active: true
        sourceComponent: Bottombar {}
    }

    Loader {
        active: true
        sourceComponent: Rightbar {}
    }

    Loader {
        active: true
        sourceComponent: Leftbar {}
    }

    Loader {
        active: true
        sourceComponent: Mask {}
    }
}