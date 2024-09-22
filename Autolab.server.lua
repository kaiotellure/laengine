Autolab = {}
Autolab.__index = Autolab

local cars = {
	{id = 587, time = 10, cost = 1}, -- Euros
	{id = 415, time = 20, cost = 3}, -- Cheetah
	{id = 411, time = 30, cost = 5} -- Infernus
}

function Autolab.new(pos)
	local instance = {
		pos = pos, events = {},
		blip = createBlip(pos.x, pos.y, pos.z, BLIPS.Garage)
	}
	return setmetatable(instance, Autolab)
end

function getObjectScaleFromId(id)
	local obj = createObject(3386, 0,0,1000)
	local sx, sy, sz = getObjectScale(obj)
	destroyElement(obj)
	return sx, sy, sz
end

function Autolab:UpdateIronQuantityObjectsIndicator(padding)
	self.ironObjects = self.ironObjects or {}

	for i, obj in ipairs(self.ironObjects) do
		if i >= self.ironAmount and obj then
			destroyElement(obj)
			self.ironObjects[i] = nil
		end
	end

	local o = self.ironStackPosition
	local sx, sy = getObjectScaleFromId(3386)

	sx, sy = sx + padding, sy + padding
	local square = sqrt(self.ironAmount)

	for i=1, self.ironAmount do
		if not self.ironObjects[i] then
			self.ironObjects[i] = createObject(
				3386, o.x + floor((i-1)/square)*sx,
				o.y + floor((i-1)%square)*sy,
				o.z-1, 0, 0, 0, true
			)
		end
	end
end

function Autolab:DefineAreaSize(size)
	self.area = createMarker(
		self.pos.x, self.pos.y, self.pos.z-1,
		"cylinder", size, 20, 0, 50, 10
	)
	
	addEventHandler("onMarkerHit", self.area, function(element)
		if getElementType(element) == "player" then
			triggerClientEvent(
				element, "text-notification", resourceRoot,
				"autolab", space("Você está entrando no", self.name), 3
			)
		end
	end)
end

function Autolab:ListKnownCarsAndGetWasteRatio(player)
	local vehicle_list = {}
	local account = getPlayerAccount(player)

	local isProfessional = getAccountData(account, "engine.hability") == "auto_engineer"
	local score = tonumber(getAccountData(account, "engine.hability.score"))

	local each = 100/#cars

	for i, car in pairs(cars) do
		if score > each*(i-1) then
			local car_copy = table.shallow_copy(car)
			car_copy.weight = i
			table.insert(vehicle_list, car_copy)
		end
	end

	return vehicle_list, isProfessional and 1/score or 1
end

function Autolab:OutputVehicle(id)
	local vehicle = createVehicle(id, self.releasePosition)
	setElementHealth(vehicle, 10000)
end

function Autolab:IsReleaseSpotOccupied(radius)
	for i, vehicle in pairs(getElementsByType("vehicle")) do

		local r = self.releasePosition
		local x,y,z = getElementPosition(vehicle)

		local distance = getDistanceBetweenPoints3D(r.x,r.y,r.z, x,y,z)
		if distance < radius then return vehicle end
	end
end

function whenPlayerHitMarkerAndIsNotInCar(marker, callback)
	addEventHandler("onMarkerHit", marker, function(element)
		if getElementType(element) == "player" and getPedOccupiedVehicle(element) == false then
			callback(element)
		end
	end)
end

function Autolab:CreateWorkingSpot(x, y, z)
	local marker = createMarker(x, y, z-1, "cylinder", 2, nil, nil, nil, 10)
	whenPlayerHitMarkerAndIsNotInCar(marker, function(player)

		local blockingVehicle = self:IsReleaseSpotOccupied(5)
		if blockingVehicle then self.events.blocked(player, blockingVehicle) return end

		local cars, waste = self:ListKnownCarsAndGetWasteRatio(player)
		local _, choosen = random_item_with_weight(cars)

		local cost = floor(choosen.cost*(1+waste))
		if self.ironAmount < cost then self.events.notenough(player) return end

		self.ironAmount = self.ironAmount - cost
		self:UpdateIronQuantityObjectsIndicator(.1)

		local seconds = choosen.time*(1+waste)
		destroyElement(marker)

		triggerClientEvent(player, "job-notification", resourceRoot, "autolab-job", "Você #ffe08cestá# produzindo um veículo, #ffe08csair# do laboratório irá #ffe08ccancelar# a produção.", seconds)
		setTimer(function()
			self:OutputVehicle(choosen.id)
			self:CreateWorkingSpot(x, y, z)
		end, seconds*1000, 1)
	end)
end

local lab = Autolab.new(Vector3(-721.0, 916.3, 12.1))
lab.name = "Laboratório Automotivo Da Costa Norte"

lab.releasePosition = Vector3(-722.6, 938.1, 12.1)
lab.ironStackPosition = Vector3(-713.6, 957.8, 12.2)

lab.vehiclesColor = 0
lab.ironAmount = cars[#cars].cost*5
lab:UpdateIronQuantityObjectsIndicator(.1)

lab:CreateWorkingSpot(-721.3, 926.5, 12.1)
lab:DefineAreaSize(50)

lab.events.blocked = function(player, vehicle)
	triggerClientEvent(
		player, "text-notification", resourceRoot, "autolab",
		space("Um", getVehicleName(vehicle), "está ocupando a área de produção de veículos, retire-o primeiro."), 5
	)
end

lab.events.notenough = function(player)
	triggerClientEvent(player, "text-notification", resourceRoot, "autolab", space(ICONS.Alert, "Quantidade de aço insuficiente no armazém."), 4);
end