shader_type canvas_item;
varying vec2 world_position;
uniform float WP_Size;
uniform float WP_Size_Dots;
uniform sampler2D screen_texture;
uniform sampler2D paper_texture;
uniform sampler2D noise_texture;
uniform vec2 Panning_Speed = vec2 (0.1,0.1);
uniform vec4 Mult_Color = vec4(1.5,0.1,3.0,1.0);

void vertex(){
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0, 1.0)).xy;
}

void fragment(){
	vec2 scroll = texture(screen_texture, UV +TIME*Panning_Speed,1.0).xy;
	vec2 screen_uv = SCREEN_UV;
	vec2 screen_paper = texture(paper_texture, UV +TIME*Panning_Speed,1.0).xy;
	vec2 texture_combined = scroll*0.5 + screen_paper;
	//noise_texture = 1.0 - texture(noise_texture,UV).rgb;
	//COLOR = texture(screen_texture,mod(screen_uv+TIME*Panning_Speed,1.0),1.0) + texture(paper_texture,mod(screen_uv+TIME*Panning_Speed,1.0),1.0);
	COLOR = (texture(paper_texture,mod(world_position/WP_Size,1.0),1.0) +
	texture(screen_texture,mod(world_position/WP_Size_Dots+TIME*Panning_Speed,1.0),1.0))
	 * (texture(noise_texture,mod(world_position/WP_Size_Dots,1.0),1.0) * Mult_Color);
	COLOR.a = 0.4;
}
