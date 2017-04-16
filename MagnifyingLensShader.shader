Shader "BasilAmer/MagnifyingLensShader" {

	Properties {
		_Magnification("Magnification", Range(1,10)) = 1
		_Smoothness("Smoothness", Range(0,1)) = 1
	}
 
    SubShader {

        Tags { "Queue" = "Transparent" }
 
        GrabPass { "_GrabTexture" }

        CGPROGRAM
        #pragma surface surf Standard vertex:vert
        #pragma debug
 
        sampler2D _MainTex;
        sampler2D _GrabTexture;
        half _Magnification;
        float _Smoothness;
 
        struct Input {
            float4 grabUV;
        };
 
        void vert (inout appdata_full v, out Input o) {
            
            float4 hpos = mul (UNITY_MATRIX_MVP, v.vertex);

            float4 uv_center = ComputeGrabScreenPos(UnityObjectToClipPos(float4(0, 0, 0, 1)));

            float4 uv_diff = ComputeGrabScreenPos(mul (UNITY_MATRIX_MVP, v.vertex)) - uv_center;

            uv_diff /= _Magnification;

            o.grabUV = uv_center + uv_diff;

        }
 
        void surf (Input IN, inout SurfaceOutputStandard o) {
            o.Albedo = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(IN.grabUV));
            o.Metallic = 0;
            o.Smoothness = _Smoothness;
        }
        ENDCG
   
    }
 
}
