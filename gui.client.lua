-- GUI globals
SX, SY = guiGetScreenSize() -- absolute screen dimension
RX, RY = SX / 1280, SY / 720 -- ratio for my resolution
CX, CY = SX / 2, SY / 2 -- center of screen

-- Gets the dimension from a file in the path specified.
---@param path string the path for the image
---@return integer width, integer height
function GET_IMAGE_SIZE(path)
	local file = fileOpen(path)
	assert(file, "could not open file:", path)

	local size = fileGetSize(file)
	assert(size, "could not get file size:", path)

	local pixels = fileRead(file, size)
	fileClose(file)

	return dxGetPixelsSize(pixels)
end

function WHEEL_SELECTOR(items, radius, on_selection, getCurrentName)
	-- angle between each item; the spacing size.
	local pad_angle = PI2 / #items
	local selected_item_index = 0

	-- center circle
	local cc_size = radius * 0.5
	local cc_x, cc_y = CX - cc_size / 2, CY - cc_size / 2

	local last_hovered = 0
	local last_hovered_name = "NENHUM"

	local function render()
		local render_start = getTickCount()
		DRAW_FULL_SCREEN_FX(true)

		-- this shadow helps in the contrast of the bg and the radio controls
		dxDrawImage(0, 0, SX, SY, "assets/center_shadow.png")

		-- stylua: ignore
		dxDrawImage(
			cc_x, cc_y, cc_size, cc_size,
			"assets/center_circle.png", 0, 0, 0,
			selected_item_index == 0 and COLORS.red or nil
		)

		local current = space(ICONS.Radio, getCurrentName())
		local cw, ch = dxGetTextSize(current, 0, 1, FONTS.Switzer)
		dxDrawBorderedText(1, current, CX - cw / 2, ch, cw, ch, COLORS.gray, 1, FONTS.Switzer)

		local sw, sh = dxGetTextSize(last_hovered_name, 0, 1, FONTS.SignPainterMedium)
		-- stylua: ignore
		dxDrawBorderedText(
			1, last_hovered_name, -- outline, text
			CX - sw / 2, sh + ch - 10, sw, sh, -- x, y, width, height
			COLORS.White, 1, -- color, scale
			FONTS.SignPainterMedium -- font
		)

		-- getCursorPosition returns a relative 0-1 float
		-- so we convert into an absolute resolution
		local cursorx, cursory = getCursorPosition()
		cursorx, cursory = cursorx * SX, cursory * SY

		local x_normal, y_normal = cursorx - CX, cursory - CY
		local distance_from_center = sqrt(x_normal ^ 2 + y_normal ^ 2)

		if distance_from_center < cc_size / 2 then
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
			mouse_angle = rot(mouse_angle, pad_angle / 2, PI2)
			selected_item_index = ceil(mouse_angle / pad_angle)
		end

		for i, item in ipairs(items) do
			-- (i-1) so there is no spacing on the first item
			-- - math.pi to match the mouse_angle offset above
			local rotation_angle = pad_angle * (i - 1) - PI

			-- x and y range from -1...1, so we amplify its radius so that
			-- they are further away and not glued together
			-- swapped to go around clock wise
			local x, y = cos(rotation_angle), sin(rotation_angle)
			x, y = x * radius, y * radius

			local w = cc_size -- item.width * ratio
			local h = cc_size -- item.height * ratio

			if i == selected_item_index then
				if i ~= last_hovered then
					playSound("assets/soundfx/hover.mp3")
				end

				last_hovered = i
				last_hovered_name = item.name

				local padding = 16 * RX
				-- stylua: ignore
				dxDrawImage(
					CX + x - w / 2 - padding, -- x
					CY + y - h / 2 - padding, -- y
					w + padding * 2, h + padding * 2, -- width, height
					"assets/gradient_square.png", -- path
					0, 0, 0, COLORS.gray -- rotation, pivotx, pivoty, color
				)
			end

			dxDrawImage(CX + x - w / 2, CY + y - h / 2, w, h, item.src)
		end

		DEBUG["radio wheel render time"] = (getTickCount() - render_start) / 1000
	end

	local function startRendering()
		addEventHandler("onClientRender", root, render, true, "low-6.0")
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
			setCursorPosition(CX, CY)
			showCursor(true, false)
		end,
		hide = function()
			stopRendering()
			playSound("assets/soundfx/select.mp3")
			on_selection(selected_item_index)
		end,
	}
end

local function font(name, size)
	return dxCreateFont("assets/" .. name .. ".ttf", size or 10, false, "antialiased") or FONTS.Default
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	FONTS.Switzer = font("switzer-regular")
	FONTS.SwitzerMedium = font("switzer-regular", 15)

	FONTS.SignPainter = font("signpainter")
	FONTS.SignPainterMedium = font("signpainter", 20)
end)

