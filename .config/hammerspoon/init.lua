hs.logger.defaultLogLevel = 'debug'

hotkeyLogger = hs.logger.new('hotkey', 'info')

wuakeLog = hs.logger.new('wuake', 'info')

function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
	if file:sub(-4) == ".lua" then
	    doReload = true
	end
    end
    if doReload then
	hs.reload()
    end
end

myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.config/hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")

function launchAppOnHotkey(modifiers, key, appName)
   hs.hotkey.bind(modifiers, key, function()
		     local app = hs.application.find(appName)
		     if app == nil then
			hs.application.launchOrFocus(appName)
		     elseif app:isFrontmost() then
			app:hide()
		     else
			local win = app:mainWindow()
			spaces.moveWindowToSpace(win:id(), spaces.activeSpaceOnScreen())
			win:focus()
		     end
   end)
end

launchAppOnHotkey({"cmd"},"`","WezTerm")
launchAppOnHotkey({"alt","shift"},"o","Obsidian")

-- hs.hotkey.bind({ "Alt" }, "`", function()
--       wezTask = hs.task.new("/opt/homebrew/bin/wezterm",
--		  nil,
--		  function(task, stdOut, stdErr)
--		     if not stdErr == '' then
--			wuakeLog.e("error:" .. stdErr)
--		     end
--		     if not stdOut == '' then
--			wuakeLog.i(stdOut)
--		     end
--		     return true
--		  end,
--		  {"connect", "wuake"})
--       wezTask:start()
-- end)

spaces = require("hs.spaces")
