struct VS_INPUT
{
	float3 position : POSITION;
	float3 normal : NORMAL;
	float2 texCoord : TEXCOORD0;
	float3 tangent : TANGENT;
};

struct VS_OUTPUT
{
	float4 position : SV_Position;
	float2 texCoord : TEXCOORD0;
#if SpotLight
	// Shadow depth are stored texture array.
	// So renderTargetIndex is used as the texture array index.

	// The render target index of the point light is calculated in the geometry shader for one - pass drawing.
	// See ShadowDepthGeometryShader.hlsl for more information.
	uint renderTargetIndex : SV_RenderTargetArrayIndex;
#endif
};

cbuffer cbPerObject : register(b0)
{
	float4x4 worldMatrix;
}

cbuffer cbPerLight : register(b1)
{
	float4x4 shadowMatrix;
	uint renderTargetIndex;
	uint3 padding;
};

VS_OUTPUT main(VS_INPUT input)
{
	VS_OUTPUT output;
	output.position = mul(float4(input.position, 1.0f), worldMatrix);

	output.texCoord = input.texCoord;

#if SpotLight
	// Shadow depth are stored texture array.
	// So renderTargetIndex is used as the texture array index.

	// The render target index of the point light is calculated in the geometry shader for one - pass drawing.
	// See ShadowDepthGeometryShader.hlsl for more information.
	output.position = mul(output.position, shadowMatrix);
	output.renderTargetIndex = renderTargetIndex;
#endif

	return output;
}
