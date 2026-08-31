local wezterm = require("wezterm")
local appearance = require('appearance')

local FONT_SIZE = 16
local TAB_BAR_FONT_SIZE = 16

local module = {}

function module.apply_to_config(config)
  -- Color scheme
  if appearance.is_dark() then
      config.color_scheme = 'tokyonight_night'
  else
      config.color_scheme = 'tokyonight_day'
  end

  -- General settings
  config.automatically_reload_config = true
  config.hide_tab_bar_if_only_one_tab = true
  config.use_fancy_tab_bar = true
  config.native_macos_fullscreen_mode = true

  config.harfbuzz_features = { 'calt=1', 'liga=1', 'ss02=1', 'zero=1' }
  -- Font
  config.font = wezterm.font_with_fallback {
    "JetBrainsMono Nerd Font Mono",
    "BlexMono Nerd Font Mono",
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
  config.window_background_opacity = 0.95
  config.macos_window_background_blur = 30

  -- Rendering: WebGpu (wgpu) is smoother than the default OpenGL
  -- front-end on Apple Silicon; 120fps helps on ProMotion displays and
  -- is a no-op on 60Hz panels.
  config.front_end = "WebGpu"
  config.max_fps = 120

  -- Dim inactive panes so the focused pane is obvious at a glance.
  config.inactive_pane_hsb = {
    saturation = 0.85,
    brightness = 0.75,
  }

  -- When closing the active tab, return to the last-active tab (browser
  -- behavior) instead of the left neighbor.
  config.switch_to_last_active_tab_when_closing_tab = true

  -- Terminal
  config.scrollback_lines = 50000
  config.set_environment_variables = {
    PATH = '/opt/homebrew/bin:' .. os.getenv('PATH')
  }
  -- config.term = "xterm-wezterm"

end

return module
