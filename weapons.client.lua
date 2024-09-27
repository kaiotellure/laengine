local SOUND_MAX_DISTANCE = 300

local function onShotsFired(weaponId)
	local player = source --[[@as Player]]

	local mx, my, mz = getPedWeaponMuzzlePosition(player)
	assert(mx, "could not retrieve ped weapon muzzle position.")

	local sounds = WEAPONS[weaponId]

	if sounds and sounds.fire then
		local sound = playSound3D(sounds.fire, mx, my, mz)
		setSoundMaxDistance(sound, SOUND_MAX_DISTANCE)
	end
end

addEventHandler("onClientPlayerWeaponFire", root, onShotsFired)

