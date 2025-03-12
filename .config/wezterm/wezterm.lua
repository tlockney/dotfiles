local function color_scheme_for_appearance(appearance)
	if appearance:find "Dark" then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
	end
end


local wezterm = require("wezterm")

local config = {
	automatically_reload_config = true,

	hide_tab_bar_if_only_one_tab = false,
	use_fancy_tab_bar = true,
	tab_max_width = 80,

	-- color_scheme = "Nord (Gogh)",
	-- color_scheme = 'Catppuccin Mocha',
	color_scheme = color_scheme_for_appearance(wezterm.gui.get_appearance()),
	native_macos_fullscreen_mode = false,

	font = wezterm.font_with_fallback {
		"JetBrainsMono Nerd Font",
		"FiraCode Nerd Font Mono"
	},
	font_size = 16,

	window_close_confirmation = "NeverPrompt",
	window_decorations = "INTEGRATED_BUTTONS|RESIZE",
	window_padding = {
		left = '0.5cell',
		right = '0.5cell',
		top = '0.5cell',
		bottom = '0.5cell',
	},
	window_frame = {
	   -- border_left_width = '0.2cell',
	   -- border_right_width = '0.2cell',
	   -- border_top_height = '0.1cell',
	   -- border_bottom_height = '0.1cell',
	   border_left_color = 'grey',
	   border_right_color = 'grey',
	   border_top_color = 'grey',
	   border_bottom_color = 'grey',
	   font = require('wezterm').font 'Avenir Regular',
	   font_size = 14,
	},
	window_background_opacity = 0.90,
	macos_window_background_blur = 20,

	scrollback_lines = 5000,
}

return config
