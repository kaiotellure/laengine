---@type (DxScreenSource|false), (Shader|false)
local screenSource, shader

function DRAW_FULL_SCREEN_BLUR()
	if screenSource and shader then
		dxUpdateScreenSource(screenSource)

		dxSetShaderValue(shader, "TexelSize", 1 / SX, 1 / SY)
		dxSetShaderValue(shader, "Texture0", screenSource)
		dxDrawImage(0, 0, SX, SY, shader)
	end
end

addEventHandler("onClientResourceStart", root, function()
	local newScreenSource = dxCreateScreenSource(SX * 0.4, SY * 0.4)
	assert(newScreenSource, "screen source could not be created.")

	local newShader, technique = dxCreateShader("assets/blur.fx")
	assert(newShader, "shader could not be created.")

	screenSource, shader = newScreenSource, newShader
end)

