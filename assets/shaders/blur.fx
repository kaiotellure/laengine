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

float4 blur(PSInput PS) : SV_Target
{
	float4 color = float4(0, 0, 0, 0);

	for (int x = -RADIUS; x <= RADIUS; x++)
	{
		for (int y = -RADIUS; y <= RADIUS; y++)
		{
			color += tex2D(Sampler0, PS.TexCoord + float2(x, y)*TexelSize);
		}
	}

	return color / pow((RADIUS * 2 + 1), 2);
}

technique Gaussian
{
    pass P0
    {
        PixelShader = compile ps_2_0 blur();
    }
}
