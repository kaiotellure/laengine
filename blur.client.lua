---@type (DxScreenSource|false), (Shader|false)
local screenSource, shader

local function draw()
	if screenSource and shader then
		dxUpdateScreenSource(screenSource)

		dxSetShaderValue(shader, "TexelSize", 1 / sx, 1 / sy)
		dxSetShaderValue(shader, "Texture0", screenSource)
		dxDrawImage(0, 0, sx, sy, shader)
	end
end

addEventHandler("onClientResourceStart", root, function()
	local newScreenSource = dxCreateScreenSource(sx * 0.4, sy * 0.4)
	assert(newScreenSource, "screen source could not be created.")

	local newShader, technique = dxCreateShader("assets/blur.fx")
	assert(newShader, "shader could not be created.")

	screenSource, shader = newScreenSource, newShader
	addEventHandler("onClientRender", root, draw)
end)

