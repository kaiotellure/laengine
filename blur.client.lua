local screenSource, shader;

local function draw()
	if screenSource and shader then
		dxUpdateScreenSource(screenSource)

		dxSetShaderValue(shader, "TexelSize", 1/sx, 1/sy)
		dxSetShaderValue(shader, "Texture0", screenSource)
		dxDrawImage(0, 0, sx, sy, shader)
	end
end

addEventHandler("onClientResourceStart", root, function()
	screenSource = dxCreateScreenSource(sx*.4, sy*.4)
	shader = dxCreateShader("assets/blur.fx")
	
	addEventHandler("onClientRender", root, draw)
end)