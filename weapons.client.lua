local SOUND_MAX_DISTANCE = 300

local function onShotsFired(weaponId, _, ammoInClip)
	local mx, my, mz = getPedWeaponMuzzlePosition(source)
	local sounds = WEAPONS[weaponId]

	if sounds and sounds.fire then
		local sound = playSound3D(sounds.fire, mx, my, mz)
		setSoundMaxDistance(sound, SOUND_MAX_DISTANCE)

		--local x, y, z = getElementPosition(getLocalPlayer())
		--local distanceMeToShot = getDistanceBetweenPoints3D(x, y, z, mx, my, mz)

		--if distanceMeToShot > 25 then
			--setSoundEffectEnabled(sound, "reverb", true)

			--local verbDecay = 3000*(distanceMeToShot/SOUND_MAX_DISTANCE)
			--local ok = pcall(setSoundEffectParameter, sound, "reverb", "reverbTime", verbDecay)

			--DEBUG["shots reverb decay"] = verbDecay
			--DEBUG["ok"] = ok
		--end
	end
end

addEventHandler("onClientPlayerWeaponFire", root, onShotsFired)