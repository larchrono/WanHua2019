Shader "Unlit/MyKaleido"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        iChannel0("iChannel0", 2D) = "white" {}  
        _NUM_SIDES("Number Sides", float) = 4
        _NUM_Point("Number Point", Range(1,255)) = 128
        _New_Method("New Method", int) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D iChannel0;
            float _NUM_SIDES;
            int _NUM_Point;
            float _New_Method;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            #define mod(x,y) (x-y*floor(x/y))

            // ---- change here ----
            static const float USE_KALEIDOSCOPE = 1.0;
            //static const float _NUM_SIDES = 4.0;

            // math const
            static const float PI = 3.14159265359;
            static const float DEG_TO_RAD = PI / 180.0;

            // -4/9(r/R)^6 + (17/9)(r/R)^4 - (22/9)(r/R)^2 + 1.0
            float field( float2 p, float2 center, float r ) {
                float d = length( p - center ) / r;
                
                float t   = d  * d;
                float tt  = t  * d;
                float ttt = tt * d;
                
                float v =
                    ( - 4.0 / 9.0 ) * ttt +
                    (  17.0 / 9.0 ) * tt +
                    ( -22.0 / 9.0 ) * t +
                    1.0;
                
                return clamp( v, 0.0, 1.0 );
            }

            float2 Kaleidoscope( float2 uv, float n, float bias ) {
                float angle = PI / n;
                
                float r = length( uv );
                float a = atan2( uv.y, uv.x ) / angle;
                
                a = lerp( frac( a ), 1.0 - frac( a ), mod( floor( a ), 2.0 ) ) * angle;
                
                return float2( cos( a ), sin( a ) ) * r;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(iChannel0, i.uv);

                //在Unity中, UV一定是0~1之間，若做了轉換至 0~ 1.xx時，會映射錯誤
                // 1.xx,  1
                //float2 ratio = iResolution.xy / min( iResolution.x, iResolution.y );
                float2 ration = 1.25;
                //float2 uv = ( fragCoord.xy * 2.0 - iResolution.xy ) / min( iResolution.x, iResolution.y );
                // x = 0 ~  1.xx , y = 0~ 1.0
                //float2 uv = fragCoord.xy / iResolution.xy
                float2 uv = i.uv;
                uv = 2.0 * uv - 1.0;
                //if (iResolution.x > iResolution.y) {
                //    uv.x *= iResolution.x / iResolution.y;
                //} else {
                //    uv.y *= iResolution.y / iResolution.x;
                //}
                
                // --- Kaleidoscope ---
                float _NUM_SIDES2 = 10.0*(sin(_Time.y * 0.6) + 1.2);
                uv = lerp( uv, Kaleidoscope( uv, _NUM_SIDES, 0.0 ), USE_KALEIDOSCOPE ); 
                
                float3 final_color = ( 0.0 );
                float final_density = 0.0;
                for ( int i = 0; i < _NUM_Point ; i++ ) {
                    float randColor = 128 + 128 * cos(_Time.y * 0.01);
                    float4 noise  = tex2D( _MainTex, float2(  i  + 0.5, 5.5 ) / 256.0 );
                    float4 noise2 = tex2D( _MainTex, float2(  i  + 0.5, randColor ) / 256.0 );
                    
                    // velocity
                    float2 vel = noise.xy * 2.0 - ( 1.0 );
                    
                    float2 pos = noise.xy;

                    // center
                    if(_New_Method == 0)
                        pos = noise.xy;
                    else
                        pos = float2( noise.x * (i/256.0), noise.y );

                    pos += _Time.y * vel * 0.2;
                    pos = lerp( frac( pos ), 1 - frac( pos ), mod( floor( pos ), 2.0 ) );
                    
                    // remap to screen
                    //pos = ( pos * 2.0 - 1.0 ) * ration;
                    pos = float2(pos.x , pos.y * 1.2 - 0.2 ) * ration;
                    
                    // radius
                    float radius = clamp( noise.w, 0.3, 0.8 ); // 0.25,0.45
                    //radius *= radius * 0.4;
                    radius *= radius * 0.2;
                    
                    // color
                    float3 color = noise2.xyz;
                    
                    // density
                    float density = field( uv, pos, radius );

                    // accumulate
                    final_density += density;		
                    final_color += density * color;
                }

                final_density = clamp( final_density - 0.1, 0.0, 1.0 );
                final_density = pow( final_density, 1.0 );

                //return float4 (_NUM_Point/256,_NUM_SIDES/24,0.5,1);
                //return float4(final_color, 1.0);

                

                //return col;

                return float4( final_color * final_density, 1.0 );
            }

            ENDCG
        }
    }
}
