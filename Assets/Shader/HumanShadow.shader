Shader "Unlit/HumanShadow"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _TransVal ("Transparency Value", Range(0,1)) = 0.5
    }
    SubShader
    {
        //Tags { "RenderType"="Opaque" }
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Opaque" }
        LOD 100

        Lighting Off
        //Blend  One OneMinusSrcAlpha 
        Blend SrcAlpha OneMinusSrcAlpha

        //正常（Normal），即透明度混合
        //Blend SrcAlpha OneMinusSrcAlpha
        //柔和相加（Soft Additive）
        //Blend OneMinusDstColor One
        //正片叠底（Multiply），即相乘
        //Blend DstColor Zero
        //两倍相乘（2x Multiply）
        //Blend DstColor SrcColor
        //变暗（Darken）
        //BlendOp Min
        //Blend One One
        //变亮（Lighten）
        //BlendOp Max
        //Blend One One
        //滤色（Screen）
        //Blend OneMinusDstColor One
        //等同于
        //Blend One OneMinusSrcColor
        //线性减淡（Linear Dodge）
        //Blend One One

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

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
            float4 _MainTex_ST;
            float _TransVal;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }


            float3 hash(float x) {
                return frac(sin((float3(x,x,x)+float3(23.32445,132.45454,65.78943))*float3(23.32445,32.45454,65.78943))*4352.34345); 
            }

            float3 noise(float x)
            {
                float p = frac(x); x-=p;
                return lerp(hash(x),hash(x+1.0),p);
            }

            float3 noiseq(float x)
            {
                return (noise(x) + 
                        noise(x + 10.25) + 
                        noise(x + 20.5) + 
                        noise(x + 30.75)) * 0.25;
            }

            //void mainImage( out float4 O,  float2 fragCoord )
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                float time = _Time.y*0.15;
                float3 k1 = noiseq(time) * float3(0.1, 0.19, 0.3) + 
                            float3(1.3, 0.8, 0.63);

                float3 k2 = noiseq(time + 1000.0) * float3(0.2,0.2,0.05) + 
                            float3(0.9,0.9, 0.05);
                float3 k3 = noiseq(time + 1000.0) * float3(0.4,0.28,0.01) + 
                            float3(0.9,1.2, 0.05);

                //float k3=clamp(texture(iChannel0,float2(0.01,0.)).x,0.8,1.0); float k4=clamp(texture(iChannel0,float2(0.2,0.)).x,0.5,1.0); k2+=float3((k3-0.8)*0.05); k1+=float3((k4-0.5)*0.01);
                float g = pow(abs(sin(time*0.8+9000.0)),4.0);
                
                //float2 R = iResolution.xy;
                //float2 r1 = (fragCoord / iResolution.y - float2(0.5 * iResolution.x / iResolution.y , 0.5) );

                float2 r1 = i.uv;
                r1 = 2.0 * r1 - 1.0;

                float l = length(r1);
                //float l = 0.5;
                float2 rotate=float2(cos(time * 2),sin(time * 2));
                //Just Rotate image
                r1 = float2(r1.x*rotate.x + r1.y*rotate.y, r1.y*rotate.x - r1.x*rotate.y);
                
                float2 c3 = abs(r1.xy/l);
                if (c3.x > 0.5) 
                    c3 = abs(c3*0.5 + float2(-c3.y, c3.x)*0.86602540);
                    //c3 = abs(c3*0.5 + float2(-c3.y, c3.x)*0.2);

                c3 = normalize(float2(c3.x * 2.0, (c3.y - 0.8660254037) * 7.4641016151377545870)); //0.8660254037) * 7.4641016151377545870
                
                float4 final_color = float4(c3 * l * 70 * (g + 0.12), 0.5, 0);
                for (int i = 0; i < 128; i++) {
                    final_color.xzy = (k1 * abs(final_color.xyz / dot(final_color,final_color) - k2) );
                }
                
                if((col.r + col.g + col.b) == 0)
                    final_color.a = _TransVal;
                else
                    final_color.a = 1;

                return final_color;
            }
            ENDCG
        }
    }
}
