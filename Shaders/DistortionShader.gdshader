shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture: hint_screen_texture;
uniform sampler2D DistortionNRM: hint_normal;
uniform float DistortionIntensity;
uniform float offset;
uniform float DistortionUV_Size;
uniform float Speed = 1.0;
uniform vec2 direction = vec2(1.0,0.0);
uniform float radius : hint_range(0.0, 1.0) = 0.5;
uniform float softness : hint_range(0.0, 1.0) = 0.1;

void fragment() {
	vec2 scroll = (textureLod(DistortionNRM,UV+TIME,1).rg);
	vec2 Distortion_UV = UV;
	Distortion_UV += TIME * Speed * direction;
	COLOR = texture(screen_texture,fract(Distortion_UV));
	vec4 NRM_PAN = (textureLod(DistortionNRM,fract(Distortion_UV),0));
	COLOR = texture(screen_texture,(SCREEN_UV+NRM_PAN.rg)*DistortionIntensity);


	float dist = distance(UV, vec2(0.5, 0.5));
  	float alpha = smoothstep(radius - softness, radius + softness, dist);
	float invertedalpha = 1.0 - clamp(alpha, 0 , 1);
  	COLOR.a = invertedalpha;
		// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
