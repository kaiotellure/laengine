local ATTACHED_SOUNDS = {}

function create_3d_sound(src, looped)
	local sound = playSound3D(src, 0, 0, 0, looped)
	setSoundMaxDistance(sound, 250); return sound
end

function attach_3d_sound(sound, target)
	ATTACHED_SOUNDS[target] = sound

	local destroy = function() deattach_3d_sound(target) end
	addEventHandler("onClientElementDestroy", target, destroy)

	if getElementType(target) == "vehicle" then
		addEventHandler("onClientVehicleExplode", target, destroy)
	end
end

function deattach_3d_sound(target)
	local sound = ATTACHED_SOUNDS[target]
	if sound then destroyElement(sound) end
	ATTACHED_SOUNDS[target] = nil
end

function get_attached_3d_sound(target)
	return ATTACHED_SOUNDS[target]
end

function apply_sound_ambience_fx(sound)
	-- setSoundEffectEnabled(sound, "reverb", true)
	-- setSoundEffectParameter(sound, "reverb", "reverbMix", -18)
	-- setSoundEffectParameter(sound, "reverb", "reverbTime", 17)

	-- setSoundEffectEnabled(sound, "flanger", true)
	-- setSoundEffectParameter(sound, "flanger", "depth", 5)

	setSoundEffectEnabled(sound, "parameq", true)
	setSoundEffectParameter(sound, "parameq", "center", 3500)
	setSoundEffectParameter(sound, "parameq", "bandwidth", 36)
	setSoundEffectParameter(sound, "parameq", "gain", -15)
end

function remove_sound_ambience_fx(sound)
	-- setSoundEffectEnabled(sound, "reverb", false)
	-- setSoundEffectEnabled(sound, "flanger", false)
	setSoundEffectEnabled(sound, "parameq", false)
end

addEventHandler("onClientPreRender", root, function()
	for target, sound in pairs(ATTACHED_SOUNDS) do
		local x, y, z = getElementPosition(target)
		setElementPosition(sound, x, y, z)

		if getElementType(target) == "vehicle" then
			local open_ratio = 0
			for i = 2, 3 do open_ratio = open_ratio + getVehicleDoorOpenRatio(target, i) end
			open_ratio = open_ratio / 2

			local offset = (open_ratio - 0.5) * 1.30

			local inside = getPedOccupiedVehicle(getLocalPlayer()) == target
			setSoundVolume(sound, inside and 1 or 1 + offset)
			setSoundMaxDistance(sound, inside and 200 or 50 + 200 * open_ratio)

			--DEBUG["open_ratio"] = open_ratio
			--DEBUG["offset"] = offset
			--DEBUG["volume"] = inside and 1 or 1 + offset
			--DEBUG["distance"] = inside and 200 or 50 + 200 * open_ratio
		end
	end
end)