local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.default_prog = { "/opt/homebrew/bin/fish" }

-- Font — needs a Nerd Font for Starship icons
config.font = wezterm.font("FiraCode Nerd Font")
config.font_size = 12.0

-- Appearance
-- config.color_scheme = 'Rosé Pine (Gogh)'
-- config.color_scheme = 'Isotope (dark) (terminal.sexy)'
-- config.color_scheme = 'Laser'
-- config.color_scheme = 'Neon Night (Gogh)'
config.color_scheme = 'Panda (Gogh)'
-- config.color_scheme = 'Purple Rain'
-- config.color_scheme = 'Synthwave Alpha (Gogh)'
-- config.color_scheme = 'VibrantInk'
-- config.color_scheme = 'Matrix (terminal.sexy)'
-- config.color_scheme = 'Humanoid dark (base16)'
-- config.color_scheme = 'Lab Fox'
-- config.color_scheme = 'shades-of-purple'



config.window_padding = { left = 0, right = 0, top = 8, bottom = 0 }
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.90  -- 0.0 to 1.0
config.macos_window_background_blur = 10

config.background = {
    {
        source = {
            Gradient = {
                colors = { "#12003d", "#1c003d" },
                orientation = { Linear = { angle = -45.0 } },
            },
        },
        width = "100%",
        height = "100%",
        opacity = 0.9,
    },
    {
        source = { File = os.getenv("HOME") .. "/grain.jpg" },
        repeat_x = "Mirror",
        repeat_y = "Mirror",
        opacity = 0.02,
    },
}

--config.window_background_gradient = {
--colors = { '#150069', '#440069' },
  -- Specifies a Linear gradient starting in the top left corner.
 -- orientation = { Linear = { angle = -45.0 } },
--}

-- Disable WezTerm's own multiplexing since zellij handles it
config.keys = {}

-- Fix Mac Keybinding issues
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = false
config.keys = {
    {
        key = "Enter",
        mods = "SHIFT",
        action = wezterm.action.SendString("\x1b[200~\n\x1b[201~"),
    },
}

return config
