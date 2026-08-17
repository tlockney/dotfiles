local wezterm = require("wezterm")

local module = {}

-- Collapse $HOME to ~, then keep the tail of the path if it's too long
-- to fit comfortably in the left status.
local function format_cwd(cwd)
  if not cwd or #cwd == 0 then
    return ''
  end
  local home = wezterm.home_dir
  if home and cwd:sub(1, #home) == home then
    cwd = '~' .. cwd:sub(#home + 1)
  end
  local MAX = 42
  if #cwd > MAX then
    cwd = '…' .. cwd:sub(-(MAX - 1))
  end
  return cwd
end

function module.setup()
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

    -- Active pane's working directory: the one piece of context that
    -- neither starship nor tmux shows when you're scrolled up or inside
    -- a running app.
    local pane = window:active_pane()
    local cwd = ''
    if pane then
      local url = pane:get_current_working_dir()
      if url then
        cwd = format_cwd(tostring(url):gsub('^file://', ''))
      end
    end

    window:set_left_status(wezterm.format({
      { Foreground = { Color = fg } },
      { Text = cwd },
    }))

    window:set_right_status(wezterm.format({
      -- First, we draw the arrow...
      { Background = { Color = 'none' } },
      { Foreground = { Color = bg } },
      { Text = SOLID_LEFT_ARROW },
      -- Then we draw our text
      { Background = { Color = bg } },
      { Foreground = { Color = fg } },
      { Text = ' ' .. wezterm.hostname() .. '  ' .. os.date('%l:%M %p') .. ' ' },
    }))
  end)
end

return module
