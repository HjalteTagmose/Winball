shader_type canvas_item;
varying vec2 world_position;
uniform float WP_Size;
uniform sampler2D paper_texture;
uniform vec2 Panning_Speed = vec2 (0.1,0.1);
uniform vec4 Mult_Color = vec4(1.5,0.1,3.0,1.0);
uniform float radius : hint_range(0.0, 1.0) = 0.5;
uniform float softness : hint_range(0.0, 1.0) = 0.1;
uniform vec2 ScreenUV_AlphaMask_Size = vec2(1.0,1.0);
uniform sampler2D AlphaNoise;
uniform sampler2D screen_texture: hint_screen_texture;

void vertex(){
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0, 1.0)).xy;
}

void fragment(){
	//noise_texture = 1.0 - texture(noise_texture,UV).rgb;
	//COLOR = texture(screen_texture,mod(screen_uv+TIME*Panning_Speed,1.0),1.0) + texture(paper_texture,mod(screen_uv+TIME*Panning_Speed,1.0),1.0);
	COLOR = (texture(paper_texture,mod(world_position/WP_Size,1.0),1.0))*texture(screen_texture,SCREEN_UV,1.0)*5.0 + texture(screen_texture,SCREEN_UV,1.0);
	
	float dist = distance(UV, vec2(0.5, 0.5));
  	float alpha = smoothstep(radius - softness, radius + softness, dist);
	float invertedalpha = 1.0 - clamp(alpha, 0 , 1);
	vec2 Screen_UV_Tile = SCREEN_UV * ScreenUV_AlphaMask_Size;
	float finalalpha = invertedalpha * textureLod(AlphaNoise,mod(world_position/WP_Size,1.0),1).r * invertedalpha + invertedalpha*0.25;
  	COLOR.a = finalalpha;
	
	
	
}
