---@type (DxScreenSource|false), (DxRenderTarget|false)
local screenSource, renderTarget

---@class shaders
---@field blur (Shader|false)
---@field contrast (Shader|false)
local shaders = {}

-- will draw a contrast and grayscale then possibly a blur effect on screen, sections not supported yet.
---@param blur? boolean blur can decrease performance on gpu-less computers
function DRAW_FULL_SCREEN_FX(blur)
	if screenSource and renderTarget then
		dxUpdateScreenSource(screenSource)

		if shaders.contrast then
			dxSetRenderTarget(renderTarget, true)
			dxSetBlendMode("modulate_add")

			dxSetShaderValue(shaders.contrast, "TexelSize", 1 / SX, 1 / SY)
			dxSetShaderValue(shaders.contrast, "Texture0", screenSource)
			dxDrawImage(0, 0, SX, SY, shaders.contrast)

			if blur and shaders.blur then
				dxSetShaderValue(shaders.blur, "TexelSize", 1 / SX, 1 / SY)
				dxSetShaderValue(shaders.blur, "Texture0", renderTarget)
				dxDrawImage(0, 0, SX, SY, shaders.blur)
			end

			dxSetBlendMode("blend")
			dxSetRenderTarget()

			dxDrawImage(0, 0, SX, SY, renderTarget)
		end
	end
end

addEventHandler("onClientResourceStart", root, function()
	local newScreenSource = dxCreateScreenSource(SX * 1, SY * 1)
	assert(newScreenSource, "screen source could not be created.")

	local newRenderTarget = dxCreateRenderTarget(SX, SY, true)
	assert(newRenderTarget, "render target could not be created.")

	for _, name in ipairs({ "blur", "contrast" }) do
		local newShader = dxCreateShader("assets/shaders/" .. name .. ".fx")
		assert(newShader, name.." shader could not be created.")

		shaders[name] = newShader
	end

	screenSource, renderTarget = newScreenSource, newRenderTarget
end)

