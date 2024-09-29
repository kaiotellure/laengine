local function drawWheelSlice(angles, sizes, colors, callbacks)
   local vertices, bvertices = {}, {}
   local step = angles.width / angles.precision

   for i = 0, angles.precision do
      local rx = sin(angles.start + step*i)
      local ry = cos(angles.start + step*i)

      -- box bottom vertices
      table.insert(vertices, {
         CX + rx * sizes.radius,
         CY + ry * sizes.radius,
         colors.box_bottom
      })

      -- box upper vertices
      table.insert(vertices, {
         CX + rx * (sizes.radius+sizes.box),
         CY + ry * (sizes.radius+sizes.box),
         colors.box_upper
      })

      -- border bottom vertices (same as above)
      table.insert(bvertices, {
         CX + rx * (sizes.radius+sizes.box),
         CY + ry * (sizes.radius+sizes.box),
         colors.border_bottom
      })

      -- border upper vertices
      table.insert(bvertices, {
         CX + rx * (sizes.radius+sizes.box + sizes.border),
         CY + ry * (sizes.radius+sizes.box + sizes.border),
         colors.border_upper
      })
   end

   -- the current mta lua version hasnt deprecated unpack yet.
   dxDrawPrimitive("trianglestrip", false, unpack(vertices))
   dxDrawPrimitive("trianglestrip", false, unpack(bvertices))

   local ca = angles.start + angles.width / 2
   local crx, cry = sin(ca), cos(ca)

   callbacks.drawAtCenter(
      CX + crx * (sizes.radius + sizes.box/2),
      CY + cry * (sizes.radius + sizes.box/2),

      angles._part_index+1,
      angles._is_hovering
   )
end

local function drawWheel(params, callbacks)
   local ac = 0

	local cx, cy = getCursorPosition()
	cx, cy = cx * SX, cy * SY

	-- the current mta lua version hasnt deprecated atan2 yet.
	local angle = (atan2(cx - CX, cy - CY) + params.offset) % PI2
	DEBUG["ANGLE"] = angle

   for i = 0, params.parts-1 do
		local start = ac -- - offset
      local width = i%2 == 0 and params.bigger or params.smaller

		local hovered = angle >= start and angle < (start+width)
      local colors = callbacks.getColors(i+1, hovered)

      drawWheelSlice({
         start = start - params.offset,
         width = width - params.pad,
         precision = params.precision,

         _part_index = i,
         _is_hovering = hovered
      }, {
         radius = 200, box = 75,
         border = hovered and 4 or 3
      }, {
         box_bottom = tocolor(10, 10, 10, 100),
         box_upper = colors.box_upper,
         border_bottom = colors.border,
         border_upper = colors.border
      }, callbacks)

      ac = ac + width
   end
end

local function createWheel(config, callbacks)
	config.part_width = PI2 / config.parts
   config.pad = config.part_width * config.padding

   config.bigger = config.part_width * (1 + config.sides_amplification)
   config.smaller = config.part_width * (1 - config.sides_amplification)

   config.offset = config.bigger/2 --+ config.pad
	return function()
		drawWheel(config, callbacks)
	end
end

addEventHandler("onClientResourceStart", resourceRoot, function()
   local weapons = {}
   local ratio = .35

   table.insert(weapons, WEAPONS[31])
   table.insert(weapons, WEAPONS[30])
   table.insert(weapons, WEAPONS[22])
   table.insert(weapons, WEAPONS[23])

   local lastHovered = 1
   local selected = 1

   local purple = tocolor(200,0,100, 255)
   local weak_purple = tocolor(200,0,100, 100)
   local black = tocolor(0, 0, 0, 200)
   local weak_black = tocolor(10, 10, 10, 100)

	local wheel = createWheel({
		parts = 8, sides_amplification = 0.20,
		padding = 0.01, precision = 12
	}, {
      getColors = function(part, hovering)
         return {
            border = selected == part and purple or black,
            box_upper = hovering and weak_purple or weak_black
         }
      end,
      drawAtCenter = function(x, y, part, hovering)
         local weapon = weapons[part]
         if weapon then

            if hovering and lastHovered ~= part then
               playSound("assets/soundfx/select.mp3")
               lastHovered = part
            end

            local w, h = GET_IMAGE_SIZE(weapon.icon)
            w, h = w*ratio, h*ratio
            dxDrawImage(x-w/2, y-h/2, w, h, weapon.icon)
         end
      end
   })

	addEventHandler("onClientRender", root, function()
		showCursor(true, false)
		DRAW_FULL_SCREEN_FX(true)
	
		wheel()
	end)
end)