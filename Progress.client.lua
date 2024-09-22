Progress = {}
Progress.__type = "progress"
Progress.__index = Progress

function Progress.new(width)
	local instance = {max = 100, value = 0, width = width, height = 4}
	return setmetatable(instance, Progress)
end

function Progress:SetValue(value)
	self.value = math.min(math.max(value, 0), 100)
end

function Progress:Render()
	self.target = dxCreateRenderTarget(self.width, self.height, true)

	dxSetRenderTarget(self.target, true)
	dxSetBlendMode("modulate_add")

	dxDrawRectangle(0, 0, self.width, self.height, tocolor(255, 255, 255, 50))
	dxDrawRectangle(0, 0, self.width*(self.value/self.max), self.height, tocolor(255, 255, 255, 200))

	dxSetBlendMode("blend")
	dxSetRenderTarget()
end