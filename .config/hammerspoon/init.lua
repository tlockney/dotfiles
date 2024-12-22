hs.logger.defaultLogLevel = 'debug'

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
myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")

hs.hotkey.bind({ "Alt" }, "`", function()
      wezTask = hs.task.new("/opt/homebrew/bin/wezterm",
		  nil,
		  function(task, stdOut, stdErr)
		     if not stdErr == '' then
			wuakeLog.e("error:" .. stdErr)
		     end
		     if not stdOut == '' then
			wuakeLog.i(stdOut)
		     end
		     return true
		  end,
		  {"connect", "wuake"})
      wezTask:start()
end)
