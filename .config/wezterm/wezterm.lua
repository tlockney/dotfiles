local wezterm = require("wezterm")

local config = {}
config.automatically_reload_config = true
config.enable_tab_bar = false
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"
-- config.default_cursor_style = "BlinkingBar"
config.color_scheme = "Nord (Gogh)"
-- config.font = wezterm.font("FiraCode Nerd Font Mono")
config.font = wezterm.font("FiraCode Nerd Font Mono", {weight=450, stretch="Normal", style="Normal"})
config.font_size = 16
config.window_padding = {
	left = 5,
	right = 5,
	top = 2,
	bottom = 2,
}
config.automatically_reload_config = true
config.scrollback_lines = 5000

return config
