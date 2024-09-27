-- the tick the resource started running
BOOT_TICK = getTickCount() + math.random(3600)*1000

addEvent("radio-set-station", true)
addEventHandler("radio-set-station", resourceRoot, function(index)
	---@cast index integer

	local vehicle = getPedOccupiedVehicle(client)
	assert(vehicle, "player is not in vehicle.")

	-- report to others players the new radio station and
	-- how much seconds has passed since this resource started
	-- so they can syncronized based on the sound length as the server
	-- cant get the sound length.
	local uptime = (getTickCount() - BOOT_TICK) / 1000
	triggerClientEvent("radio-sync", resourceRoot, vehicle, index, uptime)
end)
