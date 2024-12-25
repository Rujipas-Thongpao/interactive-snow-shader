#ifndef SNOW_PASS_INCLUDED
#define SNOW_PASS_INCLUDED

#include "UnityCG.cginc"
#include "common.hlsl"
#include "noise.hlsl"

#define MAX_TRACKER_LENGTH 100

struct appdata
{
    float4 vertex : POSITION;
    float2 uv : TEXCOORD0;
};

struct v2f
{
    float2 uv : TEXCOORD0;
    float4 positionCS : SV_POSITION;
    float3 positionWS : VAR_POSITION;
};

sampler2D _MainTex;
float4 _MainTex_ST;
float _TrackerLength;
float4 _TrackerPosition;
float4 _TrackerPositions[MAX_TRACKER_LENGTH];
float4 _SnowColor;
float4 _GroundColor;


v2f vert (appdata v)
{
    v2f o;
    o.uv = TRANSFORM_TEX(v.uv, _MainTex);

    o.positionWS = TransformObjectToWorld(v.vertex);
    float trackerDistance = distance(o.positionWS.xz, _TrackerPosition.xz);

    bool isTrackerPassed = false;
    for(int i =0;i< _TrackerLength;i++){
	if(distance(o.positionWS.xz, _TrackerPositions[i].xz) < .5){
	    isTrackerPassed = true;
	    break;
	}
    }

    if(!isTrackerPassed){
	v.vertex.z += 0.001;
    }

    float n = SimplexNoise(o.uv, 100, .0001);
    v.vertex.z += n;

    o.positionCS = UnityObjectToClipPos(v.vertex);
    o.positionWS = TransformObjectToWorld(v.vertex);

    return o;
}

float4 frag (v2f input) : SV_Target
{
    fixed4 col = tex2D(_MainTex, input.uv);
    float lerpFactor = saturate(input.positionWS.y);
    col = lerp(_GroundColor,_SnowColor,lerpFactor);
    return col;
}
#endif
