MultilineText = {}
MultilineText.__type = "multilinetext"
MultilineText.__index = MultilineText

function MultilineText.new(text, maxw)
	local instance = {text = text, leading = .90, maxw = maxw}
	instance.font = FONTS.Switzer
	return setmetatable(instance, MultilineText)
end

function MultilineText:Split()
	local words = {}
	local index, clip, inBlock, hex = 1, "", false, nil

	while index <= #self.text do
		local rune = self.text:sub(index, index)

		if rune == "#" then
			if not inBlock then
				hex = rune..self.text:sub(index+1, index+6)
				index = index + 6
				inBlock = true
			end
		elseif rune == " " then
			table.insert(words, {content = clip, color = inBlock and hex or "#ffffff"})
			if self.text:sub(index-1, index-1) == "#" then inBlock = false end
			clip = ""
		else
			clip = clip..rune
		end

		index = index + 1
	end

	if #clip then table.insert(words, {content = clip, color = inBlock and hex or "#ffffff"}) end
	return words
end

function MultilineText:SplitLines(words)
	local lines = {}
	local line = ""

	for _, word in ipairs(words) do
		local teorical_width = dxGetTextSize(line..word.content.." ", nil, nil, self.font, false, true)

	   	if teorical_width < self.maxw then
	   		line = line..word.color..word.content.." "
	   		-- count = count + #word
	   	else
	   		table.insert(lines, {type = "line", content = line})
	   		count = 0; line = word.color..word.content.." "
	   	end
	end

	if #line then table.insert(lines, {type = "line", content = line}) end
	return lines
end

function MultilineText:CalculateSize(tokens)
	local biggest_width, total_height = 0, 0

	for i, token in ipairs(tokens) do
		local expected_width, expected_height = dxGetTextSize(
			token.content, nil, nil, self.font, false, true
		)
		expected_height = expected_height*self.leading

		biggest_width = math.max(biggest_width, expected_width)
		total_height = total_height + expected_height

		token.expected_height = expected_height
	end

	self.width, self.height = biggest_width, total_height
end

function MultilineText:Render()
	local words = self:Split()
	local lines = self:SplitLines(words)

	self:CalculateSize(lines)
	self.target = dxCreateRenderTarget(self.width, self.height, true)

	dxSetRenderTarget(self.target, true)
	dxSetBlendMode("modulate_add")

	local offsety = -3

	for i, token in ipairs(lines) do
		dxDrawText(
			token.content, 0, offsety,
			nil, nil, nil, nil, self.font, "left", "top", false, false, false, true
		)
		offsety = offsety + token.expected_height
	end

	dxSetBlendMode("blend")
	dxSetRenderTarget()
end
