-- hyprland.lua
-- Omarchy Theme - Modified Pop
-- Hyprland Lua Configuration

-- Color Palette
local colors = {
    background = "rgba(30302fff)",
    foreground = "rgba(d1ccc3ff)",
    surface0 = "rgba(30302fff)",
    surface1 = "rgba(505048ff)",
    surface2 = "rgba(686860ff)",
    surface3 = "rgba(909080ff)",
    border = "rgba(efae6499)", -- 0.6 alpha (99 = 60%)
    border_active = "rgba(efae64bf)", -- 0.75 alpha for active
    border_inactive = "rgba(efae6455)", -- 0.33 alpha
    shadow = "rgba(00000044)",
}

-- Monitor Configuration
monitor = {
    { name = "eDP-1", resolution = "1920x1080@60", position = "auto", scale = 1 },
    -- Add more monitors as needed
}

-- General Settings
general = {
    gaps_in = 5,
    gaps_out = 10,
    border_size = 2,
    col_active_border = colors.border_active,
    col_inactive_border = colors.border_inactive,
    layout = "dwindle",
    resize_on_border = true,
    extend_border_grab_area = 10,
    hover_icon_resize = true,
}

-- Decoration Settings
decoration = {
    rounding = 0,
    blur = {
        enabled = true,
        size = 3,
        passes = 1,
        new_optimizations = true,
        xray = false,
        noise = 0.0,
        contrast = 1.0,
        brightness = 1.0,
        vibrancy = 0.0,
        vibrancy_darkness = 0.0,
        special = false,
        popups = true,
    },
    drop_shadow = true,
    shadow_range = 4,
    shadow_render_power = 3,
    shadow_offset = "0 0",
    col_shadow = colors.shadow,
    shadow_scale = 1.0,
    shadow_ignore_window = false,
    fullscreen_opacity = 1.0,
    active_opacity = 1.0,
    inactive_opacity = 0.9,
}

-- Animations
animations = {
    enabled = true,
    bezier = {
        { name = "overshot", value = "0.13, 0.99, 0.29, 1.1" },
        { name = "wind", value = "0.08, 0.94, 0.23, 1.1" },
        { name = "linear", value = "0, 0, 1, 1" },
    },
    animation = {
        { name = "windows", value = "1, 2, overshot, slide" },
        { name = "windowsOut", value = "1, 2, overshot, slide" },
        { name = "border", value = "1, 3, linear" },
        { name = "fade", value = "1, 2, overshot" },
        { name = "workspaces", value = "1, 2, wind, slide" },
        { name = "specialWorkspace", value = "1, 2, wind, slide" },
    },
}

-- Window Rules
windowrule = {
    { rule = "float", class = "pavucontrol" },
    { rule = "float", class = "org.gnome.Calculator" },
    { rule = "float", class = "org.gnome.Screenshot" },
    { rule = "float", class = "firefox", title = "Firefox — Sharing Indicator" },
    { rule = "float", class = "firefox", title = "Picture-in-Picture" },
    { rule = "float", class = "mpv" },
    { rule = "opacity 0.95 override 0.95 override", class = ".*" },
}

-- Window Rules V2 (for more specific rules)
windowrulev2 = {
    { rule = "bordersize 1", class = ".*" },
    { rule = "rounding 5", class = ".*" },
    { rule = "bordercolor " .. colors.border_active, class = ".*" },
}

-- Input Settings
input = {
    kb_layout = "us",
    kb_variant = "",
    kb_model = "",
    kb_options = "",
    kb_rules = "",
    follow_mouse = 1,
    mouse_refocus = false,
    numlock_by_default = true,
    force_no_accel = false,
    scroll_button = 0,
    touchpad = {
        natural_scroll = true,
        disable_while_typing = true,
        clickfinger_behavior = false,
        tap_button_map = "lrm",
        scroll_factor = 0.5,
    },
    sensitivity = 0,
}

-- Gesture Settings
gesture = {
    workspace_swipe = false,
    workspace_swipe_fingers = 3,
    workspace_swipe_distance = 300,
    workspace_swipe_invert = true,
    workspace_swipe_min_speed_to_force = 5,
    workspace_swipe_cancel_ratio = 0.5,
    workspace_swipe_create_new = true,
    workspace_swipe_direction_lock = true,
    workspace_swipe_direction_lock_threshold = 2,
}

-- Device Configuration (for specific input devices)
device = {
    -- Example for specific mouse
    -- { name = "logitech-mouse", sensitivity = -0.5 },
    -- Example for specific keyboard
    -- { name = "keyboard", kb_layout = "us" },
}

-- Bindings
bind = {
    -- Super key shortcuts
    { mod = "SUPER", key = "RETURN", action = "exec, alacritty" },
    { mod = "SUPER", key = "Q", action = "killactive" },
    { mod = "SUPER", key = "M", action = "exit" },
    { mod = "SUPER", key = "E", action = "exec, dolphin" },
    { mod = "SUPER", key = "B", action = "exec, firefox" },

    -- Window management
    { mod = "SUPER", key = "F", action = "fullscreen" },
    { mod = "SUPER", key = "SPACE", action = "togglefloating" },
    { mod = "SUPER", key = "P", action = "pseudo" }, -- toggle pseudo-tile
    { mod = "SUPER", key = "TAB", action = "workspace" }, -- workspace switcher

    -- Focus and movement
    { mod = "SUPER", key = "h", action = "movefocus, l" },
    { mod = "SUPER", key = "j", action = "movefocus, d" },
    { mod = "SUPER", key = "k", action = "movefocus, u" },
    { mod = "SUPER", key = "l", action = "movefocus, r" },

    -- Moving windows
    { mod = "SUPER_SHIFT", key = "h", action = "movewindow, l" },
    { mod = "SUPER_SHIFT", key = "j", action = "movewindow, d" },
    { mod = "SUPER_SHIFT", key = "k", action = "movewindow, u" },
    { mod = "SUPER_SHIFT", key = "l", action = "movewindow, r" },

    -- Resizing
    { mod = "SUPER_CTRL", key = "h", action = "resizeactive, -20 0" },
    { mod = "SUPER_CTRL", key = "j", action = "resizeactive, 0 20" },
    { mod = "SUPER_CTRL", key = "k", action = "resizeactive, 0 -20" },
    { mod = "SUPER_CTRL", key = "l", action = "resizeactive, 20 0" },

    -- Workspace switching
    { mod = "SUPER", key = "1", action = "workspace, 1" },
    { mod = "SUPER", key = "2", action = "workspace, 2" },
    { mod = "SUPER", key = "3", action = "workspace, 3" },
    { mod = "SUPER", key = "4", action = "workspace, 4" },
    { mod = "SUPER", key = "5", action = "workspace, 5" },
    { mod = "SUPER", key = "6", action = "workspace, 6" },
    { mod = "SUPER", key = "7", action = "workspace, 7" },
    { mod = "SUPER", key = "8", action = "workspace, 8" },
    { mod = "SUPER", key = "9", action = "workspace, 9" },
    { mod = "SUPER", key = "0", action = "workspace, 10" },

    -- Move windows to workspaces
    { mod = "SUPER_SHIFT", key = "1", action = "movetoworkspace, 1" },
    { mod = "SUPER_SHIFT", key = "2", action = "movetoworkspace, 2" },
    { mod = "SUPER_SHIFT", key = "3", action = "movetoworkspace, 3" },
    { mod = "SUPER_SHIFT", key = "4", action = "movetoworkspace, 4" },
    { mod = "SUPER_SHIFT", key = "5", action = "movetoworkspace, 5" },
    { mod = "SUPER_SHIFT", key = "6", action = "movetoworkspace, 6" },
    { mod = "SUPER_SHIFT", key = "7", action = "movetoworkspace, 7" },
    { mod = "SUPER_SHIFT", key = "8", action = "movetoworkspace, 8" },
    { mod = "SUPER_SHIFT", key = "9", action = "movetoworkspace, 9" },
    { mod = "SUPER_SHIFT", key = "0", action = "movetoworkspace, 10" },

    -- Media keys
    { mod = ",", key = "XF86AudioRaiseVolume", action = "exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+" },
    { mod = ",", key = "XF86AudioLowerVolume", action = "exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-" },
    { mod = ",", key = "XF86AudioMute", action = "exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" },
    { mod = ",", key = "XF86AudioPlay", action = "exec, playerctl play-pause" },
    { mod = ",", key = "XF86AudioNext", action = "exec, playerctl next" },
    { mod = ",", key = "XF86AudioPrev", action = "exec, playerctl previous" },

    -- Brightness
    { mod = ",", key = "XF86MonBrightnessUp", action = "exec, brightnessctl set 5%+" },
    { mod = ",", key = "XF86MonBrightnessDown", action = "exec, brightnessctl set 5%-" },

    -- Screenshots
    { mod = ",", key = "Print", action = "exec, grimblast copy area" },
    { mod = "SUPER", key = "Print", action = "exec, grimblast save area" },
    { mod = "SUPER_SHIFT", key = "Print", action = "exec, grimblast save output" },

    -- Launcher
    { mod = "SUPER", key = "D", action = "exec, wofi --show drun" },
    { mod = "SUPER", key = "R", action = "exec, wofi --show run" },
}

-- Mouse Bindings
bindm = {
    { mod = "SUPER", mouse = "272", action = "movewindow" }, -- Left click
    { mod = "SUPER", mouse = "273", action = "resizewindow" }, -- Right click
}

-- Environment Variables
env = {
    { name = "XDG_CURRENT_DESKTOP", value = "Hyprland" },
    { name = "XDG_SESSION_DESKTOP", value = "Hyprland" },
    { name = "XDG_SESSION_TYPE", value = "wayland" },
    { name = "XCURSOR_SIZE", value = "24" },
    { name = "XCURSOR_THEME", value = "Bibata-Modern-Ice" },
}

-- Exec Once (run at startup)
exec_once = {
    "waybar &",
    "swaybg -i /usr/share/backgrounds/your-wallpaper.png",
    "mako &",
    "wl-paste --type text --watch cliphist store &",
    "wl-paste --type image --watch cliphist store &",
    "nm-applet &",
    "blueman-applet &",
}

-- Exec (runs each time Hyprland reloads)
exec = {
    -- "notify-send 'Hyprland' 'Configuration reloaded'",
}

bind = {
    { mod = "SUPER", key = "space", action = "exec, quickshell -p ~/.config/quickshell/omarchy-pop/shell.qml" }
}
-- Source external config files if needed
-- source = "~/.config/hypr/hyprland.d/*.conf"
