function chat(message, ...)
	outputChatBox(string.format(message, ...), 255, 255, 0, true)
end

-- binds a key, when it is pressed or 10s has passed with no interaction
-- it unbinds
function bind_once(key, once_pressed)
	local function proceed()
		once_pressed()
		unbindKey(key, "up", proceed)
	end

	bindKey(key, "up", proceed)
	setTimer(unbindKey, 10000, 1, key, "up", proceed) -- timeout
end

-- interface can be any table containing a source key
function requires(interface, reason, when_ready)
	local available = fileExists(interface.source)
	if not available then textNotify("expansions", space(ICONS.Download, "Aguarde enquanto baixamos recursos adicionais: #ffe08c", reason), 5) end

	local function on_downloaded(completed_path, success)
		if completed_path == interface.source then
			if success then when_ready(interface) end
			removeEventHandler("onClientFileDownloadComplete", root, on_downloaded)
		end 
	end

	addEventHandler("onClientFileDownloadComplete", root, on_downloaded)
	downloadFile(interface.source)
end

addCommandHandler("delete", function(_, path)
	fileDelete(path)
end)