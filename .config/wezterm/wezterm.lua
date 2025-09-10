local wezterm = require("wezterm")
local action = wezterm.action
local appearance = require 'appearance'

wezterm.on('update-status', function(window)
  -- Grab the utf8 character for the "powerline" left facing
  -- solid arrow.
  local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

  -- Grab the current window's configuration, and from it the
  -- palette (this is the combination of your chosen colour scheme
  -- including any overrides).
  local color_scheme = window:effective_config().resolved_palette
  local bg = color_scheme.background
  local fg = color_scheme.foreground

  window:set_right_status(wezterm.format({
    -- First, we draw the arrow...
    { Background = { Color = 'none' } },
    { Foreground = { Color = bg } },
    { Text = SOLID_LEFT_ARROW },
    -- Then we draw our text
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = ' ' .. wezterm.hostname() .. ' ' },
  }))
end)

local config = wezterm.config_builder()

if appearance.is_dark() then
    -- config.color_scheme = 'Catppuccin Mocha'
    config.color_scheme = 'Tokyo Night'
else
    -- config.color_scheme = 'Catppuccin Latte'
    config.color_scheme = 'Tokyo Night Day'
end

config.automatically_reload_config = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = true
config.native_macos_fullscreen_mode = true
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
config.macos_window_background_blur = 30
config.scrollback_lines = 5000
config.set_environment_variables = {
  PATH = '/opt/homebrew/bin:' .. os.getenv('PATH')
}

config.keys = {
  { key = 'LeftArrow',  mods = 'OPT',       action = action.SendString('\x1bb') },
  { key = 'RightArrow', mods = 'OPT',       action = action.SendString('\x1bf') },
  { key = '{',          mods = 'SHIFT|ALT', action = action.MoveTabRelative(-1) },
  { key = '}',          mods = 'SHIFT|ALT', action = action.MoveTabRelative(1)  },
  { key = 'p',          mods = 'CMD|SHIFT', action = action.ActivateCommandPalette },
  { key = ',',          mods = 'SUPER',     action = action.SpawnCommandInNewTab {
    cwd = wezterm.home_dir,
    args = { 'emacs', '-nw', wezterm.config_file },
  }},
    -- Vertical pipe (|) -> horizontal split
  {
    key = '\\',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitHorizontal {
      domain = 'CurrentPaneDomain'
    },
  },
  -- Underscore (_) -> vertical split
  {
    key = '-',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitVertical {
      domain = 'CurrentPaneDomain'
    },
  },
}

return config
