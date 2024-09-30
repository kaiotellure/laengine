addCommandHandler('car', function(user)
	if getElementType(user) == "console" then
		return print("console tried using an in-game only command.")
	end

	local player = user --[[@as Player]]
	local x, y, z = getElementPosition(player)

	local vehicle = createVehicle(411, x, y, z)
	warpPedIntoVehicle(player, vehicle)
end)

---@param player Player
local function spawn(player)
	player = player or source
	local random_spawn = SPAWNS[math.random(#SPAWNS)]

	local posX, posY, posZ, rotX = unpack(random_spawn)
	posX, posY = posX + math.random(-1, 1), posY + math.random(-1, 1)

	spawnPlayer(player, posX, posY, posZ, rotX, 1, 0, 0, nil)
	fadeCamera(player, true)
	setCameraTarget(player)

	for _, id in ipairs({1, 4, 23, 30, 27, 29, 34, 35, 16, 42, 14, 46, 39}) do
		giveWeapon(player, id)
	end
end

local function main()
	setTime(0, 0)

	---@type Player[]
	local players = getElementsByType("player")

	for i = 1, #players do
		spawn(players[i])
	end

	addEventHandler("onPlayerWasted", root, function()
		spawn(source --[[@as Player]])
	end)

	addEventHandler("onPlayerLogin", root, function(_, account)
		local player = source --[[@as Player]]

		local savedMoney = getAccountData(account, "engine.money")
		setPlayerMoney(player, tonumber(savedMoney or 1000))

		local id = getAccountID(account)
		assert(id, "could not get account id.")

		setElementData(player, "id", id)
		spawn(player)
	end)

	addEventHandler("onPlayerQuit", root, function()
		local player = source --[[@as Player]]

		local account = getPlayerAccount(player)
		assert(account, "no player account")

		assert(not isGuestAccount(account), "was a guest account")

		local currentMoney = getPlayerMoney(player)
		setAccountData(account, "engine.money", currentMoney)
	end)
end

addEventHandler("onResourceStart", resourceRoot, main)
