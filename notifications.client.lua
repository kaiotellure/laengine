local NOTIFICATIONS = {}

function textNotify(id, text, duration)
	duration = duration or 5 -- default duration when not specified

	-- creates new or overwrites existing notifications with the same id
	NOTIFICATIONS[id] = Notification.new(10)
	local notification = NOTIFICATIONS[id]

	-- render multiline text, and add to be rendered by notification container
	local multitext = MultilineText.new(text, 300)
	multitext:Render(); notification:AddComponent(multitext)

	-- render notification container
	notification:Render()
	playSound("assets/soundfx/blip.mp3")

	-- using __disabled, notification container will ignore and if a new notification overwrote it
	-- the lua garbage collector will delete it
	setTimer(function() notification.__disabled = true end, duration*1000, 1)
end

addEvent("text-notification", true)
addEventHandler("text-notification", resourceRoot, textNotify)

function jobNotify(id, text, duration)
	assert(not NOTIFICATIONS[id], "job notifications needs to be unique")
	duration = duration or 5 -- default duration when not specified

	NOTIFICATIONS[id] = Notification.new(10)
	local notification = NOTIFICATIONS[id]

	-- render multiline text, and add to be rendered with notification container
	local multitext = MultilineText.new(text, 300)
	multitext:Render(); notification:AddComponent(multitext)

	-- render progress bar, and add to be rendered with notification container
	local progress = Progress.new(multitext.width)
	progress:Render(); notification:AddComponent(progress)

	-- render notification container
	notification:Render()
	playSound("assets/soundfx/blip.mp3")

	local lapsed = 0
	setTimer(function()
		lapsed = lapsed + 1
		if lapsed >= duration then
			killTimer(sourceTimer)
			NOTIFICATIONS[id] = nil
		end

		progress:SetValue(lapsed/duration*100); progress:Render()
		notification:Render()
	end, 1000, 0)
end

addEvent("job-notification", true)
addEventHandler("job-notification", resourceRoot, jobNotify)

function deleteNotification(id)
	NOTIFICATIONS[id] = nil
end

addEvent("delete-notification", true)
addEventHandler("delete-notification", resourceRoot, deleteNotification)

local function everyFrame()
	local acumulated_height = 0

	for id, notification in pairs(NOTIFICATIONS) do
		if not notification.__disabled then
			dxDrawImage(
				64*rx, -- 64 pixels to the right adjusted for every screen size
				(64*ry + acumulated_height), -- 64 also adjusted, down + previous notifications
				notification.width, notification.height, notification.target
			)
			-- tell next notification where to y render, 5 is the padding
			acumulated_height = acumulated_height + notification.height + 5
		end
	end
end

addEventHandler("onClientRender", root, everyFrame)
addEventHandler( "onClientResourceStart", getRootElement(), function ()
	textNotify("test1", "This is a test notification.", 10)
	textNotify("test2", "This is another test notification.", 10)
end )