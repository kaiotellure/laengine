Notification = {}
Notification.__index = Notification

function Notification.new(padding)
	local instance = {components = {}, width = 0, height = padding, padding = padding}
	return setmetatable(instance, Notification)
end

function Notification:AddComponent(component)
	table.insert(self.components, component)
end

function Notification:CalculateSize()
	self.width, self.height = 0, self.padding

	for i, component in ipairs(self.components) do
		if not component.__disabled then
			self.width = math.max(self.width, component.width) + self.padding*2
			self.height = self.height + component.height + self.padding
		end
	end
end

function Notification:Render()
	self:CalculateSize()
	self.target = dxCreateRenderTarget(self.width, self.height, true)

	dxSetRenderTarget(self.target, true)
	dxSetBlendMode("add")

	dxDrawRectangle(0, 0, self.width, self.height, tocolor(5, 5, 5, 225))
	local acumulated_height = self.padding

	for i, component in ipairs(self.components) do
		if not component.__disabled then
			dxDrawImage(self.padding, acumulated_height, component.width, component.height, component.target)
			acumulated_height = acumulated_height + component.height + self.padding
		end
	end

	dxSetBlendMode("blend")
	dxSetRenderTarget()
end