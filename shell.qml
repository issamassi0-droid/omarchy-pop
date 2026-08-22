// shell.qml
import QtQuick 2.15
import Quickshell 1.0
import Quickshell.Wayland 1.0
import "omarchy-pop" as Theme

ShellRoot {
    id: root
    color: Theme.background
    
    // Bar at the top
    Bar {
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: Theme.barHeight
    }
    
    // Background with blur
    Rectangle {
        anchors.fill: parent
        color: Theme.background
        opacity: Theme.panelOpacity
        
        // Optional: Add wallpaper background
        // Image { source: "wallpaper.png"; fillMode: Image.PreserveAspectCrop }
    }
}