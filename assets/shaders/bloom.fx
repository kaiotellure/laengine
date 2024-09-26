texture Texture0;
float2  TexelSize;

float gTime : TIME;

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

float4 getBloom(float2 coord) {
    float4 color = tex2D(Sampler0, coord);
	float brightness = length(color.rgb-float3(1.0, 1.0, 0.0));
    // Extract bright areas
    return (brightness < 0.5) ? color : float4(0, 0, 0, 0);
}

float4 horizontal_blur(float2 coord) {
    float4 color = float4(0, 0, 0, 0);
	
	for (int i = -(RADIUS/2); i < RADIUS/2; i++)
	{
		color += getBloom(coord + float2(i*TexelSize.x, 0));
	};

    // Average the samples
    return color; // Adjust weight as needed
}

float4 vertical_blur(float2 coord) {
    float4 color = float4(0, 0, 0, 0);
	
	for (int i = -(RADIUS/2); i < RADIUS/2; i++)
	{
		color += getBloom(coord + float2(0, i*TexelSize.y));
	};

    // Average the samples
    return color; // Adjust weight as needed
}

float4 PS_Main(PSInput PS) : SV_Target
{
	float4 original = tex2D(Sampler0, PS.TexCoord);
	float4 color = horizontal_blur(PS.TexCoord);
	color += vertical_blur(PS.TexCoord);
	return saturate(original + color);
}

technique Contrast
{
    pass P0
    {
        PixelShader = compile ps_2_0 PS_Main();
    }
}
