Shader "BasilAmer/MagnifyingLensShader" {

  Properties {
  	_LensColor("Lens Color", Color) = (1,1,1,1)
	_Magnification("Magnification", Range(1,10)) = 1
	_Smoothness("Smoothness", Range(0,1)) = 1
  }
 
  SubShader {
        Tags { "Queue" = "Transparent" "RenderType" = "Transparent" }
 
        GrabPass { "_GrabTexture" }

        CGPROGRAM
        #pragma surface surf Standard vertex:vert
 
        sampler2D _GrabTexture;
        float4 _LensColor;
        half _Magnification;
        float _Smoothness;
 
        struct Input {
            float4 grabUV;
        };
 
        void vert (inout appdata_full v, out Input o) {
            float4 center = ComputeGrabScreenPos(UnityObjectToClipPos(float4(0, 0, 0, 1)));
            float4 diff = ComputeGrabScreenPos(UnityObjectToClipPos (v.vertex)) - center;
            diff /= _Magnification;
            o.grabUV = center + diff;
        }
 
        void surf (Input IN, inout SurfaceOutputStandard o) {
            o.Albedo = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(IN.grabUV)) * _LensColor;
            o.Metallic = 0;
            o.Smoothness = _Smoothness;
        }

        ENDCG
    }
}
