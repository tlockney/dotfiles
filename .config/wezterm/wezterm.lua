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

   hide_tab_bar_if_only_one_tab = true,

   -- color_scheme = "Nord (Gogh)",
   -- color_scheme = 'Catppuccin Mocha',
   color_scheme = color_scheme_for_appearance(wezterm.gui.get_appearance()),
   native_macos_fullscreen_mode = false,

   font = wezterm.font "JetBrainsMono Nerd Font",
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
