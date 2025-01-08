hs.logger.defaultLogLevel = 'info'
hs.notify.new({ informativeText = "Loading config" }):send()

require("hs.ipc")

function reloadConfig(files)
	doReload = false
	for _, file in pairs(files) do
		if file:sub(-4) == ".lua" then
			doReload = true
		end
	end
	if doReload then
		hs.reload()
	end
end

local hsConfigPath = os.getenv("HOME") .. "/.config/hammerspoon/"
myWatcher = hs.pathwatcher.new(hsConfigPath, reloadConfig):start()

spaces = require("hs.spaces")

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

launchAppOnHotkey({ "alt" }, "`", "WezTerm")
launchAppOnHotkey({ "alt", "shift" }, "o", "Obsidian")

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "W", function()
	hs.notify.new({ informativeText = "Hello World" }):send()
end)

-- require("app-watcher")
