addEvent("radio-sync", true)
addEventHandler("radio-sync", resourceRoot, function(target, index, uptime)
	---@cast target WorldElement
	---@cast index integer
	---@cast uptime number

	local currentSound = GET_ATTACHED_3D_SOUND(target)
	if currentSound and index == getElementData(currentSound, "station-index") then
		return -- if this sound is changing to the same station, do nothing.
	end

	-- destroy current sound attached to this target
	-- if we are turning off the radio (0), stop here.
	DEATTACH_3D_SOUND(target)
	if index == 0 then return end

	local station = RADIO_STATIONS[index]

	requires(station, space(station.name, station.infos), function()
		local sound = CREATE_3D_SOUND(station.source, true)
		local inside = getPedOccupiedVehicle(localPlayer) == target

		if not inside then
			APPLY_AMBIENCE_FX(sound)
		end

		setElementData(sound, "station-name", station.name)
		setElementData(sound, "station-index", index)

		setSoundPosition(sound, uptime % getSoundLength(sound))
		ATTACH_3D_SOUND(sound, target)
	end)
end)

local function bindRadioControls(vehicle, getCurrentName)
	local images = {}

	for _, station in ipairs(RADIO_STATIONS) do
		local width, height = GET_IMAGE_SIZE(station.logo)
		table.insert(images, {
			src = station.logo,
			width = width,
			height = height,
			name = station.name,
		})
	end

	local wheel = WHEEL_SELECTOR(images, 175, function(index)
		triggerServerEvent("radio-set-station", resourceRoot, index)
	end, getCurrentName)

	bindKey("radio_previous", "down", wheel.show)
	bindKey("radio_previous", "up", wheel.hide)

	local function clear()
		wheel.stopRendering()
		unbindKey("radio_previous", "down", wheel.show)
		unbindKey("radio_previous", "up", wheel.hide)

		removeEventHandler("onClientVehicleExplode", vehicle, clear)
	end
	addEventHandler("onClientVehicleExplode", vehicle, clear)

	addEventHandler("onClientVehicleStartExit", vehicle, function(player)
		if player == getLocalPlayer() then clear() end
	end)
end

-- chance is = 1/chance, index is the tip text you want, if none, a random one is picked
function TIP(chance, index)
	assert(index ~= 0, "lua arrays starts on 1")

	-- choose random tip text if none was specified
	index = index == nil and math.random(#TIPS) or index
	local got = math.random(1, chance)

	--DEBUG["chance"] = chance
	--DEBUG["index"] = index
	--DEBUG["got"] = got

	if got == 1 then
		local text = TIPS[index]
		TEXT_NOTIFY("tip", text, 6)
	end
end

addEventHandler("onClientVehicleEnter", root, function(player, seat)
	if player == localPlayer then
		local vehicle = source --[[@as Vehicle]]
		local sound = GET_ATTACHED_3D_SOUND(vehicle)

		-- only front seats can control radio
		if seat < 2 then
			bindRadioControls(source, function()
				local sound = GET_ATTACHED_3D_SOUND(vehicle)

				if sound then
					return getElementData(sound, "station-name")
				end

				return "DESLIGADO"
			end)
		end

		if sound then
			REMOVE_AMBIENCE_FX(sound)
		end

		TIP(3, 1) -- display radio tip notification, chance = 1/3
	end
end)

addEventHandler("onClientVehicleStartExit", root, function(player, seat)
	if player == localPlayer then
		local vehicle = source --[[@as Vehicle]]
		local sound = GET_ATTACHED_3D_SOUND(vehicle)

		if sound then
			APPLY_AMBIENCE_FX(sound)
			-- display doors tip notification for front
			-- seat seaters only, chance = 1/15
			if seat < 2 then
				TIP(15, 2)
			end
		end
	end
end)
