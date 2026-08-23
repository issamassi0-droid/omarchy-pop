#!/bin/bash
# Pop theme extras (also handles foggy/sepia), applied on `omarchy theme set`.
# - Copies the theme's looknfeel.lua (orange #efae64 window border — 2px, 0.75
#   alpha — with square corners) into the active Hyprland config.
# - Deploys the theme-bundled workspace widget (root workspace.qml +
#   workspace.manifest.json) into the live plugin dir as pop.workspace.
# - Switches the bar to the stock omarchy.bar and the left widgets to
#   omarchy.menu + pop.workspace, placing the workspace indicator inline
#   directly after the menu icon.
# - Removes the now-unused pop.bar / pop.menu / pop.workspaces plugins.
# - Restores the default bar for any other theme.
set -u

CURRENT_THEME_DIR="$HOME/.local/state/omarchy/current/theme"
HYPR_CONF_DIR="$HOME/.config/hypr"
PLUGIN_DIR="$HOME/.config/omarchy/plugins"

is_custom_theme() {
  omarchy theme current 2>/dev/null | grep -qiE "foggy|sepia|pop"
}

# Deploy the theme-bundled workspace widget (a single BarWidget + manifest
# kept at the theme root) into the live plugin dir as pop.workspace.
deploy_workspace() {
  local src_dir="$CURRENT_THEME_DIR"
  local dst="$PLUGIN_DIR/pop.workspace"
  [[ -f "$src_dir/workspace.qml" && -f "$src_dir/workspace.manifest.json" ]] || return 1
  rm -rf "$dst"
  mkdir -p "$dst"
  cp "$src_dir/workspace.qml" "$dst/workspace.qml"
  cp "$src_dir/workspace.manifest.json" "$dst/manifest.json"
  return 0
}

# Remove the old pop.* plugins so they don't linger or conflict.
cleanup_old_plugins() {
  rm -rf "$PLUGIN_DIR/pop.bar" "$PLUGIN_DIR/pop.menu" "$PLUGIN_DIR/pop.workspaces"
}

# Point the bar layout's left widgets at the given ids and make sure the stock
# omarchy.menu is not left disabled.
set_widgets() {
  local shell="$HOME/.config/omarchy/shell.json"
  local menu="$1" works="$2"
  [[ -f "$shell" ]] || return 0
  command -v jq >/dev/null 2>&1 || return 0
  jq --arg m "$menu" --arg w "$works" '
    (.disabledPlugins // []) |= map(select(. != "omarchy.menu")) |
    (.cloneSourceRestores // []) |= map(select(. != "omarchy.menu")) |
    (.bar.layout.left // []) |= map(
        (if (.id == "pop.menu" or .id == "omarchy.menu") then (.id = $m) else . end)
      | (if (.id == "pop.workspaces" or .id == "omarchy.workspaces") then (.id = $w) else . end)
    )
  ' "$shell" > "$shell.tmp" && mv "$shell.tmp" "$shell"
}

if is_custom_theme; then
  if [[ -f "$CURRENT_THEME_DIR/looknfeel.lua" ]]; then
    cp "$CURRENT_THEME_DIR/looknfeel.lua" "$HYPR_CONF_DIR/looknfeel.lua"
    hyprctl reload >/dev/null 2>&1 || true
  fi

  deploy_workspace
  omarchy bar use omarchy.bar >/dev/null 2>&1 || true
  set_widgets omarchy.menu pop.workspace
  cleanup_old_plugins
  omarchy-shell shell rescanPlugins >/dev/null 2>&1 || true

  if [[ ! -d "$PLUGIN_DIR/pop.workspace" ]]; then
    omarchy-notification-send "Pop theme workspace widget missing — falling back to defaults" -t 5000 || true
    set_widgets omarchy.menu omarchy.workspaces
    omarchy bar use omarchy.bar >/dev/null 2>&1 || true
  fi
else
  cleanup_old_plugins
  omarchy bar use omarchy.bar >/dev/null 2>&1 || true
  set_widgets omarchy.menu omarchy.workspaces
fi

# The plugin/bar churn above triggers in-place reloads that can leave a widget
# mid-incubation. A clean restart settles the bar into its final state.
omarchy restart shell >/dev/null 2>&1 || true
