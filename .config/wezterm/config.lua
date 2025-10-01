local wezterm = require("wezterm")
local appearance = require('appearance')

local FONT_SIZE = 16
local TAB_BAR_FONT_SIZE = 16

local module = {}

function module.apply_to_config(config)
  -- Color scheme
  if appearance.is_dark() then
      config.color_scheme = 'Tokyo Night'
  else
      config.color_scheme = 'Tokyo Night Day'
  end

  -- General settings
  config.automatically_reload_config = true
  config.hide_tab_bar_if_only_one_tab = false
  config.use_fancy_tab_bar = true
  config.native_macos_fullscreen_mode = true

  -- Font
  config.font = wezterm.font_with_fallback {
    "JetBrainsMono Nerd Font Mono",
    "FiraCode Nerd Font Mono"
  }
  config.font_size = FONT_SIZE

  -- Window
  config.window_close_confirmation = "NeverPrompt"
  config.window_decorations = "INTEGRATED_BUTTONS|RESIZE|MACOS_FORCE_ENABLE_SHADOW"
  config.window_padding = {
    left = '0.8cell',
    right = '0.8cell',
    top = '0.8cell',
    bottom = '0.8cell',
  }
  config.window_frame = {
    border_left_color = 'black',
    border_right_color = 'black',
    border_top_color = 'black',
    border_bottom_color = 'black',
    border_left_width = '0.1cell',
    border_right_width = '0.1cell',
    border_bottom_height = '0.1cell',
    border_top_height = '0.1cell',
    font = wezterm.font { family = 'Avenir', weight = 'Bold' },
    font_size = TAB_BAR_FONT_SIZE,
  }
  config.window_background_opacity = 0.90
  config.macos_window_background_blur = 30

  -- Terminal
  config.scrollback_lines = 50000
  config.set_environment_variables = {
    PATH = '/opt/homebrew/bin:' .. os.getenv('PATH')
  }

  -- Launch menu
  config.launch_menu = {
    {
      args = { 'htop' }
    },
    {
      args = { 'glances' }
    }
  }
end

return module
