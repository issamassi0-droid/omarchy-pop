import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Hyprland
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "pop.workspace"

  function workspaceById(id) {
    var values = Hyprland.workspaces.values
    for (var i = 0; i < values.length; i++) {
      if (values[i].id === id) return values[i]
    }
    return null
  }

  function workspaceIds() {
    var ids = [1, 2, 3, 4, 5]
    var values = Hyprland.workspaces.values
    for (var i = 0; i < values.length; i++) {
      var id = values[i].id
      if (id > 0 && id <= 10 && ids.indexOf(id) === -1) ids.push(id)
    }
    ids.sort(function(a, b) { return a - b })
    return ids
  }

  function focusWorkspace(id) {
    if (!root.bar) return
    root.bar.run("hyprctl dispatch " + Util.shellQuote("hl.dsp.focus({ workspace = \"" + id + "\" })"))
  }

  property int hoveredWsId: 0
  property var moduleItems: []

  function triggerPress(button) {
    focusWorkspace(hoveredWsId || currentWsId)
  }

  function registerAllModules() {
    if (!root.bar) return
    for (var i = 0; i < moduleItems.length; i++)
      root.bar.registerClickTarget(moduleItems[i])
  }

  onBarChanged: registerAllModules()

  readonly property int currentWsId: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : 1
  readonly property color fg: root.bar ? root.bar.barForeground : Color.foreground
  readonly property color accent: root.bar ? root.bar.urgent : Color.bar.active
  readonly property string ff: root.bar ? root.bar.fontFamily : Style.font.family

  readonly property int wsCount: workspaceIds().length
  readonly property int pillW: 18
  readonly property int focusedW: 34
  readonly property int pillH: 16
  readonly property int pillGap: 3

  readonly property color bgColor: Qt.rgba(45/255, 65/255, 70/255, 0.28)
  readonly property color bgBorder: Qt.rgba(65/255, 95/255, 105/255, 0.55)
  readonly property color hoverColor: Qt.rgba(45/255, 65/255, 70/255, 0.42)
  readonly property color hoverBorder: Qt.rgba(75/255, 110/255, 120/255, 0.65)
  readonly property color focusColor: Qt.rgba(180/255, 85/255, 50/255, 0.18)
  readonly property color focusBorder: Qt.rgba(195/255, 100/255, 60/255, 0.35)
  readonly property color urgentColor: "#f38ba8"
  readonly property color urgentBorder: "#ff6b8a"
  readonly property color glowColor: "#efae64"
  readonly property color glowColorDim: Qt.rgba(239/255, 174/255, 100/255, 0.4)

  implicitWidth: wsCount * pillW + (wsCount - 1) * pillGap + focusedW - pillW
  implicitHeight: pillH + 8

  Rectangle {
    anchors.fill: parent
    anchors.topMargin: -2
    radius: 5
    color: "transparent"

    Row {
      anchors.verticalCenter: parent.verticalCenter
      anchors.left: parent.left
      spacing: root.pillGap

      Repeater {
        model: root.workspaceIds()

        delegate: Rectangle {
          id: pill
          required property int modelData

          readonly property var ws: root.workspaceById(modelData)
          readonly property bool occupied: ws !== null && ws.toplevels.values.length > 0
          readonly property bool focused: root.currentWsId === modelData
          readonly property bool hovered: hArea.containsMouse

          width: focused ? root.focusedW : root.pillW
          height: root.pillH
          radius: 5
          color: focused ? root.focusColor : (hovered ? root.hoverColor : root.bgColor)
          border.width: focused ? 1 : 1
          border.color: focused ? root.focusBorder : (hovered ? root.hoverBorder : root.bgBorder)

          Behavior on width { NumberAnimation { duration: 100; easing.type: Easing.OutCubic } }
          Behavior on height { NumberAnimation { duration: 100; easing.type: Easing.OutCubic } }
          Behavior on color { ColorAnimation { duration: 100 } }
          Behavior on border.color { ColorAnimation { duration: 100 } }

          Text {
            anchors.centerIn: parent
            text: pill.modelData === 10 ? "0" : String(pill.modelData)
            color: pill.focused ? "#e0a850" : (pill.occupied ? "#359a8d" : "#909080")
            font.family: root.ff
            font.pixelSize: Style.font.body
            font.bold: false
            renderType: Text.NativeRendering

            Behavior on color { ColorAnimation { duration: 100 } }
          }

          MouseArea {
            id: hArea
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
            cursorShape: Qt.PointingHandCursor
            onEntered: root.hoveredWsId = pill.modelData
            onExited: { if (root.hoveredWsId === pill.modelData) root.hoveredWsId = 0 }
            onClicked: root.focusWorkspace(pill.modelData)
          }

          Component.onCompleted: {
            root.moduleItems = root.moduleItems.concat([pill])
            if (root.bar) root.bar.registerClickTarget(pill)
          }
          Component.onDestruction: {
            root.moduleItems = root.moduleItems.filter(function(x) { return x !== pill })
            if (root.bar) root.bar.unregisterClickTarget(pill)
          }
        }
      }
    }
  }
}
