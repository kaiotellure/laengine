---@alias WorldElement Player | Vehicle | Object

---@type table<WorldElement, Sound|nil>
local ATTACHED_SOUNDS = {}

---@param src string path or url to the sound content.
---@param looped boolean should the audio start again when finished.
--
function CREATE_3D_SOUND(src, looped)
	local sound = playSound3D(src, 0, 0, 0, looped)
	setSoundMaxDistance(sound, 250); return sound
end

---@param sound Sound the sound.
---@param target WorldElement the element the sound will follow.
--
function ATTACH_3D_SOUND(sound, target)
	ATTACHED_SOUNDS[target] = sound

	local function clear() DEATTACH_3D_SOUND(target) end
	addEventHandler("onClientElementDestroy", target, clear)

	if getElementType(target) == "vehicle" then
		addEventHandler("onClientVehicleExplode", target, clear)
	end
end

---@param target WorldElement
--
function DEATTACH_3D_SOUND(target)
	local sound = GET_ATTACHED_3D_SOUND(target)
	if sound then destroyElement(sound) end
	ATTACHED_SOUNDS[target] = nil
end

---@param target WorldElement
--
function GET_ATTACHED_3D_SOUND(target)
	return ATTACHED_SOUNDS[target]
end

-- this will apply equalization, reverb and flanger to make the sound appears
-- affected by atmosphere chaotic events thus sounding like being played in real-life.
---@param sound Sound
--
function APPLY_AMBIENCE_FX(sound)
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

---@param sound Sound
--
function REMOVE_AMBIENCE_FX(sound)
	-- setSoundEffectEnabled(sound, "reverb", false)
	-- setSoundEffectEnabled(sound, "flanger", false)
	setSoundEffectEnabled(sound, "parameq", false)
end

addEventHandler("onClientPreRender", root, function()
	for target, sound in pairs(ATTACHED_SOUNDS) do
		local x, y, z = getElementPosition(target)
		setElementPosition(sound, x, y, z)

		if getElementType(target) == "vehicle" then
			---@cast target Vehicle

			local open_ratio = 0

			for i = 2, 3 do
				open_ratio = open_ratio + getVehicleDoorOpenRatio(target, i)
			end

			open_ratio = open_ratio / 2

			local offset = (open_ratio - 0.5) * 1.30

			local inside = getPedOccupiedVehicle(localPlayer) == target
			setSoundVolume(sound, inside and 1 or 1 + offset)
			setSoundMaxDistance(sound, inside and 200 or 50 + 200 * open_ratio)

			--DEBUG["open_ratio"] = open_ratio
			--DEBUG["offset"] = offset
			--DEBUG["volume"] = inside and 1 or 1 + offset
			--DEBUG["distance"] = inside and 200 or 50 + 200 * open_ratio
		end
	end
end)