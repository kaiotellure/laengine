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

float4 PS_Main(PSInput PS) : SV_Target
{
	// Sample the surrounding pixels
    float3 center = tex2D(Sampler0, PS.TexCoord).rgb;
    float3 left   = tex2D(Sampler0, PS.TexCoord + float2(-1.0/512.0, 0)).rgb; // Left
    float3 right  = tex2D(Sampler0, PS.TexCoord + float2(1.0/512.0, 0)).rgb;  // Right
    float3 up     = tex2D(Sampler0, PS.TexCoord + float2(0, -1.0/512.0)).rgb; // Up
    float3 down   = tex2D(Sampler0, PS.TexCoord + float2(0, 1.0/512.0)).rgb;  // Down

    // Calculate gradients
    float3 gradientX = right - left;
    float3 gradientY = down - up;

    // Calculate edge intensity
    float edgeIntensity = length(gradientX) + length(gradientY);

    // Enhance contrast based on edge intensity
    float3 contrastColor = center + (up - 0.5) * 2 * edgeIntensity + .1;

    // Clamp the result to [0, 1]
    contrastColor = saturate(contrastColor);

    return float4(contrastColor, 1.0);
}

technique Contrast
{
    pass P0
    {
        PixelShader = compile ps_2_0 PS_Main();
    }
}
