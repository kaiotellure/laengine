Autolab = {}
Autolab.__index = Autolab

local CARS = {
	{id = 587, time = 2, cost = 1}, -- Euros
	{id = 400, time = 2, cost = 1}, -- Landstalker
	{id = 561, time = 2, cost = 1}, -- Stratum
	{id = 411, time = 2, cost = 1} -- Infernus
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
	self.areaMarker = createMarker(
		self.pos.x, self.pos.y, self.pos.z-1,
		"cylinder", size, 255, 0, 5, 25
	)
	
	addEventHandler("onMarkerHit", self.areaMarker, function(element)
		if getElementType(element) == "player" and self.cancelingJob and self.cancelingJob.owner == element then
			killTimer(self.cancelingJob.timer)
			self.cancelingJob = nil

			triggerClientEvent(element, "delete-notification", resourceRoot, "autolab-job-canceling")
		end
	end)

	addEventHandler("onMarkerLeave", self.areaMarker, function(element)
		if getElementType(element) == "player" and self.currentJob and self.currentJob.owner == element then
			local seconds = 25

			local timer = setTimer(function()
				assert(self.currentJob, "no current job to be canceled")
				-- prevents canceling futures jobs from others players if the previous production
				-- was faster than the canceling time spam, and another player started a new production
				-- between the fast production job completion and this canceling job
				if self.currentJob.owner ~= self.cancelingJob.owner then return end

				killTimer(self.currentJob.timer)
				destroyElement(self.currentJob.skeleton)

				triggerClientEvent(element, "delete-notification", resourceRoot, "autolab-job")
				self.currentJob.onCancel()

				self.currentJob = nil
				self.cancelingJob = nil
			end, seconds*1000, 1)

			self.cancelingJob = {timer = timer, owner = element}
			triggerClientEvent(element, "job-notification", resourceRoot, "autolab-job-canceling", "Volte para o laboratório em 25s ou a produção do veículo irá ser cancelada.", seconds)
		end
	end)
end

function getPlayerScoreFor(player, job)
	local account = getPlayerAccount(player)

	local hability = getAccountData(account, "engine.hability")
	if hability ~= job then return 10 end

	return tonumber(getAccountData(account, "engine.hability.score") or 10)
end

function listAvailableCarsForScore(score)
	local availableCars = {}
	local eachSpan = 100/#CARS

	for i, car in pairs(CARS) do
		if score > eachSpan * (i-1) then
			local shallowCar = table.shallow_copy(car)
			shallowCar.weight = i
			table.insert(availableCars, shallowCar)
		end
	end

	return availableCars
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

		local score = getPlayerScoreFor(player, "auto_engineer")
		local cars = listAvailableCarsForScore(score)

		local _, car = randomItemWithWeight(cars)
		if self.ironAmount < car.cost then self.events.notenough(player) return end

		self.ironAmount = self.ironAmount - car.cost
		self:UpdateIronQuantityObjectsIndicator(.1)

		-- base car producing time plus an extra based on how bad the player score
		local secondsToFinish = car.time + (car.time * 1/score)
		destroyElement(marker)

		local skeleton = createVehicle(car.id, self.releasePosition)
		blowVehicle(skeleton, false)

		triggerClientEvent(player, "job-notification", resourceRoot, "autolab-job", "Você #ffe08cestá# produzindo um veículo, #ffe08csair# do laboratório irá #ffe08ccancelar# a produção.", secondsToFinish)
		
		local timer = setTimer(function()

			destroyElement(skeleton)
			local vehicle = createVehicle(car.id, self.releasePosition)

			-- base 1000 health plus upto 5000 based on score
			local health = 1000 + score/100 * 5000
			setElementHealth(vehicle, health)

			setVehiclePlateText(vehicle, tostring(health))
			setVehicleColor(vehicle, self.vehiclesColor, self.vehiclesColor, self.vehiclesColor, self.vehiclesColor)

			if self.cancelingJob then
				-- if the production was faster than the canceling timeout, cancel the canceling job
				-- this happens aprox. if the car time is less than 25s
				killTimer(self.cancelingJob.timer)
				self.cancelingJob = nil

				triggerClientEvent(player, "delete-notification", resourceRoot, "autolab-job-canceling")
			end

			self.currentJob = nil
			self:CreateWorkingSpot(x, y, z)
		end, secondsToFinish*1000, 1)

		local onCancel = function() self:CreateWorkingSpot(x, y, z) end
		self.currentJob = {timer = timer, owner = player, skeleton = skeleton, onCancel = onCancel}
	end)
end

local lab = Autolab.new(Vector3(-721.0, 916.3, 12.1))
lab.name = "Laboratório Automotivo Da Costa Norte"

lab.releasePosition = Vector3(-722.6, 938.1, 12.1)
lab.ironStackPosition = Vector3(-692, 961, 12.2)

lab.vehiclesColor = 0
lab.ironAmount = CARS[#CARS].cost*5
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