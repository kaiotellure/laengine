DEBUG = {}

addEventHandler("onClientRender", root, function()
	local i = 0

	for name, text in pairs(DEBUG) do
		text = type(text) == "function" and text() or text
		dxDrawText(name..": "..tostring(text), 10, 200 + i*20)
		i = i+1
	end
end, true, "low")

function d(key, value) DEBUG[key] = value end