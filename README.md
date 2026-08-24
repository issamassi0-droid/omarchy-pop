# Omarchy Pop

An orange-accented [Omarchy](https://github.com/omarchy/omarchy) theme. Every
surface uses a zero-rounded **orange `#efae64`** border — matched across windows,
plugin popups, the menu, tooltips, notifications, and the workspace indicator.

## Look

- **Window borders** — orange `#efae64`, 1px, square (`looknfeel.lua`,
  `hyprland.conf` / `hyprland.lua`). Smooth open/close animations are enabled.
- **Plugin popups** (calendar, audio, network, OSD, …) — orange `#efae64`,
  2px, square (`shell.toml` → `[popups]` border `#efae64`, alpha 0.6, width 2).
- **Notifications** — orange `#efae64` border (alpha 0.9, width 1.5) with white
  text (`shell.toml` → `[notifications]`).
- **Tooltips** — orange `#efae64` border (alpha 1.0, width 1.5) with white text
  (`shell.toml` → `[tooltip]`).
- **Menu** (`omarchy.menu`, stock) — an opaque `#34332f` background matching the
  top bar, a thin orange `#efae64` card border at 0.6 alpha, and a hovered row
  with an orange `#efae64` background at 0.15 alpha, a 2px orange border at 0.5
  alpha, and white text. All of this is configured in `shell.menu.toml` /
  `shell.toml` `[menu]` — no custom menu plugin is needed.
- **Controls** (buttons, dropdowns, selections) — orange `#a57030` border and
  selection fill via `shell.toml` / `shell.controls.toml` `[controls]` tokens.
  Selected items show an orange border (alpha 0.7, 1px) and a subtle orange fill
  (alpha 0.5). These tokens apply to all plugins automatically.
- **Workspace indicator** (`omarchy.workspaces`, stock) — uses the default
  Omarchy workspace widget. No custom workspace plugin is needed.
- **Top bar** (`omarchy.bar`, stock) — the bar itself has **no** border (the
  orange frame lives on the popups / menu / controls, not the bar).

The orange is the active Hyprland window border color, so it stays in sync with
the window borders everywhere.

## Requirements

- [Omarchy](https://github.com/omarchy/omarchy) installed and running (Hyprland).

## Install

### One command

Run the bundled installer (it clones the theme, registers the hook, and applies
it — no extra steps):

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/issamassi0-droid/omarchy-pop/master/install.sh)"
```

Or, if you already cloned the repo (or want to install from a local path):

```bash
git clone https://github.com/issamassi0-droid/omarchy-pop.git \
  ~/.config/omarchy/themes/pop
bash ~/.config/omarchy/themes/pop/install.sh
```

### Using the stock installer

If you would rather use Omarchy's built-in command instead of the bundled
script, the base install is a three-step chain: clone the theme with
`omarchy theme install`, register its hook with `omarchy hook install`, then
re-apply the theme so the hook runs:

```bash
omarchy theme install https://github.com/issamassi0-droid/omarchy-pop.git && \
omarchy hook install theme-set ~/.config/omarchy/themes/pop/hooks/pop-theme-set.sh && \
omarchy theme set pop
```

### Manual steps

1. **Clone the theme** into your Omarchy themes directory:

   ```bash
   git clone https://github.com/issamassi0-droid/omarchy-pop.git \
     ~/.config/omarchy/themes/pop
   ```

   (Prefer it somewhere else? Clone anywhere and symlink it instead:
   `ln -s /path/to/omarchy-pop ~/.config/omarchy/themes/pop`.)

2. **Install the theme-set hook** so the orange window borders are applied and
   legacy plugins are cleaned up on every `omarchy theme set`:

   ```bash
   mkdir -p ~/.config/omarchy/hooks/theme-set.d
   cp ~/.config/omarchy/themes/pop/hooks/pop-theme-set.sh \
      ~/.config/omarchy/hooks/theme-set.d/
   chmod +x ~/.config/omarchy/hooks/theme-set.d/pop-theme-set.sh
   ```

3. **Apply the theme**:

   ```bash
   omarchy theme set Pop
   # or: omarchy theme set "Omarchy Pop"
   ```

> **Why a hook?** `omarchy theme install` / `omarchy theme set` only apply the
> theme's base surface (colors, backgrounds, terminal/GTK configs). The
> orange window borders and legacy plugin cleanup are wired up by this
> theme's `theme-set` hook, which the packaged installer does not copy for you.

On `omarchy theme set`, the hook:

1. Copies `looknfeel.lua` from the theme into `~/.config/hypr/looknfeel.lua`
   and runs `hyprctl reload` (applies orange square window borders).
2. Switches the bar to the stock `omarchy.bar` and sets the left widgets to
   `omarchy.menu` + `omarchy.workspaces` (the stock workspace indicator).
3. Removes legacy `pop.*` / `massi.*` custom plugins if present.
4. Restarts the shell to settle the in-place reloads.

For any **other** theme the hook switches the bar back to `omarchy.bar` and
removes legacy plugins; nothing leaks across themes.

## How it works

- **Borders** are defined in `hyprland.conf` / `hyprland.lua` and reinforced in
  `looknfeel.lua` (color `#efae64`, `rounding = 0`).
- **Controls styling** is pure config: `shell.toml` and `shell.controls.toml`
  `[controls]` tokens set the selected color (`#a57030`), fill alpha (0.5),
  border color (`#a57030`), border width (1px), and border alpha (0.7). The
  stock `omarchy.clock`, `omarchy.network`, `omarchy.audio`, etc. read these
  tokens automatically — no custom plugins needed.
- **Menu styling is pure config**: `shell.menu.toml` (and `shell.toml`
  `[menu]`) set the card border and the hovered-row background / border / text.
  The stock `omarchy.menu` reads these `Color.menu.*` tokens, so no custom menu
  plugin is required.
- **Menu animation**: the `namespace:omarchy-menu` layer rule no longer sets
  `no_anim`; the menu fades in/out with the rest of the shell.

## Customization

- **Border color**: set `[hyprland] active-border` and the `border` keys in
  `shell.toml` (`[popups]`, `[notifications]`, `[tooltip]`, `[menu]`) and
  `shell.menu.toml` (`[menu]`).
- **Controls selection color**: edit `selected-color` and `selected-fill-alpha`
  in `shell.toml` / `shell.controls.toml` `[controls]`. Border color and
  thickness are controlled by `selected-border`, `selected-border-width`, and
  `selected-border-alpha`.
- **Normal border color**: edit `normal-color` and `normal-border-alpha` in
  `shell.toml` / `shell.controls.toml` `[controls]`.
- **Menu hover**: tune `selected-background` / `selected-background-alpha`,
  `selected-border` / `selected-border-alpha` / `selected-border-width`, and
  `selected-text` in `shell.menu.toml` `[menu]`.

After editing, re-run `omarchy theme set Pop` to re-deploy.

## Repository layout

```
omarchy-pop/
├── install.sh                  # one-command installer (clone + hook + apply)
├── hooks/
│   └── pop-theme-set.sh        # theme-set hook (orange borders + cleanup)
├── looknfeel.lua               # Hyprland look-and-feel (orange square borders)
├── hyprland.conf / hyprland.lua
├── shell.toml                  # [popups]/[notifications]/[tooltip]/[menu] borders
├── shell.controls.toml         # [controls] selection/border colors
├── shell.menu.toml             # [menu] card + hovered-row styling
├── colors.toml
├── quickshell/
│   └── Theme.qml               # Quickshell border/borderRadius tokens
└── README.md
```

## Uninstall / revert

```bash
omarchy theme set Ash            # or any other theme
rm ~/.config/omarchy/themes/pop  # remove the symlink / clone
rm ~/.config/omarchy/hooks/theme-set.d/pop-theme-set.sh
```
