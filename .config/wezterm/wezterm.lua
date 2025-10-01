local wezterm = require("wezterm")
local status_bar = require('status_bar')
local config_module = require('config')
local keybindings = require('keybindings')

-- Setup status bar
status_bar.setup()

-- Build config
local config = wezterm.config_builder()
config_module.apply_to_config(config)
keybindings.apply_to_config(config)

return config
