log = hs.logger.new("appWatcher")

function eventType(event)
	if (event == hs.application.watcher.activated) then
		return "activated"
	elseif (event == hs.application.watcher.deactivated) then
		return "deactivated"
	elseif (event == hs.application.watcher.hidden) then
		return "hidden"
	elseif (event == hs.application.watcher.unhidden) then
		return "unhidden"
	elseif (event == hs.application.watcher.launching) then
		return "launching"
	elseif (event == hs.application.watcher.launched) then
		return "launched"
	elseif (event == hs.application.watcher.terminated) then
		return "terminated"
	else
		return "unknown"
	end
end

watcher = hs.application.watcher.new(function(appName, event, appObj)
	log.i("Received " .. eventType(event) .. " from " .. appName)
	watcher = appObj:newWatcher(function(element, event, watcher, userData)
		local eventName = tostring(event)
		-- log.i("Received " .. eventName)
	end)
	watcher:start({ hs.uielement.watcher.windowCreated, hs.uielement.watcher.titleChanged, hs.uielement.watcher
			.elementDestroyed })
end)

watcher:start()
