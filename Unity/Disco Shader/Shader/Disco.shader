// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Disco"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
		[PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
		_Tiling("Tiling", Vector) = (10,10,0,0)
		_CircleSize("Circle Size", Range( 0 , 0.5)) = 0.2578441
		_PanSpeed("Pan Speed", Float) = 0.001
		_RotateSpeed("Rotate Speed", Float) = -0.02
		_PixelSize("Pixel Size", Float) = 16
		[Toggle]_PixelCircles("Pixel Circles", Float) = 0
		_ColorChangeTime("Color Change Time", Float) = 0.1
		_Opacity("Opacity", Range( 0 , 1)) = 0.54

	}

	SubShader
	{
		LOD 0

		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }

		Cull Off
		Lighting Off
		ZWrite Off
		Blend One One
		
		
		Pass
		{
		CGPROGRAM
			
			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile _ PIXELSNAP_ON
			#pragma multi_compile _ ETC1_EXTERNAL_ALPHA
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				float2 texcoord  : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				
			};
			
			uniform fixed4 _Color;
			uniform float _EnableExternalAlpha;
			uniform sampler2D _MainTex;
			uniform sampler2D _AlphaTex;
			uniform float _ColorChangeTime;
			uniform float _PanSpeed;
			uniform float _PixelCircles;
			uniform float2 _Tiling;
			uniform float _PixelSize;
			uniform float _RotateSpeed;
			uniform float _CircleSize;
			uniform float _Opacity;
			float3 HSVToRGB( float3 c )
			{
				float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
				float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
				return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
			}
			
					float2 voronoihash1( float2 p )
					{
						p = p - 1 * floor( p / 1 );
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi1( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash1( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.707 * sqrt(dot( r, r ));
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				
				
				IN.vertex.xyz +=  float3(0,0,0) ; 
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color * _Color;
				#ifdef PIXELSNAP_ON
				OUT.vertex = UnityPixelSnap (OUT.vertex);
				#endif

				return OUT;
			}

			fixed4 SampleSpriteTexture (float2 uv)
			{
				fixed4 color = tex2D (_MainTex, uv);

#if ETC1_EXTERNAL_ALPHA
				// get the color from an external texture (usecase: Alpha support for ETC1 on android)
				fixed4 alpha = tex2D (_AlphaTex, uv);
				color.a = lerp (color.a, alpha.r, _EnableExternalAlpha);
#endif //ETC1_EXTERNAL_ALPHA

				return color;
			}
			
			fixed4 frag(v2f IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float mulTime22 = _Time.y * _ColorChangeTime;
				float3 hsvTorgb3_g1 = HSVToRGB( float3(mulTime22,1.0,1.0) );
				float time1 = 0.0;
				float2 voronoiSmoothId1 = 0;
				float mulTime14 = _Time.y * _PanSpeed;
				float2 texCoord3 = IN.texcoord.xy * _Tiling + float2( 0,0 );
				float pixelWidth18 =  1.0f / _PixelSize;
				float pixelHeight18 = 1.0f / _PixelSize;
				half2 pixelateduv18 = half2((int)(texCoord3.x / pixelWidth18) * pixelWidth18, (int)(texCoord3.y / pixelHeight18) * pixelHeight18);
				float2 panner12 = ( mulTime14 * float2( 1,1 ) + (( _PixelCircles )?( pixelateduv18 ):( texCoord3 )));
				float mulTime15 = _Time.y * _RotateSpeed;
				float cos13 = cos( mulTime15 );
				float sin13 = sin( mulTime15 );
				float2 rotator13 = mul( panner12 - float2( 0,0 ) , float2x2( cos13 , -sin13 , sin13 , cos13 )) + float2( 0,0 );
				float2 coords1 = rotator13 * 1.0;
				float2 id1 = 0;
				float2 uv1 = 0;
				float voroi1 = voronoi1( coords1, time1, id1, uv1, 0, voronoiSmoothId1 );
				float temp_output_2_0 = step( voroi1 , _CircleSize );
				float4 appendResult24 = (float4(( hsvTorgb3_g1 * temp_output_2_0 ) , ( temp_output_2_0 * _Opacity )));
				
				fixed4 c = appendResult24;
				c.rgb *= c.a;
				return c;
			}
		ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18934
0;64.8;1192.6;1047;1162.463;560.5521;1;True;False
Node;AmplifyShaderEditor.Vector2Node;4;-2381.127,-119.0862;Inherit;False;Property;_Tiling;Tiling;0;0;Create;True;0;0;0;False;0;False;10,10;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-2193.127,-116.0862;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;19;-2032.296,-306.7134;Inherit;False;Property;_PixelSize;Pixel Size;4;0;Create;True;0;0;0;False;0;False;16;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1904.296,94.28656;Inherit;False;Property;_PanSpeed;Pan Speed;2;0;Create;True;0;0;0;False;0;False;0.001;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCPixelate;18;-1888.296,-248.7134;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1559.296,180.2866;Inherit;False;Property;_RotateSpeed;Rotate Speed;3;0;Create;True;0;0;0;False;0;False;-0.02;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;14;-1714.296,92.28656;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;20;-1700.296,-108.7134;Inherit;False;Property;_PixelCircles;Pixel Circles;5;0;Create;True;0;0;0;False;0;False;0;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;12;-1456.296,-102.7134;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;1,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;15;-1373.296,179.2866;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-753.2964,-435.7134;Inherit;False;Property;_ColorChangeTime;Color Change Time;6;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;13;-1106.296,-95.71344;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;22;-519.2964,-425.7134;Inherit;False;1;0;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-565.2964,53.28656;Inherit;False;Property;_CircleSize;Circle Size;1;0;Create;True;0;0;0;False;0;False;0.2578441;0;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;1;-765.1267,-92.08627;Inherit;True;0;1;1;0;1;True;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.StepOpNode;2;-235.1267,-55.08627;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;21;-230.2964,-421.7134;Inherit;True;Simple HUE;-1;;1;32abb5f0db087604486c2db83a2e817a;0;1;1;FLOAT;0;False;4;FLOAT3;6;FLOAT;7;FLOAT;5;FLOAT;8
Node;AmplifyShaderEditor.RangedFloatNode;27;-16.29639,74.28656;Inherit;False;Property;_Opacity;Opacity;7;0;Create;True;0;0;0;False;0;False;0.54;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;137.7036,-196.7134;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;234.7036,-5.71344;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;370.7036,-168.7134;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;593,-191;Float;False;True;-1;2;ASEMaterialInspector;0;6;Disco;0f8ba0101102bb14ebf021ddadce9b49;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;2;True;True;4;1;False;-1;1;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;3;0;4;0
WireConnection;18;0;3;0
WireConnection;18;1;19;0
WireConnection;18;2;19;0
WireConnection;14;0;16;0
WireConnection;20;0;3;0
WireConnection;20;1;18;0
WireConnection;12;0;20;0
WireConnection;12;1;14;0
WireConnection;15;0;17;0
WireConnection;13;0;12;0
WireConnection;13;2;15;0
WireConnection;22;0;25;0
WireConnection;1;0;13;0
WireConnection;2;0;1;0
WireConnection;2;1;10;0
WireConnection;21;1;22;0
WireConnection;23;0;21;6
WireConnection;23;1;2;0
WireConnection;26;0;2;0
WireConnection;26;1;27;0
WireConnection;24;0;23;0
WireConnection;24;3;26;0
WireConnection;0;0;24;0
ASEEND*/
//CHKSM=EFDCBBD0DFA8FA07FB2B62EEEE16D34EF152DE47