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

if is_custom_theme; then
  if [[ -f "$CURRENT_THEME_DIR/looknfeel.lua" ]]; then
    cp "$CURRENT_THEME_DIR/looknfeel.lua" "$HYPR_CONF_DIR/looknfeel.lua"
    hyprctl reload >/dev/null 2>&1 || true
  fi
  deploy_plugins
  omarchy-shell shell rescanPlugins >/dev/null 2>&1 || true
  sleep 1
  omarchy bar use pop.bar >/dev/null 2>&1 || true
else
  omarchy bar use omarchy.bar >/dev/null 2>&1 || true
fi
