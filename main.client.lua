
addEventHandler("onClientResourceStart", resourceRoot, function()
	setPlayerHudComponentVisible("all", false)
	disable_default_radio()
	showChat(false)
end)

addEventHandler("onClientVehicleEnter", root, function(player)
	if player == getLocalPlayer() then
		setPlayerHudComponentVisible("radar", true)
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