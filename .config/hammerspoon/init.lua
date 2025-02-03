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

require("button_images")

sdlog = hs.logger.new("streamdeck")

streamdecks = {}
streamdecks['A00WA4121N7XWN'] = {
	buttons = {

	}
}

function initStreamdeck(connected, device)
	if streamdecks[device:serialNumber()] then
		device:reset()
		columns, rows = device:buttonLayout()
		numButtons = columns * rows
		device:setButtonImage(1, streamdeck_imageFromText('🖥️'))
		sdlog.i(hs.inspect(device))
		device:buttonCallback(function(sd, num, pressed)
			-- sdlog.i(hs.inspect(sd))
			-- sdlog.i(num)
			-- sdlog.i(pressed)
			if pressed then

			end
		end)
	end
end

hs.streamdeck.init(initStreamdeck)
