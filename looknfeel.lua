-- Change the default Omarchy look'n'feel.
-- macOS-like smooth, fluid animations and transitions.

-- ============================================================
-- 1.  CORE AESTHETIC SETTINGS
-- ============================================================

hl.config({
    general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 2,
        ["col.active_border"] = "rgba(efae64bf)",
        ["col.inactive_border"] = "rgba(8e8c88f2)",
    },

    decoration = {
        rounding = 0,
        active_opacity = 0.98,
        inactive_opacity = 0.94,
        fullscreen_opacity = 1.0,

        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1e1e1840)",
            color_inactive = "rgba(6c6b6680)",
        },

        blur = {
            enabled = true,
            size = 14,
            passes = 5,
            new_optimizations = true,
            ignore_opacity = true,
            xray = false,
            noise = 0.015,
            contrast = 1.05,
            brightness = 0.92,
        },

        dim_inactive = true,
        dim_strength = 0.07,
    },

    animations = {
        enabled = true,
    },
})

-- ============================================================
-- 2.  BLUR FOR LAYERS (notifications, bar, popups)
-- ============================================================

hl.layer_rule({
    match = "namespace:omarchy-bar",
    blur = true,
    ignore_alpha = 0.5,
})

hl.layer_rule({
    match = "namespace:quickshell",
    blur = true,
    ignore_alpha = 0.6,
})

-- Notification popups – blurred glass effect
hl.layer_rule({
    match = "namespace:dunst",
    blur = true,
    ignore_alpha = 0.7,
})

-- Main menu – frosted glass surface. Open/close animates normally so the
-- border frame fades in with the rest of the card.
hl.layer_rule({
    match = "namespace:omarchy-menu",
    blur = true,
    ignore_alpha = 0.2,
})

-- ============================================================
-- 3.  WINDOW RULES
-- ============================================================

-- Base rule for all windows
hl.window_rule({
    match = ".*",
    opacity = 1.0,
    rounding = 12,
})

-- Quickshell panels – pinned, floating, no rounding
hl.window_rule({
    match = "class:quickshell",
    opacity = 0.98,
    rounding = 0,
})

hl.window_rule({
    match = "title:omarchy-bar",
    pin = true,
    float = true,
    opacity = 0.98,
    rounding = 0,
})

-- Floating dialogs – more rounded, frosted glass feel
hl.window_rule({
    match = "floating:.*",
    rounding = 18,
    border_size = 1,
    opacity = 1.0,
})

-- Terminals – slight transparency, rounded
hl.window_rule({
    match = "class:Alacritty",
    opacity = 1.0,
    rounding = 14,
})

-- Browsers – subtle transparency
hl.window_rule({
    match = "class:firefox",
    opacity = 1.0,
    rounding = 12,
})

-- Popups / tooltips – fade-friendly
hl.window_rule({
    match = "class:firefox.*popup",
    rounding = 10,
    opacity = 1.0,
})

-- ============================================================
-- 4.  ANIMATION CURVES (macOS-like spring/ease)
-- ============================================================

-- Smooth ease-out for fades / opacity (easeOutQuint, decelerates gently into place)
hl.curve("macFade", { type = "bezier", points = { { 0.33, 1.0 }, { 0.68, 1.0 } } })

-- Window / surface open: fluid deceleration with a touch of grace (easeOutExpo)
hl.curve("macOpen", { type = "bezier", points = { { 0.16, 1.0 }, { 0.3, 1.0 } } })

-- Window / surface close: snappy ease-in so it leaves quickly and cleanly
hl.curve("macClose", { type = "bezier", points = { { 0.4, 0.0 }, { 1.0, 1.0 } } })

-- Subtle overshoot "pop" used by menus / notifications for a pro, lively feel
hl.curve("macSpring", { type = "bezier", points = { { 0.34, 1.42 }, { 0.64, 1.0 } } })

-- Smooth slide for workspace transitions (easeOutQuint)
hl.curve("macSlide", { type = "bezier", points = { { 0.33, 1.0 }, { 0.68, 1.0 } } })

-- ============================================================
-- 5.  GLOBAL FALLBACK
-- ============================================================

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "macFade" })

-- ============================================================
-- 6.  WINDOW ANIMATIONS (open / close / move / resize)
-- ============================================================

-- macOS-style: windows open with a gentle zoom (popin) + smooth fade and
-- close quickly. The bezier carries the fluid deceleration.
hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "macOpen" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 5, bezier = "macOpen", style = "popin 94%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "macClose", style = "popin 94%" })

-- ============================================================
-- 7.  BORDER ANIMATION (smooth color transitions)
-- ============================================================

hl.animation({ leaf = "border", enabled = true, speed = 7, bezier = "macFade" })

-- ============================================================
-- 8.  FADE ANIMATIONS (tooltips, popups, general fade)
-- ============================================================

hl.animation({ leaf = "fadeIn", enabled = false, speed = 6, bezier = "macFade" })
hl.animation({ leaf = "fadeOut", enabled = false, speed = 5, bezier = "macClose" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "macFade" })
hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 5, bezier = "macFade" })

-- ============================================================
-- 9.  LAYER ANIMATIONS (notifications, bar, OSD popups)
-- ============================================================

-- Layers pop in with a subtle spring and leave cleanly.
hl.animation({ leaf = "layers", enabled = true, speed = 6, bezier = "macSpring" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 6, bezier = "macSpring", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 5, bezier = "macClose", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 6, bezier = "macSpring" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 5, bezier = "macClose" })

-- ============================================================
-- 10. WORKSPACE TRANSITIONS (smooth horizontal slide)
-- ============================================================

hl.animation({ leaf = "workspaces", enabled = true, speed = 7, bezier = "macSlide", style = "slidefade 18%" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 6, bezier = "macSlide", style = "slidevert" })

-- ============================================================
-- 11. LAYOUT / MISC
-- ============================================================

hl.config({
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },
})

hl.env("XCURSOR_THEME", "Quintom_Snow")
hl.env("XCURSOR_SIZE", "16")
