shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D bayer_texture : filter_nearest;

uniform sampler2D viewport_texture : filter_nearest;



uniform float hue;
uniform float saturation;
uniform float value;
uniform float brightness;
uniform float contrast;
uniform float ditherLevel;
uniform int renderMode;
render_mode unshaded;

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 palettize1(vec3 col) {
	vec3 palette[4] = { vec3(1.0, 1.0, 1.0), vec3(0.333, 1.0, 1.0), vec3(1.0, 0.333, 1.0), vec3(0,0,0) }; 
	int closest = 0;
	float dist = 100000.0f;
	
	for (int i = 0; i < 4; i++) {
		vec3 col2 = palette[i];
		float temp = (col2.r - col.r) * (col2.r - col.r) + (col2.g - col.g) * (col2.g - col.g) + (col2.b - col.b) * (col2.b - col.b);
		if (temp < dist) {
			dist = temp;
			closest = i;
		}
	}
	return palette[closest];
	
}
vec3 palettize2(vec3 col) {
	vec3 palette[4] = { vec3(1.0, 1.0, 0.33), vec3(1.0, 0.33, 0.33), vec3(0.33, 1.0, 0.33), vec3(0,0,0) }; 

	int closest = 0;
	float dist = 100000.0f;
	
	for (int i = 0; i < 4; i++) {
		vec3 col2 = palette[i];
		float temp = (col2.r - col.r) * (col2.r - col.r) + (col2.g - col.g) * (col2.g - col.g) + (col2.b - col.b) * (col2.b - col.b);
		if (temp < dist) {
			dist = temp;
			closest = i;
		}
	}
	return palette[closest];
	
}
vec3 palettize3(vec3 col) {
	vec3 palette[2] = {vec3(1.0), vec3(0.0)};
	
	int closest = 0;
	float dist = 100000.0f;
	
	for (int i = 0; i < 2; i++) {
		vec3 col2 = palette[i];
		float temp = (col2.r - col.r) * (col2.r - col.r) + (col2.g - col.g) * (col2.g - col.g) + (col2.b - col.b) * (col2.b - col.b);
		if (temp < dist) {
			dist = temp;
			closest = i;
		}
	}
	return palette[closest];
	
}
vec3 palettize4(vec3 col) {
	vec3 palette[16] = { 
		vec3(0.0, 0.0, 0.0), 
		vec3(0.0, 0.0, 1.0), 
		vec3(0.3, 1.0, 0.3), 
		vec3(0.3, 1.0, 1.0),
		vec3(1.0, 0.3, 0.3), 
		vec3(1.0, 0.3, 1.0), 
		vec3(1.0, 1.0, 0.3), 
		vec3(1.0, 1.0, 1.0),
		
		vec3(0.0, 0.0, 0.0), 
		vec3(0.0, 0.0, 0.5), 
		vec3(0.0, 0.5, 0.0), 
		vec3(0.0, 0.5, 0.5),
		vec3(0.5, 0.0, 0.0), 
		vec3(0.5, 0.0, 0.5), 
		vec3(0.5, 0.5, 0.0), 
		vec3(0.5, 0.5, 0.5)
	}; 
	int closest = 0;
	float dist = 100000.0f;
	
	for (int i = 0; i < 16; i++) {
		vec3 col2 = palette[i];
		float temp = (col2.r - col.r) * (col2.r - col.r) + (col2.g - col.g) * (col2.g - col.g) + (col2.b - col.b) * (col2.b - col.b);
		if (temp < dist) {
			dist = temp;
			closest = i;
		}
	}
	return palette[closest];
	
}

vec3 srgb_to_linear(vec3 color) {
	return mix(
		pow((color.rgb + vec3(0.055)) * (1.0 / (1.0 + 0.055)), vec3(2.4)),
		color.rgb * (1.0 / 12.92),
		lessThan(color.rgb, vec3(0.04045))
	);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	//int renderMode = 0;
	//if (SCREEN_UV.x < 0.25) {
		//renderMode = 0;
	//}else if (SCREEN_UV.x < 0.5) {
		//renderMode = 1;
	//}else if (SCREEN_UV.x < 0.75) {
		//renderMode = 2;
	//}else {
		//renderMode = 3;
	//}
	float bayer_matrix[16] = float[16] (
        -0.5,     0.0,  -0.375,   0.125,
        0.25,   -0.25,   0.375,  -0.125,
     -0.3125,  0.1875, -0.4375,  0.0625,
      0.4375, -0.0625,  0.3125, -0.1875
	);
	vec2 screenscale = vec2(0.0);
	if (renderMode == 0) {
		screenscale = vec2(320.0f,200.0f);
	}else if (renderMode == 1) {
		screenscale = vec2(320.0f,200.0f);
	}else if (renderMode == 2) {
		screenscale = vec2(640.0f,200.0f);
	}else if (renderMode == 3) {
		screenscale = vec2(160.0f,100.0f);
	}
	vec2 uv = floor((UV) * screenscale);
	
	int uvx = int(uv.x) % 4;
	int uvy = int(uv.y) % 4;
	
	
	uv /= screenscale;
	vec3 col = texture(viewport_texture, uv+vec2(0.0001)).rgb;

	//float dither = bayer_matrix[uvy * 4 + uvx];
	float dither = texture(bayer_texture, vec2(float(uvx)/32.0f,float(uvy)/32.0f)).r-0.5f;
	

	col = rgb2hsv(col);
	
	vec3 hsv = vec3(hue,saturation,value);
	float ditherTemp = dither;
	if (UV.x > 288.0f/320.0f || UV.y > 168.0f/200.0f) {
		ditherTemp = 0.0;

		col = hsv2rgb(col);

	}else {
		col += hsv;
		//col.r += dither * 0.4;
		col = hsv2rgb(col);
		col = ((col.rgb - 0.5f) * max(contrast, 0)) + 0.5f;
		col += brightness;
	}
	
	

	

	
	if (renderMode == 0) {
		col = palettize1(col+ditherTemp*ditherLevel);
	}else if (renderMode == 1) {
		col = palettize2(col+ditherTemp*ditherLevel);
	}else if (renderMode == 2) {
		col = palettize3(col+ditherTemp*ditherLevel);
	}else if (renderMode == 3) {
		col = palettize4(col+ditherTemp*ditherLevel);
	}
	

	//COLOR = vec4(col,1.0);
	//vec2 testUV = SCREEN_UV;
	//screenscale = vec2(160, 100);
	//testUV = round(testUV * screenscale) / screenscale;
	//ALBEDO = vec3(testUV.x, testUV.y, 0.0f);
	//col = vec3(1.0f,0.333,1.0);
	COLOR = vec4(srgb_to_linear(col), 1.0);
	
	//COLOR = texture(viewport_texture, uv+vec2(0.0001));

}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
