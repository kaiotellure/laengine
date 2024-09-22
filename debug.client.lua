DEBUG = {}

addEventHandler("onClientRender", root, function()
	local i = 0

	for name, text in pairs(DEBUG) do
		dxDrawText(name..": "..tostring(text), 10, 200 + i*20)
		i = i+1
	end
end)