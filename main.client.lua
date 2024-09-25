
addEventHandler("onClientResourceStart", resourceRoot, function()
	setPlayerHudComponentVisible("all", false)
	setPlayerHudComponentVisible("crosshair", true)

	disable_default_radio()
	-- disable default gun sounds
	setAmbientSoundEnabled("gunfire", false)
	-- setWorldSoundEnabled(5, false)
end)

addEventHandler("onClientPlayerSpawn", getLocalPlayer(), function()
	showChat(false)
end)

addEventHandler("onClientVehicleEnter", root, function(player)
	if player == getLocalPlayer() then
		setPlayerHudComponentVisible("radar", true)
	end
end)

addEventHandler("onClientVehicleStartEnter", root, function(player)
	if player == getLocalPlayer() then
		local weapon = getPedWeapon(getLocalPlayer())
		if weapon >= 9 then setTimer(tip, 2000, 1, 10, 3) end
	end
end)

addEventHandler("onClientVehicleStartExit", root, function(player)
	if player == getLocalPlayer() then
		setPlayerHudComponentVisible("radar", false)
	end
end)

addCommandHandler('pos', function()
	local x, y, z = getElementPosition(getLocalPlayer())
	local fmt = x..", "..y..", "..z
	outputChatBox("Copied: "..fmt.."!")
	setClipboard(fmt)
end)

-- Disable default game radio
function disable_default_radio()
	setRadioChannel(0)
	addEventHandler('onClientPlayerRadioSwitch', root, function() cancelEvent() end)
end