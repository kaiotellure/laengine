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

	spawnPlayer(player, posX, posY, posZ, rotX, 1, 0, 0, nil)
	fadeCamera(player, true)
	setCameraTarget(player)
end

local function main()
	setTime(0, 0)
	local allPlayers = getElementsByType("player")

	for i = 1, #allPlayers do
		spawn(allPlayers[i])
	end

	-- Spawn player after death
	addEventHandler("onPlayerWasted", root, function() spawn(source) end)

	addEventHandler("onPlayerLogin", root, function(previousAccount, account)
		assert(account, "no player account")

		local savedMoney = getAccountData(account, "engine.money")
		setPlayerMoney(source, savedMoney or 1000)
		setElementData(source, "id", getAccountID(account))

		spawn(source)
	end)
	
	addEventHandler("onPlayerQuit", root, function()
		local account = getPlayerAccount(source)
		assert(account, "no player account")
		assert(not isGuestAccount(account), "was a guest account")

		local currentMoney = getPlayerMoney(source)
		setAccountData(account, "engine.money", currentMoney)
	end)
end

addEventHandler("onResourceStart", resourceRoot, main)
