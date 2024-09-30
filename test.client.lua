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

local function mergeSlots(...)
   ---@alias weapon_item {id: integer, slot: integer}
   
   ---@type weapon_item[]
   local weapons = {}

   for _, slot in ipairs({...}) do
      local weaponID = getPedWeapon(localPlayer, slot)
      local ammo = getPedTotalAmmo(localPlayer, slot)

      -- insert if weapon is the fist or any weapon that have bullet
      if (weaponID ~= 0 and ammo ~= 0) or slot == 0 then
         table.insert(weapons, {
            id = weaponID, slot = slot
         })
      end
   end

   return weapons
end

---@return {scroll:integer, list:weapon_item[], update:fun(self: table)}
local function newGroup(...)
   local slots = {...}

   local group = {
      scroll = 1, list = mergeSlots(unpack(slots))
   }

   group.update = function(self)
      self.list = mergeSlots(unpack(slots))
      if self.scroll > #self.list then self.scroll = #self.list end
   end

   return group
end

addEventHandler("onClientResourceStart", resourceRoot, function()
   local ratio = .5

   local lastHovered = 1
   local selected = {id = getPedWeapon(localPlayer)}

   local groups = {
      newGroup(0, 1, 9, 10),
      newGroup(4),
      newGroup(6, 7),
      newGroup(11),
      newGroup(2),
      newGroup(8, 12),
      newGroup(5),
      newGroup(3)
   }

   local purple = tocolor(200,0,100, 255)
   local weak_purple = tocolor(200,0,100, 100)
   local black = tocolor(0, 0, 0, 125)
   local weak_black = tocolor(10, 10, 10, 100)

   local function getWeaponAtGroup(index)
      local group = groups[index == nil and lastHovered or index]
      if not group then return nil, {} end

      return group.list[group.scroll], group
   end

	local wheel = createWheel({
		parts = 8, sides_amplification = 0.20,
		padding = 0.01, precision = 12
	}, {
      getColors = function(part, hovering)
         local current = getWeaponAtGroup(part)
         local isthis = current and current.id == selected.id

         return {
            border = isthis and purple or black,
            box_upper = hovering and weak_purple or weak_black
         }
      end,
      drawAtCenter = function(x, y, part, hovering)
         local thisGroupSelectedWeapon = getWeaponAtGroup(part)
         if thisGroupSelectedWeapon then

            local infos = WEAPONS[thisGroupSelectedWeapon.id]
            local icon = infos and infos.icon or 'assets/images.png'

            if hovering and lastHovered ~= part then
               playSound("assets/soundfx/hover.mp3")
               lastHovered = part
            end

            local w, h = GET_IMAGE_SIZE(icon)
            w, h = w*ratio, h*ratio
            dxDrawImage(x-w/2, y-h/2, w, h, icon)
         end
      end
   })

   local function render()
		DRAW_FULL_SCREEN_FX(true)
		wheel()

      local current, group = getWeaponAtGroup()
      if not current then return end

      local infos = WEAPONS[current.id]
      local weaponName = infos and infos.name or getWeaponNameFromID(current.id)

      local w, h = dxGetTextSize(weaponName, 0, 1, FONTS.SignPainterMedium)
      dxDrawBorderedText(1, weaponName, CX-w/2, CY-h/2, 0, 0, nil, 1, FONTS.SignPainterMedium)

      local index = "Q "..group.scroll.."/#787878"..#group.list.." #ffffffE"
      w, h = dxGetTextSize(index, 0, 1, FONTS.SwitzerMedium, false, true)
      dxDrawBorderedText(1, index, CX-w/2, (CY-h/2) + h, 0, 0, nil, 1, FONTS.SwitzerMedium, nil, nil, nil, false, false, true)
	end

   local function scroll(direction)
      local current, group = getWeaponAtGroup()
      if not current then return end

      local new = group.scroll + direction

      group.update(group)
      local count = #group.list

      if new < 1 then
         new = #group.list
      elseif new > count then
         new = 1
      end

      group.scroll = new
      if #group.list > 1 then playSound("assets/soundfx/hover.mp3") end
   end

   local scrolldown = function() scroll(1) end
   local scrollup = function() scroll(-1) end

   bindKey("tab", "down", function()
      if getPedOccupiedVehicle(localPlayer) then return end

      for _, group in ipairs(groups) do
         group.update(group)
      end

      selected.id = getPedWeapon(localPlayer)
      showCursor(true, false)

      setCursorPosition(CX, CY)
      addEventHandler("onClientRender", root, render)

      bindKey("mouse_wheel_down", "down", scrolldown)
      bindKey("mouse_wheel_up", "down", scrollup)

      bindKey("e", "down", scrolldown)
      bindKey("q", "down", scrollup)
   end)

   -- disable default gta weapon switch controls
   toggleControl("next_weapon", false)
   toggleControl("previous_weapon", false)

   bindKey("tab", "up", function()
      removeEventHandler("onClientRender", root, render)
      showCursor(false)

      unbindKey("mouse_wheel_down", "down", scrolldown)
      unbindKey("mouse_wheel_up", "down", scrollup)

      unbindKey("e", "down", scrolldown)
      unbindKey("q", "down", scrollup)

      local current = getWeaponAtGroup()
      if current then
         setPedWeaponSlot(localPlayer, current.slot)

         if current.id ~= selected.id then
            playSound("assets/soundfx/select.mp3")
         end

         selected = current
      end
   end)
end)