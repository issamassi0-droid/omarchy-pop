#!/bin/bash
# Pop theme extras (also handles foggy/sepia), applied on `omarchy theme set`.
# - Copies the theme's looknfeel.lua (orange #efae64 window border — 2px, 0.75
#   alpha — with square corners) into the active Hyprland config.
# - Uses the stock omarchy.workspaces widget (no cloned plugin).
# - Switches the bar to the stock omarchy.bar with omarchy.menu +
#   omarchy.workspaces on the left.
# - Removes legacy pop.* and massi.* cloned plugins so they never linger.
# - Restores the default bar + omarchy.workspaces for any other theme.
set -u

CURRENT_THEME_DIR="$HOME/.local/state/omarchy/current/theme"
HYPR_CONF_DIR="$HOME/.config/hypr"
PLUGIN_DIR="$HOME/.config/omarchy/plugins"
SHELL_CONFIG="$HOME/.config/omarchy/shell.json"

is_custom_theme() {
  omarchy theme current 2>/dev/null | grep -qiE "foggy|sepia|pop"
}

# Remove old pop.* and massi.* cloned plugins so they don't conflict.
cleanup_old_plugins() {
  rm -rf \
    "$PLUGIN_DIR/pop.bar" "$PLUGIN_DIR/pop.menu" \
    "$PLUGIN_DIR/pop.workspaces" "$PLUGIN_DIR/pop.workspace" \
    "$PLUGIN_DIR/massi.bar" "$PLUGIN_DIR/massi.menu" \
    "$PLUGIN_DIR/massi.workspaces"
}

# Point the bar layout's left widgets at the given ids. Only touches keys that
# already exist in shell.json, so a minimal config is not broken by |= on
# missing paths.
patch_left_widgets() {
  local menu="$1" works="$2"
  [[ -f "$SHELL_CONFIG" ]] || return 0
  command -v jq >/dev/null 2>&1 || return 0

  jq --arg m "$menu" --arg w "$works" '
    (if .disabledPlugins then .disabledPlugins |= map(select(. != "omarchy.menu")) else . end) |
    (if .cloneSourceRestores then .cloneSourceRestores |= map(select(. != "omarchy.menu")) else . end) |
    (.bar.layout.left // []) |= map(
        (if (.id == "pop.menu" or .id == "omarchy.menu") then (.id = $m) else . end)
       | (if (.id == "pop.workspace" or .id == "omarchy.workspaces") then (.id = $w) else . end)
    )
  ' "$SHELL_CONFIG" >"$SHELL_CONFIG.tmp" && mv "$SHELL_CONFIG.tmp" "$SHELL_CONFIG"
}

cleanup_old_plugins
omarchy bar use omarchy.bar >/dev/null 2>&1 || true
patch_left_widgets omarchy.menu omarchy.workspaces

if is_custom_theme; then
  if [[ -f "$CURRENT_THEME_DIR/looknfeel.lua" ]]; then
    cp "$CURRENT_THEME_DIR/looknfeel.lua" "$HYPR_CONF_DIR/looknfeel.lua"
    hyprctl reload >/dev/null 2>&1 || true
  fi
  omarchy-shell shell rescanPlugins >/dev/null 2>&1 || true
fi

# The plugin/bar churn above can leave a widget mid-incubation. A clean restart
# settles the bar into its final state.
omarchy restart shell >/dev/null 2>&1 || true
