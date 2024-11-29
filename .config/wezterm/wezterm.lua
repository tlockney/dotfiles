local wezterm = require("wezterm")

config = wezterm.config_builder()

config = {
	automatically_reload_config = true,
	enable_tab_bar = false,
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE",
	-- default_cursor_style = "BlinkingBar",
	color_scheme = "Nord (Gogh)",
	-- font = wezterm.font("FiraCode Nerd Font Mono"),
	font = wezterm.font("FiraCode Nerd Font Mono", {weight=450, stretch="Normal", style="Normal"}),
	font_size = 16,
	window_padding = {
		left = 5,
		right = 5,
		top = 2,
		bottom = 2,
	},
}

return config
