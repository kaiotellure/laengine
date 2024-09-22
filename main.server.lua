addCommandHandler('car', function(player)
	local x, y, z = getElementPosition(player)
	local vehicle = createVehicle(411, x, y, z)
	warpPedIntoVehicle(player, vehicle)
end)

local function spawn(player)
	player = player or source
	local random_spawn = SPAWNS[math.random(#SPAWNS)]

	local posX, posY, posZ, rotX = unpack(random_spawn)
	posX, posY = posX + math.random(-1, 1), posY + math.random(-1, 1)

	spawnPlayer(player, posX, posY, posZ, rotX, 7, 0, 0, nil)
	fadeCamera(player, true)
	setCameraTarget(player)
end

local function main()
	setTime(0, 0)
	local all_players = getElementsByType("player")

	for i = 1, #all_players do
		spawn(all_players[i])
	end

	addEventHandler("onPlayerJoin", root, spawn)
	addEventHandler("onPlayerWasted", root, function() spawn(source) end)
	-- addEventHandler("onPlayerQuit", root, onPlayerQuit)
end

addEventHandler("onResourceStart", resourceRoot, main)