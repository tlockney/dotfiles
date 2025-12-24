local wezterm = require("wezterm")
local status_bar = require('status_bar')
local config_module = require('config')
local keybindings = require('keybindings')

-- Setup status bar
status_bar.setup()

-- Dynamic appearance handling per-window
-- This fires for each window and reliably detects appearance
wezterm.on('window-config-reloaded', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  local appearance = window:get_appearance()
  local scheme = appearance:find('Dark') and 'Tokyo Night' or 'Tokyo Night Day'
  if overrides.color_scheme ~= scheme then
    overrides.color_scheme = scheme
    window:set_config_overrides(overrides)
  end
end)

-- Build config
local config = wezterm.config_builder()
config_module.apply_to_config(config)
keybindings.apply_to_config(config)

return config
