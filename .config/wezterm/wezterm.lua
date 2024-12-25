local wezterm = require("wezterm")

local config = {
   automatically_reload_config = true,

   -- enable_tab_bar = false,
   -- default_cursor_style = "BlinkingBar",
   -- color_scheme = "Nord (Gogh)",
   color_scheme = 'Catppuccin Mocha',

   font = wezterm.font("FiraCode Nerd Font Mono", {weight=450, stretch="Normal", style="Normal"}),
   font_size = 16,

   window_close_confirmation = "NeverPrompt",
   window_decorations = "RESIZE",
   window_padding = {
	left = 5,
	right = 5,
	top = 2,
	bottom = 2,
   },
   window_background_opacity = 0.90,
   macos_window_background_blur = 20,

   scrollback_lines = 5000,
}

-- require("wuake").setup {
--   config = config,
-- }

return config
