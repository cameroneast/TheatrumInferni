varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float darkness;

void main()
{
    gl_FragColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
	
	float random = fract(sin(dot(vec2(v_vTexcoord.x, v_vTexcoord.y), vec2(12.9898, 78.233))) * 43758.5453);
	//highp float random= mod(dt,3.14);
	
	if (random > darkness)
		gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
}
