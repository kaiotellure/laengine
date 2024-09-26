texture Texture0;
float2  TexelSize;

#define RADIUS 2

sampler Sampler0 = sampler_state
{
    Texture = (Texture0);
};

struct PSInput
{
    float4 Position : POSITION0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
};

float4 PS_Main(PSInput PS) : SV_Target
{
    float4 color = tex2D(Sampler0, PS.TexCoord);

	if (length(color.rgb-float3(1.0, 1.0, 0.0)) > .5)
	{
		// color.rgb = (color.rgb - 0.5) * 1.5 + 0.5;
		color.rgb = saturate(color.rgb+float3(.25, 0, .5));
	}

    return color;
}

technique Contrast
{
    pass P0
    {
        PixelShader = compile ps_2_0 PS_Main();
    }
}
