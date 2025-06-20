shader_type canvas_item;
uniform vec2 ScreenUV_AlphaMask_Size = vec2(1.0,1.0);
uniform float radius : hint_range(0.0, 1.0) = 0.5;
uniform float softness : hint_range(0.0, 1.0) = 0.1;
uniform sampler2D screen_texture: hint_screen_texture;
uniform sampler2D DistortionNRM: hint_normal;
uniform float Speed = 1.0;
uniform vec2 DistortionUV_Size = vec2(1.0,.0);
uniform vec2 direction = vec2(1.0,0.0);
uniform float DistortionIntensity;


uniform float r_offset_x = -0.2;
uniform float r_offset_y = 0.0;
uniform float g_offset_x = 0.0;
uniform float g_offset_y = 0.0;
uniform float b_offset_x = 0.2;
uniform float b_offset_y = 0.0;
uniform float chromatic_intesity = 1.0;
uniform float chromatic_offset = 1.0;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    vec2 pixelSize = TEXTURE_PIXEL_SIZE;
    vec3 r_val;
    vec3 g_val;
    vec3 b_val;

    // Offset for red channel
    r_val = texture(screen_texture, SCREEN_UV + vec2(r_offset_x, r_offset_y) * pixelSize).rgb;
    // Offset for green channel
    g_val = texture(screen_texture, SCREEN_UV + vec2(g_offset_x, g_offset_y) * pixelSize).rgb;
    // Offset for blue channel
    b_val = texture(screen_texture, SCREEN_UV + vec2(b_offset_x, b_offset_y) * pixelSize).rgb;

    // Combine the color channels
    vec3 chromatic_aberration = vec3(r_val.r*chromatic_offset, g_val.g*chromatic_offset, b_val.b*chromatic_offset);

    // Apply the effect
    COLOR.rgb = chromatic_aberration*chromatic_intesity;
	
	float dist = distance(UV, vec2(0.5, 0.5));
  	float alpha = smoothstep(radius - softness, radius + softness, dist);
	vec2 Screen_UV_Tile = SCREEN_UV * ScreenUV_AlphaMask_Size;

  	COLOR.a = alpha;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
