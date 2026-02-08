local wezterm = require("wezterm")
local action = wezterm.action

local module = {}

function module.apply_to_config(config)
  config.keys = {
    { key = 'LeftArrow',  mods = 'OPT',       action = action.SendString('\x1bb') },
    { key = 'RightArrow', mods = 'OPT',       action = action.SendString('\x1bf') },
    { key = '{',          mods = 'SHIFT|ALT', action = action.MoveTabRelative(-1) },
    { key = '}',          mods = 'SHIFT|ALT', action = action.MoveTabRelative(1)  },
    { key = 'p',          mods = 'CMD|SHIFT', action = action.ActivateCommandPalette },
    { key = 'Enter',      mods = 'ALT',       action = action.DisableDefaultAssignment },
    { key = "Enter",      mods = "SHIFT",     action = wezterm.action { SendString = "\x1b\r" } },
    { key = 'w',          mods = 'CMD',       action = action.CloseCurrentTab { confirm = false }},
    { key = ',',          mods = 'SUPER',     action = action.SpawnCommandInNewTab {
      cwd = wezterm.home_dir,
      args = { 'emacs', '-nw', wezterm.config_file },
    }},
    {
      key = '\\',
      mods = 'CMD|SHIFT',
      action = wezterm.action.SplitHorizontal {
        domain = 'CurrentPaneDomain'
      },
    },
    {
      key = '-',
      mods = 'CMD|SHIFT',
      action = wezterm.action.SplitVertical {
        domain = 'CurrentPaneDomain'
      },
    },
    -- Pane navigation
    { key = 'h', mods = 'CMD', action = action.ActivatePaneDirection('Left') },
    { key = 'j', mods = 'CMD', action = action.ActivatePaneDirection('Down') },
    { key = 'k', mods = 'CMD', action = action.ActivatePaneDirection('Up') },
    { key = 'l', mods = 'CMD', action = action.ActivatePaneDirection('Right') },
    -- Pane resizing
    { key = 'LeftArrow',  mods = 'CMD|SHIFT', action = action.AdjustPaneSize({ 'Left', 5 }) },
    { key = 'RightArrow', mods = 'CMD|SHIFT', action = action.AdjustPaneSize({ 'Right', 5 }) },
    { key = 'UpArrow',    mods = 'CMD|SHIFT', action = action.AdjustPaneSize({ 'Up', 5 }) },
    { key = 'DownArrow',  mods = 'CMD|SHIFT', action = action.AdjustPaneSize({ 'Down', 5 }) },
    -- Pane zoom toggle
    { key = 'z', mods = 'CMD', action = action.TogglePaneZoomState },
    -- Detach pane to new window
    {
      key = 'd',
      mods = 'CMD|SHIFT',
      action = wezterm.action_callback(function(win, pane)
        pane:move_to_new_window()
      end),
    },
    -- Move pane to existing window
    {
      key = 'm',
      mods = 'CMD|SHIFT',
      action = wezterm.action_callback(function(window, pane)
        local choices = {}
        local current_win_id = window:mux_window():window_id()

        for _, win in ipairs(wezterm.mux.all_windows()) do
          local win_id = win:window_id()
          if win_id ~= current_win_id then
            table.insert(choices, {
              id = tostring(win_id),
              label = 'Window ' .. win_id,
            })
          end
        end

        if #choices == 0 then
          return
        end

        window:perform_action(
          wezterm.action.InputSelector {
            title = 'Move pane to window',
            choices = choices,
            action = wezterm.action_callback(function(_, _, id, _)
              if id then
                local pane_id = pane:pane_id()
                wezterm.background_child_process {
                  'wezterm', 'cli', 'move-pane-to-new-tab',
                  '--pane-id', tostring(pane_id),
                  '--window-id', id,
                }
              end
            end),
          },
          pane
        )
      end),
    },
  }

  -- Numeric tab switching
  for i = 1, 9 do
    table.insert(config.keys, {
      key = tostring(i),
      mods = 'CMD',
      action = action.ActivateTab(i - 1),
    })
  end
end

return module
