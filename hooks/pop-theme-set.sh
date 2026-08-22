#!/bin/bash
# Pop theme extras (also handles foggy/sepia), applied on `omarchy theme set`.
# - Copies the theme's looknfeel.lua (orange #efae64 window border + square
#   corners) into the active Hyprland config.
# - Deploys the theme-bundled plugin overrides (menu, workspaces, bar) into the
#   live plugin dirs.
# - Switches the bar to the custom bar (pop.bar) with the #efae64 border;
#   restores the default bar for any other theme.
set -u

CURRENT_THEME_DIR="$HOME/.local/state/omarchy/current/theme"
HYPR_CONF_DIR="$HOME/.config/hypr"

is_custom_theme() {
  omarchy theme current 2>/dev/null | grep -qiE "foggy|sepia|pop"
}

# Deploy the theme-bundled plugins (full directories, manifests included) into
# the live plugin dir so they register and load with a single `omarchy theme
# set`. Only the plugins shipped by this theme are touched; other plugins in
# the live dir are left alone.
deploy_plugins() {
  local src="$CURRENT_THEME_DIR/plugins"
  local dst="$HOME/.config/omarchy/plugins"
  [[ -d "$src" ]] || return 0
  for d in "$src"/*/; do
    [[ -d "$d" ]] || continue
    local name="$(basename "$d")"
    rm -rf "$dst/$name"
    cp -r "$d" "$dst/$name"
  done
}

# Point the bar layout's menu/workspaces widgets at the given plugin ids. The
# theme ships pop.menu / pop.workspaces but shell.json still references the
# built-in omarchy.menu / omarchy.workspaces, so without this swap the custom
# menu and workspace indicator never render.
swap_widgets() {
  local shell="$HOME/.config/omarchy/shell.json"
  local menu="$1" works="$2"
  [[ -f "$shell" ]] || return 0
  command -v jq >/dev/null 2>&1 || return 0
  jq --arg m "$menu" --arg w "$works" '
    (.bar.layout.left // [])  |= map(if (.id == "omarchy.menu" or .id == "pop.menu")      then .id = $m else . end) |
    (.bar.layout.right // []) |= map(if (.id == "omarchy.workspaces" or .id == "pop.workspaces") then .id = $w else . end)
  ' "$shell" > "$shell.tmp" && mv "$shell.tmp" "$shell"
}

if is_custom_theme; then
  if [[ -f "$CURRENT_THEME_DIR/looknfeel.lua" ]]; then
    cp "$CURRENT_THEME_DIR/looknfeel.lua" "$HYPR_CONF_DIR/looknfeel.lua"
    hyprctl reload >/dev/null 2>&1 || true
  fi
  deploy_plugins

  # Self-heal: if the custom plugins are incomplete (e.g. a broken clone
  # missing BarModel.js / MenuModel.js), fall back to the stock bar and
  # widgets instead of letting the bar vanish.
  if [[ -f "$HOME/.config/omarchy/plugins/pop.bar/BarModel.js" && \
        -f "$HOME/.config/omarchy/plugins/pop.menu/MenuModel.js" ]]; then
    omarchy-shell shell rescanPlugins >/dev/null 2>&1 || true
    sleep 1
    omarchy bar use pop.bar >/dev/null 2>&1 || true
    swap_widgets pop.menu pop.workspaces
  else
    omarchy-notification-send "Pop theme plugins incomplete — falling back to defaults" -t 5000 || true
    omarchy bar use omarchy.bar >/dev/null 2>&1 || true
    swap_widgets omarchy.menu omarchy.workspaces
  fi
else
  omarchy bar use omarchy.bar >/dev/null 2>&1 || true
  swap_widgets omarchy.menu omarchy.workspaces
fi
