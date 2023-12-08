varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4 shader_uvs;

float mapFrom0To1(float x, float out_min, float out_max)
{
    float in_min = 0.0; // Use float literals
    float in_max = 1.0; // Use float literals
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

void main()
{
    gl_FragColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    
    float map = mapFrom0To1(0.8, shader_uvs[0], shader_uvs[2]);
	
	if (v_vTexcoord.x > map)
		gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
}
