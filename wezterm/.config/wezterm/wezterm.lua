local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "AdventureTime"
config.initial_rows = 40
config.initial_cols = 120
config.font = wezterm.font("Hermit")
config.font_size = 14
config.adjust_window_size_when_changing_font_size = false
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"
config.window_padding = {
    bottom = 0
}
config.window_background_opacity = 0.9

return config

