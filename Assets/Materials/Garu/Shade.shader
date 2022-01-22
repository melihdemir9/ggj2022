// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Shade"
{
	Properties
	{
		_ShadeColor("Shade Color", Color) = (0.8867924,0.1288358,0.1288358,0)
		_DownSharpness("Down Sharpness", Range( 0 , 10)) = 0.4303382
		_DownOpacity("Down Opacity", Range( -100 , 100)) = -100
		_UpSharpness("Up Sharpness", Range( 0 , 10)) = 0.4303382
		_UpOpacity("Up Opacity", Range( -100 , 100)) = 0.4445385
		_Texture0("Texture 0", 2D) = "white" {}
		_wavespeed("wave speed", Float) = 0.05
		_wavepower("wavepower", Float) = 0
		_WaveColor("Wave Color", Color) = (0,0,0,0)

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

			uniform float4 _WaveColor;
			uniform sampler2D _Texture0;
			uniform float4 _Texture0_ST;
			uniform float _wavespeed;
			uniform float _wavepower;
			uniform float4 _ShadeColor;
			uniform float _DownSharpness;
			uniform float _DownOpacity;
			uniform float _UpSharpness;
			uniform float _UpOpacity;

			
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
				float4 appendResult67 = (float4(_WaveColor.r , _WaveColor.g , _WaveColor.b , 0.0));
				float2 uv_Texture0 = i.ase_texcoord1.xy * _Texture0_ST.xy + _Texture0_ST.zw;
				float mulTime50 = _Time.y * _wavespeed;
				float4 appendResult53 = (float4(0.0 , frac( mulTime50 ) , 0.0 , 0.0));
				float temp_output_56_0 = ( tex2D( _Texture0, ( float4( ( 1.0 - uv_Texture0 ), 0.0 , 0.0 ) + appendResult53 ).xy ).r * _wavepower );
				float4 appendResult58 = (float4(temp_output_56_0 , temp_output_56_0 , temp_output_56_0 , 0.0));
				float2 texCoord1 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float clampResult17 = clamp( ( ( ( texCoord1.y * _DownSharpness ) + ( _DownOpacity / 100.0 ) ) * ( ( ( 1.0 - texCoord1.y ) * _UpSharpness ) + ( _UpOpacity / 100.0 ) ) ) , 0.0 , 1.0 );
				float4 appendResult4 = (float4(_ShadeColor.r , _ShadeColor.g , _ShadeColor.b , clampResult17));
				
				
				finalColor = ( ( appendResult67 * appendResult58 ) + appendResult4 );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18909
210.4;98.4;852;714.2;984.4283;1245.784;1.269999;True;False
Node;AmplifyShaderEditor.RangedFloatNode;51;-758.126,-687.9147;Inherit;False;Property;_wavespeed;wave speed;6;0;Create;True;0;0;0;False;0;False;0.05;0.61;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;50;-577.0739,-678.6301;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;45;-799.9205,-952.2921;Inherit;True;Property;_Texture0;Texture 0;5;0;Create;True;0;0;0;False;0;False;None;76ac409e4f0b7534ca93376ef93df674;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-1526.073,13.99011;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FractNode;52;-366.6202,-675.5348;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;47;-561.9132,-852.86;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;53;-174.2181,-737.8995;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;27;-321.5032,498.8051;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;68;-297.3589,-830.4943;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-220.6381,928.162;Inherit;False;Property;_UpOpacity;Up Opacity;4;0;Create;True;0;0;0;False;0;False;0.4445385;-100;-100;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1199.93,522.2213;Inherit;False;Property;_DownOpacity;Down Opacity;2;0;Create;True;0;0;0;False;0;False;-100;-99;-100;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-512.4841,774.0212;Inherit;False;Property;_UpSharpness;Up Sharpness;3;0;Create;True;0;0;0;False;0;False;0.4303382;2.3;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1491.776,368.0807;Inherit;False;Property;_DownSharpness;Down Sharpness;1;0;Create;True;0;0;0;False;0;False;0.4303382;4.1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-120.3951,610.3357;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;-94.28192,-879.5625;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;23;74.05377,861.8918;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;15;-905.2382,455.9513;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-1099.687,204.3952;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;54;91.4122,-963.1248;Inherit;True;Property;_TextureSample0;Texture Sample 0;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;24;212.2333,568.6119;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-844.5736,152.1964;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;160.4061,-743.7173;Inherit;False;Property;_wavepower;wavepower;7;0;Create;True;0;0;0;False;0;False;0;6.07;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;66;387.3161,-1114.105;Inherit;False;Property;_WaveColor;Wave Color;8;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.9245283,0.09943034,0.2342393,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-444.1229,203.2693;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;467.2859,-843.3875;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;17;-181.0963,114.0697;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;58;799.1807,-858.7425;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;67;685.8459,-1056.325;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;2;-1119.068,-580.6901;Inherit;False;Property;_ShadeColor;Shade Color;0;0;Create;True;0;0;0;False;0;False;0.8867924,0.1288358,0.1288358,0;0.5188679,0.1292275,0.1533026,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;4;-593.3441,-337.8149;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;891.2858,-1051.51;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;61;75.94659,-472.1056;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-102.8443,-200.9196;Float;False;True;-1;2;ASEMaterialInspector;100;1;Shade;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;50;0;51;0
WireConnection;52;0;50;0
WireConnection;47;2;45;0
WireConnection;53;1;52;0
WireConnection;27;0;1;2
WireConnection;68;0;47;0
WireConnection;22;0;27;0
WireConnection;22;1;21;0
WireConnection;48;0;68;0
WireConnection;48;1;53;0
WireConnection;23;0;20;0
WireConnection;15;0;13;0
WireConnection;5;0;1;2
WireConnection;5;1;6;0
WireConnection;54;0;45;0
WireConnection;54;1;48;0
WireConnection;24;0;22;0
WireConnection;24;1;23;0
WireConnection;14;0;5;0
WireConnection;14;1;15;0
WireConnection;26;0;14;0
WireConnection;26;1;24;0
WireConnection;56;0;54;1
WireConnection;56;1;55;0
WireConnection;17;0;26;0
WireConnection;58;0;56;0
WireConnection;58;1;56;0
WireConnection;58;2;56;0
WireConnection;67;0;66;1
WireConnection;67;1;66;2
WireConnection;67;2;66;3
WireConnection;4;0;2;1
WireConnection;4;1;2;2
WireConnection;4;2;2;3
WireConnection;4;3;17;0
WireConnection;62;0;67;0
WireConnection;62;1;58;0
WireConnection;61;0;62;0
WireConnection;61;1;4;0
WireConnection;0;0;61;0
ASEEND*/
//CHKSM=F40F48E1EE89C542AA704E615B56EC8A28A2A58E