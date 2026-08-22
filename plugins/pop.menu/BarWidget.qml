import QtQuick
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "pop.menu"

  // Green, fully opaque, only when hovered.
  implicitWidth: row.implicitWidth
  implicitHeight: row.implicitHeight

  Row {
    id: row
    spacing: Style.space(4)

    WidgetButton {
      id: button
      width: button.implicitWidth
      height: button.implicitHeight
      bar: root.bar
      text: "\ue900"
      fontFamily: "omarchy"
      fontSize: 15
      horizontalMargin: 7.5
      active: button.tooltipHovered
      activeColor: "#a8d23a"
      onPressed: function(button) {
        if (!root.bar) return
        if (button === Qt.RightButton) root.bar.run("xdg-terminal-exec")
        else root.bar.run("omarchy-shell shell toggle pop.menu '{\"menu\":\"root\"}'")
      }
    }

    Text {
      id: separator
      text: "\u2502"
      rotation: root.vertical ? 90 : 0
      color: root.bar ? root.bar.barForeground : Color.foreground
      opacity: 0.35
      font.family: root.bar ? root.bar.fontFamily : Style.font.family
      font.pixelSize: Math.max(8, Math.round(Style.font.body * 0.85))
      verticalAlignment: Text.AlignVCenter
      anchors.verticalCenter: parent.verticalCenter
    }
  }
}