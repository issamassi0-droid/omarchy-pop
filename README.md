# Omarchy Pop

An orange-accented, square-cornered [Omarchy](https://github.com/omarchy/omarchy) theme.
Every surface uses a zero-rounded **orange `#efae64`** border — 1px on windows
and popups, 2px on the menu card and its hovered row — matched
across windows, plugin popups, the menu, and the workspace indicator.

## Look

- **Window borders** — orange `#efae64`, 1px, square (`looknfeel.lua`,
  `hyprland.conf` / `hyprland.lua`).
- **Plugin popups** (calendar, audio, network, OSD, …) — orange `#efae64`,
  1px, square (`shell.toml` → `[popups]` border = `hyprland.active-border`).
- **Menu** (`pop.menu`) — square (`cornerRadius: 0`), an opaque `#34332f`
  background matching the top bar, a 2px orange card border at 0.5 alpha, no
  open/close animation (the Hyprland `no_anim` layer rule renders the border
  instantly at full thickness), and a hovered row with an orange `#efae64`
  background at 0.1 alpha plus a 2px orange border.
- **Workspace indicator** (`pop.workspaces`) — focused workspace = orange
  bubble; occupied/active = white-grey bubble with an orange number that matches
  the bar background; empty = faint grey.
- **Top bar** (`pop.bar`) — the bar itself has **no** border (the orange frame
  lives on the popups/menu, not the bar).

The orange is the active Hyprland window border color, so it stays in sync with
the window borders everywhere.

## Requirements

- [Omarchy](https://github.com/omarchy/omarchy) installed and running (Hyprland).
- The custom plugins bundled in this repo: `pop.menu`, `pop.workspaces`,
  `pop.bar`. They are deployed automatically by the theme-set hook.

## Install via GitHub

1. **Clone the theme** into your Omarchy themes directory:

   ```bash
   git clone https://github.com/<your-username>/omarchy-pop.git \
     ~/.config/omarchy/themes/pop
   ```

   (Prefer it somewhere else? Clone anywhere and symlink it instead:
   `ln -s /path/to/omarchy-pop ~/.config/omarchy/themes/pop`.)

2. **Install the theme-set hook** so the custom plugins and bar are deployed on
   every `omarchy theme set`:

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

On `omarchy theme set`, the hook:

1. Copies `looknfeel.lua` from the theme into `~/.config/hypr/looknfeel.lua`
   and runs `hyprctl reload` (applies orange square window borders + the
   `no_anim` menu rule).
2. Deploys the bundled `plugins/pop.*` QML + manifest files into
   `~/.config/omarchy/plugins/`.
3. Switches the bar to `pop.bar`.

For any **other** theme the hook switches the bar back to `omarchy.bar`; the
`pop.*` plugins only affect the `pop` context, so there is no cross-theme
leakage.

## How it works

- **Borders** are defined in `hyprland.conf` / `hyprland.lua` and reinforced in
  `looknfeel.lua` (color `#efae64`, `rounding = 0`).
- **Menu border fix**: `pop.menu/Menu.qml` binds the card border to
  `Color.menu.border` with a fallback to `#efae64` so the 1px orange border is
  drawn on the very first frame (a QML `color` defaults to transparent until
  `Color` resolves, which previously made the border look thinner/absent on
  first open).
- **No menu animation**: a `layer_rule` for `namespace:omarchy-menu` sets
  `no_anim = true, animation = "none"` so the menu frame appears instantly.
  Other windows keep their normal animations.

## Customization

- **Border color**: set `[hyprland] active-border` and `[menu] border` in
  `shell.toml`, and `Color.menu.border` in `pop.menu/Menu.qml`
  (`Border.flat(Color.menu.border.a > 0 ? Color.menu.border : "#efae64", 1)`).
- **Workspace colors**: edit `neonGreen` (focused orange) and `neonRed`
  (active white-grey) at the top of `pop.workspaces/Workspaces.qml`.

After editing, re-run `omarchy theme set Pop` to re-deploy.

## Repository layout

```
omarchy-pop/
├── hooks/
│   └── pop-theme-set.sh        # theme-set hook (deploy + bar switch)
├── looknfeel.lua               # Hyprland look-and-feel (borders, no_anim)
├── hyprland.conf / hyprland.lua
├── shell.toml                  # [popups] + [hyprland] border config
├── shell.menu.toml
├── colors.toml
├── plugins/
│   ├── pop.menu/               # Menu.qml + manifest.json + BarWidget.qml
│   ├── pop.workspaces/         # Workspaces.qml + manifest.json
│   └── pop.bar/                # Bar.qml + manifest.json
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

The `pop.*` plugins left in `~/.config/omarchy/plugins/` are harmless (they are
only used by the `pop` bar); remove them too if you want a clean slate.
