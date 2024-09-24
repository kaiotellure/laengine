local start_tick = getTickCount() + math.random(3600)*1000

addEvent("radio-set-station", true)
addEventHandler("radio-set-station", resourceRoot, function(index)

	local vehicle = getPedOccupiedVehicle(client)
	assert(vehicle, "player is not in vehicle.")

	local seconds_since_start = (getTickCount() - start_tick) / 1000
	triggerClientEvent("radio-sync", resourceRoot, vehicle, index, seconds_since_start)
end)
