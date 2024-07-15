local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "AtelierSulphurpool"
config.initial_rows = 40
config.initial_cols = 120
config.font = wezterm.font("Hermit")
config.font_size = 14

-- to be able to type umlauts etc.
config.use_dead_keys = true
config.send_composed_key_when_left_alt_is_pressed = true

config.adjust_window_size_when_changing_font_size = false
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
config.window_padding = {
    -- top = "1.5 cell",
    bottom = 0
}
config.window_background_opacity = 0.9
config.keys = {
  {
    key = 'LeftArrow',
    mods = 'ALT',
    action = wezterm.action.SendKey({ key = 'b', mods = 'ALT' }),
  },
  {
    key = 'RightArrow',
    mods = 'ALT',
    action = wezterm.action.SendKey({ key = 'f', mods = 'ALT' }),
  },
  {
    key = ",",
    mods = "SUPER",
    action = wezterm.action.SpawnCommandInNewTab({
      cwd = os.getenv("WEZTERM_CONFIG_DIR"),
      args = { os.getenv("SHELL"), "-c", "$EDITOR $WEZTERM_CONFIG_FILE" },
    }),
  },
}

return config

