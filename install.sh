#!/usr/bin/env bash
#
# One-command installer for the Omarchy Pop theme.
#
# What it does:
#   1. Clones the theme into ~/.config/omarchy/themes/pop (if not already there).
#   2. Registers the theme-set hook so orange window borders are applied,
#      legacy pop.* / massi.* plugins are cleaned up, and the custom
#      pop.workspace plugin is installed on every `omarchy theme set`.
#   3. Applies the theme (which runs the hook).
#
# Usage:
#   ./install.sh [repo-url]
#
# With no argument it uses the default upstream URL. Pass a URL (or a local
# path) to install from somewhere else.

set -euo pipefail

REPO_URL="${1:-https://github.com/issamassi0-droid/omarchy-pop.git}"
THEME_NAME="pop"
THEMES_DIR="$HOME/.config/omarchy/themes"
THEME_DIR="$THEMES_DIR/$THEME_NAME"
HOOK_DST_DIR="$HOME/.config/omarchy/hooks/theme-set.d"
HOOK_DST="$HOOK_DST_DIR/pop-theme-set.sh"

# 1. Clone the theme (skip if already cloned at the standard location).
if [[ ! -d "$THEME_DIR/.git" ]]; then
  mkdir -p "$THEMES_DIR"
  [[ -e "$THEME_DIR" ]] && rm -rf "$THEME_DIR"
  echo "Cloning $REPO_URL ..."
  git clone "$REPO_URL" "$THEME_DIR"
fi

# 2. Register the theme-set hook.
mkdir -p "$HOOK_DST_DIR"
cp "$THEME_DIR/hooks/pop-theme-set.sh" "$HOOK_DST"
chmod +x "$HOOK_DST"
echo "Installed theme-set hook: $HOOK_DST"

# 3. Apply the theme (runs the hook which installs pop.workspace plugin).
echo "Applying theme '$THEME_NAME' ..."
omarchy theme set pop

echo "Done. The Pop theme is active."
