local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.default_prog = { "/opt/homebrew/bin/fish" }

-- Font — needs a Nerd Font for Starship icons
config.font = wezterm.font("FiraCode Nerd Font")
config.font_size = 14.0

-- Appearance
config.color_scheme = "Catppuccin Mocha"
config.window_padding = { left = 12, right = 12, top = 12, bottom = 12 }
config.hide_tab_bar_if_only_one_tab = true

-- Disable WezTerm's own multiplexing since zellij handles it
config.keys = {}

return config
