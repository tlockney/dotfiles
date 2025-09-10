local function color_scheme_for_appearance(appearance)
   if appearance:find "Dark" then
      return "Catppuccin Mocha"
   else
      return "Catppuccin Latte"
   end
end

local wezterm = require("wezterm")
local config = wezterm.config_builder()
local action = wezterm.action

config.automatically_reload_config = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = true
--  config.tab_max_width = 80
config.color_scheme = color_scheme_for_appearance(wezterm.gui.get_appearance())
config.native_macos_fullscreen_mode = false
config.font = wezterm.font_with_fallback {
  "JetBrainsMono Nerd Font",
  "FiraCode Nerd Font Mono"
}
config.font_size = 16
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_padding = {
  left = '0.8cell',
  right = '0.8cell',
  top = '0.8cell',
  bottom = '0.8cell',
}
config.window_frame = {
  border_left_color = 'grey',
  border_right_color = 'grey',
  border_top_color = 'grey',
  border_bottom_color = 'grey',
  font = wezterm.font { family = 'Avenir', weight = 'Bold' },
  font_size = 16,
}
config.window_background_opacity = 0.90
config.macos_window_background_blur = 20
config.scrollback_lines = 5000

config.keys = {
  { key = 'd',          mods = 'CMD|SHIFT', action = action.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'd',          mods = 'CMD',       action = action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'k',          mods = 'CMD',       action = action.ClearScrollback 'ScrollbackAndViewport' },
  { key = 'w',          mods = 'CMD',       action = action.CloseCurrentPane { confirm = false } },
  { key = 'w',          mods = 'CMD|SHIFT', action = action.CloseCurrentTab { confirm = false } },
  { key = 'LeftArrow',  mods = 'CMD',       action = action.SendKey { key = 'Home' } },
  { key = 'RightArrow', mods = 'CMD',       action = action.SendKey { key = 'End' } },
  { key = 'p',          mods = 'CMD|SHIFT', action = action.ActivateCommandPalette },
}

return config
