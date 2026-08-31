import QtQuick
import qs.Ui
import qs.Commons

BarWidget {
  id: root
  moduleName: "pop.mainmenu"

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  Item {
    id: button
    anchors.fill: parent
    implicitWidth: Math.max(12, label.implicitWidth + Style.spaceReal(7.5) * 2)
    implicitHeight: Style.bar.sizeHorizontal

    Text {
      id: label
      anchors.centerIn: parent
      anchors.verticalCenterOffset: 2
      text: "\ue900"
      font.family: "omarchy"
      font.pixelSize: Style.font.body
    -        color: root.bar ? root.bar.barForeground : Color.foreground
    +        // fade opacity on hover
    +        property bool hovered: false
    +        color: root.bar ? root.bar.barForeground : Color.foreground
    +        opacity: hovered ? 0.5 : 1.0
    +        Behavior on opacity { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
    }
    @@
    -      MouseArea {
    -        anchors.fill: parent
    -        acceptedButtons: Qt.LeftButton | Qt.RightButton
    -        cursorShape: Qt.PointingHandCursor
    -        onClicked: function(mouse) {
    -          if (!root.bar) return
    -          if (mouse.button === Qt.RightButton) root.bar.run("xdg-terminal-exec")
    -          else root.bar.run("omarchy-shell shell toggle omarchy.menu '{\"menu\":\"root\"}'")
    -        }
    -      }
    +      MouseArea {
    +        anchors.fill: parent
    +        acceptedButtons: Qt.LeftButton | Qt.RightButton
    +        cursorShape: Qt.PointingHandCursor
    +        hoverEnabled: true
    +        onEntered: label.hovered = true
    +        onExited: label.hovered = false
    +        onClicked: function(mouse) {
    +          if (!root.bar) return
    +          if (mouse.button === Qt.RightButton) root.bar.run("xdg-terminal-exec")
    +          else root.bar.run("omarchy-shell shell toggle omarchy.menu '{\"menu\":\"root\"}'")
    +        }
    +      }

  }
}
