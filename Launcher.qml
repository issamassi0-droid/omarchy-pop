// Launcher.qml
import QtQuick 2.15
import QtQuick.Layouts 1.15
import Quickshell 1.0
import "omarchy-pop" as Theme

Rectangle {
    id: bar
    color: Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, Theme.barOpacity)
    border.width: Theme.borderWidth
    border.color: Theme.border
    radius: Theme.borderRadius
    
    RowLayout {
        anchors {
            fill: parent
            margins: Theme.padding
        }
        spacing: Theme.spacing
        
        // Workspaces
        Workspaces {
            Layout.fillWidth: true
        }
        
        // Clock
        Clock {
            Layout.alignment: Qt.AlignRight
        }
        
        // System Tray
        SystemTray {
            Layout.alignment: Qt.AlignRight
        }
    }
}