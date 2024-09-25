local RADIOS = {}

addEvent("radio-sync", true)
addEventHandler("radio-sync", resourceRoot, function(target, index, uptime)
	deattach_3d_sound(target)
	if index == 0 then
		return
	end

	local station = RADIO_STATIONS[index]

	requires(station, space(station.name, station.infos), function()
		local sound = create_3d_sound(station.source, true)
		local inside = getPedOccupiedVehicle(getLocalPlayer()) == target

		if not inside then
			apply_sound_ambience_fx(sound)
		end
		setElementData(sound, "station-name", station.name)

		-- disabled as sound3d takes care of this for realistic effects
		setSoundPosition(sound, uptime % getSoundLength(sound))
		attach_3d_sound(sound, target)
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

	local function onExplode()
		wheel.stopRendering()
		unbindKey("radio_previous", "down", wheel.show)
		unbindKey("radio_previous", "up", wheel.hide)
	end

	addEventHandler("onClientVehicleExplode", vehicle, onExplode)

	local function enteredIntoAnotherVehicle(player)
		if player == getLocalPlayer() and source ~= vehicle then
			onExplode()
			removeEventHandler("onClientVehicleEnter", root, enteredIntoAnotherVehicle)
		end
	end
	addEventHandler("onClientVehicleEnter", root, enteredIntoAnotherVehicle)

	addEventHandler("onClientVehicleStartExit", vehicle, function(player)
		if player == getLocalPlayer() then
			removeEventHandler("onClientVehicleExplode", vehicle, onExplode)
			removeEventHandler("onClientVehicleEnter", root, enteredIntoAnotherVehicle)
			onExplode()
		end
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
	if player == getLocalPlayer() then
		local vehicle = source
		local sound = get_attached_3d_sound(vehicle)

		-- only front seats can control radio
		if seat < 2 then
			bindRadioControls(source, function()
				local sound = get_attached_3d_sound(vehicle)
				if sound then
					return getElementData(sound, "station-name")
				end
				return "DESLIGADO"
			end)
		end

		if sound then
			remove_sound_ambience_fx(sound)
		end
		TIP(3, 1) -- display radio tip notification, chance = 1/3
	end
end)

addEventHandler("onClientVehicleStartExit", root, function(player, seat)
	if player == getLocalPlayer() then
		local sound = get_attached_3d_sound(source)
		if sound then
			apply_sound_ambience_fx(sound)
			-- display doors tip notification for front
			-- seat seaters only, chance = 1/15
			if seat < 2 then
				TIP(15, 2)
			end
		end
	end
end)

