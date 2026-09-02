// Theme.qml
// Omarchy Theme - Modified Pop for Quickshell
pragma Singleton
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt.labs.settings 1.0

QtObject {
    // Base Colors
    readonly property color background: "#2c2b2a"
    readonly property color foreground: "#d1ccc3"

    // Surface Colors
    readonly property color surface0: "#2c2b2a"
    readonly property color surface1: "#505048"
    readonly property color surface2: "#686860"
    readonly property color surface3: "#909080"

    // Border Colors (1px, #efae64 with alpha)
    readonly property color border: Qt.rgba(239/255, 174/255, 100/255, 0.6)
    readonly property color borderActive: Qt.rgba(239/255, 174/255, 100/255, 0.85)
    readonly property color borderInactive: Qt.rgba(239/255, 174/255, 100/255, 0.4)

    // Text Colors
    readonly property color textPrimary: "#d1ccc3"
    readonly property color textSecondary: "#909080"
    readonly property color textMuted: "#686860"

    // Accent Colors
    readonly property color accent: "#d2cbbd"
    readonly property color accentAlpha: Qt.rgba(210/255, 203/255, 189/255, 0.6)

    // UI Element Colors
    readonly property color buttonBackground: surface1
    readonly property color buttonHover: surface2
    readonly property color buttonActive: surface3

    readonly property color selectionBackground: surface3
    readonly property color selectionText: foreground

    // Shadow
    readonly property color shadow: Qt.rgba(0, 0, 0, 0.267)

    // Typography
    // readonly property int fontSize: 13  // duplicated, removed
    // readonly property string fontFamily: customFont.name !== "" ? customFont.name : "Hermes Maia T4"  // removed – using system default

    // Layout
    readonly property int borderRadius: 0
    readonly property int borderWidth: 1
    readonly property int spacing: 4
    readonly property int padding: 8

    // Bar specific
    readonly property int barHeight: 32
    readonly property int barOpacity: 0.85

    // Panel specific
    readonly property int panelRadius: 8
    readonly property real panelOpacity: 0.95
}
ApplicationWindow {
    visible: true
    width: 800
    height: 200
    title: qsTr("Quickshell Custom Font Demo")

    /* Set the global Qt Quick theme font */
    theme: Theme {
        /* <--- change font family or size here ---- */
        font.family: "Monolisa"
        font.pixelSize: 14
    }

    // Example text to show the font
    Text {
        anchors.centerIn: parent
        text: "Hello – Font is MonoLisa"
    }
}
