---@type (DxScreenSource|false), (DxRenderTarget|false)
local screenSource, renderTarget

---@class shaders
---@field blur (Shader|false)
---@field contrast (Shader|false)
local shaders = {}

function DRAW_FULL_SCREEN_BLUR()
	if screenSource and renderTarget then
		dxUpdateScreenSource(screenSource)

		if shaders.contrast then
			dxSetRenderTarget(renderTarget, true)
			dxSetBlendMode("modulate_add")

			dxSetShaderValue(shaders.contrast, "TexelSize", 1 / SX, 1 / SY)
			dxSetShaderValue(shaders.contrast, "Texture0", screenSource)
			dxDrawImage(0, 0, SX, SY, shaders.contrast)

			if shaders.blur then
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
	local newScreenSource = dxCreateScreenSource(SX * 0.5, SY * 0.5)
	assert(newScreenSource, "screen source could not be created.")

	local newRenderTarget = dxCreateRenderTarget(SX, SY, true)
	assert(newRenderTarget, "render target could not be created.")

	for _, name in ipairs({ "blur", "contrast" }) do
		shaders[name] = dxCreateShader("assets/shaders/" .. name .. ".fx")
		if shaders[name] == false then
			print("could not create shader:" .. name)
		end
	end

	screenSource, renderTarget = newScreenSource, newRenderTarget
end)

