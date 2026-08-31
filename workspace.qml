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
    var ids = [1, 2, 3, 4, 5, 6, 7]
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
  property int _pillCounter: 0

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
  readonly property int pillW: 20
  readonly property int focusedW: 34
  readonly property int pillH: 18
  readonly property int pillGap: 1

  readonly property color bgColor: Qt.rgba(44/255, 43/255, 42/255, 0.45)
  readonly property color bgBorder: Qt.rgba(235/255, 160/255, 60/255, 0.2)
  readonly property color hoverColor: Qt.rgba(25/255, 40/255, 45/255, 0.7)
  readonly property color hoverBorder: Qt.rgba(60/255, 90/255, 100/255, 1.0)
  readonly property color occupiedColor: Qt.rgba(239/255, 174/255, 100/255, 0.13)
  readonly property color occupiedBorder: Qt.rgba(235/255, 160/255, 60/255, 0.38)
  readonly property color focusColor: Qt.rgba(225/255, 60/255, 25/255, 0.17)
  readonly property color focusBorder: Qt.rgba(235/255, 75/255, 35/255, 0.45)
  readonly property color urgentColor: "#ff0000"
  readonly property color urgentBorder: "#ffa500"
  readonly property color glowColor: "#efae64"
  readonly property color glowColorDim: Qt.rgba(239/255, 174/255, 100/255, 0.4)

  implicitWidth: wsCount * pillW + (wsCount - 1) * pillGap + focusedW - pillW
  implicitHeight: pillH + 8

  Rectangle {
    anchors.fill: parent
    anchors.topMargin: 0
    radius: 3
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
          readonly property string _pillId: String(modelData)

          readonly property var ws: root.workspaceById(modelData)
          readonly property bool occupied: ws !== null && ws.toplevels.values.length > 0
          readonly property bool urgent: ws !== null && ws.urgent
          readonly property bool focused: root.currentWsId === modelData
          readonly property bool hovered: hArea.containsMouse

          width: focused ? root.focusedW : root.pillW
          height: root.pillH
          radius: 1
          color: urgent ? root.urgentColor : (focused ? root.focusColor : (occupied ? root.occupiedColor : (hovered ? root.hoverColor : root.bgColor)))
          border.width: focused ? 1 : 1
          border.color: urgent ? root.urgentBorder : (focused ? root.focusBorder : (occupied ? root.occupiedBorder : (hovered ? root.hoverBorder : root.bgBorder)))

          Behavior on width { NumberAnimation { duration: 50; easing.type: Easing.OutCubic } }
          Behavior on height { NumberAnimation { duration: 50; easing.type: Easing.OutCubic } }
          Behavior on color { ColorAnimation { duration: 50 } }
          Behavior on border.color { ColorAnimation { duration: 50 } }

          Text {
            anchors.centerIn: parent
            text: pill.modelData === 10 ? "0" : String(pill.modelData)
            color: pill.focused ? "#e0a45f" : (pill.occupied ? "#efae64" : "#d1ccc3")
            font.family: root.ff
            font.pixelSize: Style.font.body
            font.bold: false
            renderType: Text.NativeRendering

            Behavior on color { ColorAnimation { duration: 50 } }
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
            root.moduleItems = root.moduleItems.concat([{id: _pillId, ref: pill}])
            if (root.bar) root.bar.registerClickTarget(pill)
          }
          Component.onDestruction: {
            root.moduleItems = root.moduleItems.filter(function(x) { return x.id !== _pillId })
            if (root.bar) root.bar.unregisterClickTarget(pill)
          }
        }
      }
    }
  }
}
