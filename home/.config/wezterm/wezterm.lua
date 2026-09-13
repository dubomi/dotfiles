local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("Hack Nerd Font")
config.font_size = 13.0
if wezterm.target_triple:find("apple") then
  config.window_background_opacity = 0.9
  config.macos_window_background_blur = 75
else
  config.window_background_opacity = 1.0
end
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"
config.front_end = "WebGpu" -- use GPU accelerated rasterization to prevent sporadic flickering when laptop wakes up from sleep

config.inactive_pane_hsb = {
  saturation = 0.0,
  brightness = 0.5,
}

config.keys = {
  {
    key = "b",
    mods = "CMD", -- CMD triggers the Command key on macOS and the Windows key on Windows/Linux
    action = wezterm.action.SendKey({ key = "b", mods = "CTRL" }),
  },
}

return config
