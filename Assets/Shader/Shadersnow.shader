Shader "Unlit/snow"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SnowColor ("Snow Color", Color) = (0,0,0,0)
        _GroundColor ("Ground Color", Color) = (0,0,0,0)
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
            #include "snowpass.hlsl"
            ENDCG
        }
    }
}
