// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Eye Shade"
{
	Properties
	{
		_DownSharpness("Down Sharpness", Range( 0 , 10)) = 0.4303382
		_DownOpacity("Down Opacity", Range( -100 , 100)) = -100
		_ShadeColor("Shade Color", Color) = (0.8867924,0.1288358,0.1288358,0)
		_Texture1("Texture 0", 2D) = "white" {}
		_wavespeed1("wave speed", Float) = 0.05
		_wavepower1("wavepower", Float) = 0
		_WaveColor1("Wave Color", Color) = (0,0,0,0)

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float4 _WaveColor1;
			uniform sampler2D _Texture1;
			uniform float4 _Texture1_ST;
			uniform float _wavespeed1;
			uniform float _wavepower1;
			uniform float4 _ShadeColor;
			uniform float _DownSharpness;
			uniform float _DownOpacity;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float4 appendResult43 = (float4(_WaveColor1.r , _WaveColor1.g , _WaveColor1.b , 0.0));
				float2 uv_Texture1 = i.ase_texcoord1.xy * _Texture1_ST.xy + _Texture1_ST.zw;
				float mulTime32 = _Time.y * _wavespeed1;
				float4 appendResult36 = (float4(0.0 , frac( mulTime32 ) , 0.0 , 0.0));
				float temp_output_42_0 = ( tex2D( _Texture1, ( float4( uv_Texture1, 0.0 , 0.0 ) + appendResult36 ).xy ).r * _wavepower1 );
				float4 appendResult29 = (float4(temp_output_42_0 , temp_output_42_0 , temp_output_42_0 , 0.0));
				float2 texCoord1 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float clampResult17 = clamp( ( ( ( 1.0 - texCoord1.y ) * _DownSharpness ) + ( _DownOpacity / 100.0 ) ) , 0.0 , 1.0 );
				float4 appendResult4 = (float4(_ShadeColor.r , _ShadeColor.g , _ShadeColor.b , clampResult17));
				
				
				finalColor = ( ( appendResult43 * appendResult29 ) + appendResult4 );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18909
208.8;109.6;852;703;1268.047;1171.391;1.345;False;False
Node;AmplifyShaderEditor.RangedFloatNode;31;-1194.054,-783.8284;Inherit;False;Property;_wavespeed1;wave speed;4;0;Create;True;0;0;0;False;0;False;0.05;2.45;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;32;-1013.002,-774.5438;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;33;-1235.849,-1048.206;Inherit;True;Property;_Texture1;Texture 0;3;0;Create;True;0;0;0;False;0;False;None;76ac409e4f0b7534ca93376ef93df674;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FractNode;34;-802.5487,-771.4485;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;35;-997.8417,-948.7737;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;36;-610.1466,-833.8132;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-1526.073,13.99011;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;28;-1269.348,124.2328;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-530.2104,-975.4762;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1199.93,522.2213;Inherit;False;Property;_DownOpacity;Down Opacity;1;0;Create;True;0;0;0;False;0;False;-100;-38;-100;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1583.19,292.2256;Inherit;False;Property;_DownSharpness;Down Sharpness;0;0;Create;True;0;0;0;False;0;False;0.4303382;1.38;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;15;-905.2382,455.9513;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-1099.687,204.3952;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;39;-344.5163,-1059.039;Inherit;True;Property;_TextureSample1;Texture Sample 0;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;40;-275.5224,-839.631;Inherit;False;Property;_wavepower1;wavepower;5;0;Create;True;0;0;0;False;0;False;0;9.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;31.35739,-939.3012;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;41;-48.6124,-1210.019;Inherit;False;Property;_WaveColor1;Wave Color;6;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.6415094,0.1295123,0.1450112,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-844.5736,152.1964;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-1014.038,-263.6554;Inherit;False;Property;_ShadeColor;Shade Color;2;0;Create;True;0;0;0;False;0;False;0.8867924,0.1288358,0.1288358,0;1,0.03207541,0.1264493,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;43;249.9174,-1152.239;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;29;363.2522,-954.6562;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ClampOpNode;17;-609.2162,80.18968;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;455.3573,-1147.424;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;4;-593.3441,-337.8149;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;-291.3868,-514.2194;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-102.8443,-200.9196;Float;False;True;-1;2;ASEMaterialInspector;100;1;Eye Shade;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;32;0;31;0
WireConnection;34;0;32;0
WireConnection;35;2;33;0
WireConnection;36;1;34;0
WireConnection;28;0;1;2
WireConnection;38;0;35;0
WireConnection;38;1;36;0
WireConnection;15;0;13;0
WireConnection;5;0;28;0
WireConnection;5;1;6;0
WireConnection;39;0;33;0
WireConnection;39;1;38;0
WireConnection;42;0;39;1
WireConnection;42;1;40;0
WireConnection;14;0;5;0
WireConnection;14;1;15;0
WireConnection;43;0;41;1
WireConnection;43;1;41;2
WireConnection;43;2;41;3
WireConnection;29;0;42;0
WireConnection;29;1;42;0
WireConnection;29;2;42;0
WireConnection;17;0;14;0
WireConnection;30;0;43;0
WireConnection;30;1;29;0
WireConnection;4;0;2;1
WireConnection;4;1;2;2
WireConnection;4;2;2;3
WireConnection;4;3;17;0
WireConnection;44;0;30;0
WireConnection;44;1;4;0
WireConnection;0;0;44;0
ASEEND*/
//CHKSM=9C3E483AE2892B6846BD0DBC12DEAFA6A3C7B36D