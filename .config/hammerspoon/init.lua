require("hs.ipc")
require("button_images")
require("util")

-- require("app-watcher")

hs.logger.defaultLogLevel = 'debug'
hs.notify.new({ informativeText = "Loading config" }):send()

hs.hotkey.bind({ "ctrl", "alt", "cmd" }, "H", function()
	hs.toggleConsole()
end)

function reloadConfig(files)
	local doReload = false
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
hs.pathwatcher.new(hsConfigPath, reloadConfig):start()

hs.loadSpoon("Hammerflow")
spoon.Hammerflow.loadFirstValidTomlFile({
  "home.toml",
  "work.toml",
  "Spoons/Hammerflow.spoon/sample.toml"
})
-- optionally respect auto_reload setting in the toml config.
if spoon.Hammerflow.auto_reload then
  hs.loadSpoon("ReloadConfiguration")
  -- set any paths for auto reload
  -- spoon.ReloadConfiguration.watch_paths = {hs.configDir, "~/path/to/my/configs/"}
  spoon.ReloadConfiguration:start()
end

local spaces = require("hs.spaces")

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

-- App hotkeys migrated to Hammerflow (home.toml)

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "W", function()
	hs.notify.new({ informativeText = "Hello World" }):send()
end)

local sdlog = hs.logger.new("streamdeck")

local thunderboltButton = {
	position = 1,
	image = streamdeck_imageFromText('⚡'),
	onpress = function()
		sdlog.i("Thunderbolt")
	end,
}

local hdmiButton = {
	position = 2,
	image = hs.image.imageFromPath(hs.configdir .. "/images/hdmi2.png"),
	onpress = function()
		sdlog.i("hdmi")
	end
}
local monitorToggleButton = {
	position = 3,
	image = streamdeck_imageFromText('🖥️'),
	onpress = function()
		sdlog.i("Toggle monitor")
	end
}

local streamdecks = {
	['A00WA4121N7XWN'] = {},
	['DL50K1A44132'] = {
		buttons = {
			thunderboltButton,
			hdmiButton,
			monitorToggleButton
		}
	}
}

hs.streamdeck.init(function(connected, device)
	sdlog.i(hs.inspect(device))
	if streamdecks[device:serialNumber()] then
		local deck = streamdecks[device:serialNumber()]
		local columns, rows = device:buttonLayout()
		if deck.buttons ~= nil then
			local buttons = deck.buttons
			local onpress = {}
			local onrelease = {}
			device:reset()
			for idx = 1, #buttons do
				local button = buttons[idx]
				local position = button.position
				onpress[position] = button.onpress
				onrelease[position] = button.onrelease
				device:setButtonImage(position, button.image)
			end
			device:buttonCallback(function(sd, num, pressed)
				if onpress[num] ~= nil and pressed then
					sdlog.d("Button " .. num .. " pressed.")
					onpress[num]()
				end
				if onrelease[num] ~= nil and not pressed then
					sdlog.d("Button " .. num .. " released.")
					onrelease[num]()
				end
			end)
		end
	end
end)
