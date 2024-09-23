sx, sy = guiGetScreenSize()
rx, ry = sx/1280, sy/720 -- ratio
cx, cy = sx/2, sy/2

function get_image_size(path)
	local file = fileOpen(path)
	local pixels = fileRead(file, fileGetSize(file))
	fileClose(file); return dxGetPixelsSize(pixels)
end

-- A RenderManager takes care of positining many elements together, doing jobs like
-- Calculate the size and position of elements so they are nicelly spaced
function new_render_group_manager(default_font, padding)
	local width, height = 0, 0
	local render_tasks = {}

	return {
		clear = function()
			width, height = 0, 0
			render_tasks = {}
		end,
		get_size = function()
			return width, height
		end,
		get_tasks = function()
			return render_tasks
		end,
		text = function(text, maxw)
			local expected_width, expected_height = dxGetTextSize(text, maxw, 1, 1, default_font, true)
			local previous_width, previous_height = width, height

			-- reporting used space, see this as a layout, eg. aplly padding then the text size
			-- then another padding, fot both x and y
			width = math.max(width, padding + expected_width + padding)
			height = height + padding + expected_height + padding

			table.insert(render_tasks, function()
				dxDrawText(
					text, padding, -- x
					padding + previous_height, -- y
					padding + expected_width, -- until absolute x
					previous_height + padding + expected_height, -- until absolute y
					tocolor(255, 255, 255), 1, default_font, "left", "center", false, true
				)
			end)
		end,
		image = function(path, ratio)
			local ew, eh = get_image_size(path)
			local expected_width, expected_height = ew*ratio, eh*ratio
			local previous_width, previous_height = width, height

			-- reporting used space, i see this as a layout, eg. aplly padding then the img size
			-- then another padding, fot both x and y
			width = math.max(width, padding + expected_width + padding)
			height = height + padding + expected_height + padding

			table.insert(render_tasks, function()
				dxDrawImage(
					padding, padding + previous_height,
					expected_width, expected_height, path
				)
			end)
		end,
		background = function(color)
			table.insert(render_tasks, function()
				dxDrawRectangle(0, 0, width, height, color)
			end)
		end,
	}
end

local function execute_drawing_tasks(target, tasks)
	dxSetRenderTarget(target, true)
	dxSetBlendMode("modulate_add")

	for i, task in ipairs(tasks) do
		task()
	end

	dxSetBlendMode("blend")
	dxSetRenderTarget()
end

function render_group_manager(manager)
	local w, h = manager.get_size()
	local target = dxCreateRenderTarget(w, h, true)

	execute_drawing_tasks(target, manager.get_tasks())

	return {
		draw = function(x, y)
			dxDrawImage(x, y, w, h, target)
		end
	}
end

function wheel_selector(items, radius, on_selection, getCurrentName)

	-- angle between each item; the spacing size.
	local pad_angle = PI2 / #items
	local selected_item_index = 0

	-- center circle
	local cc_size = radius*.5
	local cc_x, cc_y = cx-cc_size/2, cy-cc_size/2

	local last_hovered = 0
	local last_hovered_name = "NENHUM"

	function render()
		dxDrawRectangle(0, 0, sx, sy, tocolor(3, 3, 3, 250)) -- background dark rect
		dxDrawImage(cc_x, cc_y, cc_size, cc_size, "assets/center_circle.png")

		local currentText = space(getCurrentName(), ICONS.ArrowRight, last_hovered_name)
		local w, h = dxGetTextSize(currentText, 0, 1, FONTS.Switzer)
		dxDrawText(currentText, cx-w/2, h, w, h, tocolor(200,200,200), 1, FONTS.Switzer)

		-- getCursorPosition returns a relative 0-1 float
		-- so we convert into an absolute resolution
		local cursorx, cursory = getCursorPosition()
		cursorx, cursory = cursorx*sx, cursory*sy

		local x_normal, y_normal = cursorx-cx, cursory-cy
		local distance_from_center = sqrt(x_normal^2 + y_normal^2)

		if distance_from_center < cc_size/2 then
			selected_item_index = 0
			last_hovered_name = "NENHUM"
		else
			-- angle of the mouse relative to the center
			-- we also add another pi, to offset negative values, so it's now
			-- 0...6.28 instead of -3.14...3.14, to easy out further indexing on items
			-- as pad_angle also uses 2pi
			local mouse_angle = atan2(y_normal, x_normal) + PI

			-- rotate mouse by half item padding angle, so that the activation area
			-- is around and not after the item angle
			mouse_angle = rot(mouse_angle, pad_angle/2, PI2)
			selected_item_index = ceil(mouse_angle / pad_angle)
		end

		for i, item in ipairs(items) do
			-- (i-1) so there is no spacing on the first item
			-- - math.pi to match the mouse_angle offset above
			local rotation_angle = pad_angle * (i-1) - PI

			-- x and y range from -1...1, so we amplify its radius so that
			-- they are further away and not glued together
			-- swapped to go around clock wise
			local x, y = cos(rotation_angle), sin(rotation_angle)
			x, y = x * radius, y * radius

			local ratio = 16/radius

			if i == selected_item_index then
				if i ~= last_hovered then
					playSound("assets/soundfx/hover.mp3")
				end
				last_hovered = i
				last_hovered_name = item.name
				ratio = ratio + .01
			end

			local w = item.width * ratio
			local h = item.height * ratio

			dxDrawImage(cx + x - w/2, cy + y - h/2, w, h, item.src)
		end
	end

	local function startRendering()
		addEventHandler("onClientRender", root, render)
	end
	
	local function stopRendering()
		removeEventHandler("onClientRender", root, render)
		showCursor(false)
	end

	return {
		startRendering = startRendering,
		stopRendering = stopRendering,

		show = function()
			startRendering()
			setCursorPosition(cx, cy)
			showCursor(true, false)
		end,
		hide = function()
			stopRendering()
			playSound("assets/soundfx/select.mp3")
			on_selection(selected_item_index)
		end
	}
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	FONTS.Switzer = dxCreateFont('assets/switzer-regular.ttf', 10, false, 'antialiased') or FONTS.Default
end)
