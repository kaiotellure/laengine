local shader = [[
	texture gTexture;
	technique TexReplace
	{
	    pass P0
	    {
	        Texture[0] = gTexture;
	    }
	}
]]

addEventHandler("onClientResourceStart", root, function()
	local texture = dxCreateTexture("assets/onefourthcrosshair.png")
	local shader = dxCreateShader(shader)

	assert(shader, "could not create shader.")

	dxSetShaderValue(shader, "gTexture", texture)
	engineApplyShaderToWorldTexture(shader, "sitem16")
end)