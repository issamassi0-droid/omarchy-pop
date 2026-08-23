import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Hyprland
import qs.Commons
import qs.Ui

// C-Shell-Fusion style workspace numbers, ported from c-shell.qml into the
// Omarchy bar widget framework. Colors track the shell theme instead of the
// dock's hardcoded Adwaita palette:
//   occupied number / active bubble / active module  -> Color.accent
//   empty number / hover border                   -> bar foreground
//   module surface / border                       -> alpha of the foreground
// Focused workspace shows a green bubble; every other occupied (activated)
// workspace shows a red bubble.
BarWidget {
  id: root
  moduleName: "pop.workspaces"

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

    ids.sort(function(left, right) { return left - right })
    return ids
  }

  function focusWorkspace(id) {
    if (!root.bar) return
    root.bar.run("hyprctl dispatch " + Util.shellQuote("hl.dsp.focus({ workspace = \"" + id + "\" })"))
  }

  // The bar host's modulePointer only shows a hand cursor when the point under
  // the cursor is a click target. Its fallback (moduleClickTargetAt) returns
  // slot.activeItem when that item is clickable, which is how WidgetButton
  // plugins get the hand cursor across their whole slot. Expose triggerPress
  // on the widget root so the fallback matches us too.
  property int hoveredWsId: 0

  function triggerPress(button) {
    var id = root.hoveredWsId
    if (!id) id = root.currentWsId
    root.focusWorkspace(id)
  }

  // The bar host only shows a hand cursor over a module when that module is a
  // registered click target (WidgetButton does this through its own sync). A
  // plain MouseArea inside the widget is covered by the slot's modulePointer,
  // so register each workspace module the same way.
  property var moduleItems: []

  function registerAllModules() {
    if (!root.bar) return
    for (var i = 0; i < root.moduleItems.length; i++) {
      root.bar.registerClickTarget(root.moduleItems[i])
    }
    console.log("[workspaces] registerAllModules ran, modules:", root.moduleItems.length, "targets:", root.bar.clickTargets ? root.bar.clickTargets.length : -1)
  }

  onBarChanged: registerAllModules()

  // --- Reliable focus tracker (from c-shell) ---
  readonly property int currentWsId: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : 1

  // --- Theme colors lifted off the bar host (BarWidget has no foreground) ---
  readonly property color foregroundColor: root.bar ? root.bar.barForeground : Color.foreground
  readonly property color accentColor: root.bar ? root.bar.urgent : Color.bar.active
  readonly property string fontFamily: root.bar ? root.bar.fontFamily : Style.font.family

  // --- Fusion module geometry (mid size, scales with font/bar) ---
  readonly property int moduleWidth: Math.max(14, Math.round(root.barSize - 7))
  readonly property int moduleHeight: Math.max(15, Math.round(root.barSize * 0.72))
  readonly property int moduleGap: Style.spacing.xxs
  readonly property int bubbleSize: Math.max(6, Math.round(moduleHeight - 9))
  readonly property int bubbleRadius: Math.round(bubbleSize / 2)
  readonly property int numberSize: Math.max(8, Math.round(moduleHeight * 0.62))
  readonly property real trailingGap: 2
  readonly property int moduleCount: root.workspaceIds().length
  readonly property int verticalNudge: 1

  // Surfaces and borders use the bar foreground with higher alphas than the
// [controls] tokens so the modules read clearly against the bar background.
  readonly property color surfaceColor: Util.alpha(root.foregroundColor, 0.08)
  readonly property color surfaceHoverColor: Util.alpha(root.foregroundColor, 0.16)
  readonly property color borderColor: Util.alpha(root.foregroundColor, 0.45)
  readonly property color borderHoverColor: root.accentColor
  readonly property color neonRed: "#e6e3dd"
  readonly property color neonGreen: "#efae64"

  function mixWithBlack(color, amount) {
    return Qt.rgba(color.r * (1 - amount), color.g * (1 - amount), color.b * (1 - amount), color.a)
  }

  readonly property color numberFocusColor: root.neonGreen
  readonly property color numberActiveColor: root.bar.background

  // Focused workspace: green bubble @ 0.8, green border @ 0.4
  readonly property color focusSurfaceColor: Util.alpha(root.neonGreen, 0.1)
  readonly property color focusBubbleColor: Util.alpha(root.neonGreen, 0.5)
  readonly property color focusBorderColor: Util.alpha(root.neonGreen, 0.8)

  // Activated workspace not focused (occupied): red, same alphas
  readonly property color activeSurfaceColor: Util.alpha(root.neonRed, 0.05)
  readonly property color activeBubbleColor: Util.alpha(root.neonRed, 0.08)
  readonly property color activeBorderColor: Util.alpha(root.neonRed, 0.3)

  implicitWidth: root.vertical ? moduleWidth : moduleCount * moduleWidth + moduleGap * (moduleCount - 1) + trailingGap
  implicitHeight: root.vertical ? moduleCount * moduleHeight + moduleGap * (moduleCount - 1) : moduleHeight

  Loader {
    x: 0
    y: root.vertical ? 0 : Math.round((root.barSize - root.moduleHeight) / 2)
    width: parent.width
    height: root.vertical ? parent.height : root.moduleHeight
    sourceComponent: root.vertical ? verticalStack : horizontalRow
  }

  Component {
    id: horizontalRow

    Row {
      spacing: root.moduleGap

      Repeater {
        model: root.workspaceIds()
        delegate: FusionModule {}
      }
    }
  }

  Component {
    id: verticalStack

    Column {
      spacing: root.moduleGap

      Repeater {
        model: root.workspaceIds()
        delegate: FusionModule {}
      }
    }
  }

  component FusionModule: Item {
    id: module
    required property int modelData

    readonly property int wsId: modelData
    readonly property var workspace: root.workspaceById(wsId)
    readonly property bool occupied: workspace !== null && workspace.toplevels.values.length > 0
    readonly property bool focused: root.currentWsId === wsId
    readonly property bool active: !module.focused && module.occupied

    function triggerPress(button) {
      root.focusWorkspace(module.wsId)
    }

    Component.onCompleted: {
      root.moduleItems = root.moduleItems.concat([module])
      if (root.bar) root.bar.registerClickTarget(module)
      var inTargets = root.bar && root.bar.clickTargets ? root.bar.clickTargets.indexOf(module) !== -1 : false
      console.log("[workspaces] module", module.wsId, "created, registered:", inTargets, "barClickTargets:", root.bar ? root.bar.clickTargets.length : -1)
    }

    Component.onDestruction: {
      root.moduleItems = root.moduleItems.filter(function(item) { return item !== module })
      if (root.bar) root.bar.unregisterClickTarget(module)
    }

    width: root.moduleWidth
    height: root.moduleHeight

    // Soft glow shadow behind active/focused workspace surfaces
    MultiEffect {
      anchors.fill: parent
      visible: module.focused || module.active
      source: moduleSurface
      shadowEnabled: true
      shadowColor: module.focused ? root.neonGreen : root.neonRed
      shadowBlur: 0.6
      shadowOpacity: 0.7
      shadowVerticalOffset: 0
      shadowHorizontalOffset: 0
    }

    Rectangle {
      id: moduleSurface
      anchors.fill: parent
      radius: 5
      color: module.focused ? root.focusSurfaceColor : (module.active ? root.activeSurfaceColor : (hoverArea.containsMouse ? root.surfaceHoverColor : root.surfaceColor))
      border.color: module.focused ? root.focusBorderColor : (hoverArea.containsMouse ? root.borderHoverColor : (module.active ? root.activeBorderColor : root.borderColor))
      border.width: module.focused || module.active ? 1 : 1

      Behavior on color { ColorAnimation { duration: 150 } }
      Behavior on border.color { ColorAnimation { duration: 150 } }

      // Soft radial glow behind active/focused workspace bubbles
      Item {
        visible: module.focused || module.active
        anchors.fill: parent
        readonly property color glowColor: module.focused ? root.neonGreen : root.neonRed
        readonly property int cx: module.width / 2
        readonly property int cy: module.height / 2

        Rectangle {
          width: root.bubbleSize + 12
          height: root.bubbleSize + 12
          radius: width / 2
          color: Util.alpha(parent.glowColor, 0.05)
          x: Math.round(parent.cx - width / 2)
          y: Math.round(parent.cy - height / 2)
        }
        Rectangle {
          width: root.bubbleSize + 6
          height: root.bubbleSize + 6
          radius: width / 2
          color: Util.alpha(parent.glowColor, 0.1)
          x: Math.round(parent.cx - width / 2)
          y: Math.round(parent.cy - height / 2)
        }
        Rectangle {
          width: root.bubbleSize
          height: root.bubbleSize
          radius: root.bubbleRadius
          color: Util.alpha(parent.glowColor, 0.2)
          x: Math.round(parent.cx - width / 2)
          y: Math.round(parent.cy - height / 2)
        }
      }

      // Active bubble (number hidden, like c-shell)
      Rectangle {
        visible: module.focused || module.active
        width: root.bubbleSize
        height: root.bubbleSize
        radius: root.bubbleRadius
        color: module.focused ? root.focusBubbleColor : root.activeBubbleColor
        x: Math.round((module.width - width) / 2)
        y: Math.round((module.height - height) / 2)
      }

      // Number
      Text {
        id: numberLabel
        x: Math.round((module.width - width) / 2)
        y: Math.round((module.height - height) / 2)
        text: module.wsId === 10 ? "0" : String(module.wsId)
        renderType: Text.QtRendering
        color: module.focused ? root.numberFocusColor : (module.active ? root.numberActiveColor : (module.occupied ? root.accentColor : root.foregroundColor))
        opacity: {
          if (module.focused) return 0.0
          if (hoverArea.containsMouse) return 1.0
          if (module.occupied) return 1.0
          return 0.9
        }
        font {
          family: root.fontFamily
          weight: module.occupied ? Font.Bold : Font.Normal
          pixelSize: root.numberSize
        }

        Behavior on color { ColorAnimation { duration: 150 } }
        Behavior on opacity { NumberAnimation { duration: 150 } }
      }

      MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        cursorShape: Qt.PointingHandCursor
        onEntered: {
          root.hoveredWsId = module.wsId
          console.log("[workspaces] hover enter ws", module.wsId)
        }
        onExited: {
          if (root.hoveredWsId === module.wsId) root.hoveredWsId = 0
          console.log("[workspaces] hover exit ws", module.wsId)
        }
        onClicked: root.focusWorkspace(module.wsId)
      }
    }
  }
}
