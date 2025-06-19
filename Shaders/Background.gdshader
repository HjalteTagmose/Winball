shader_type canvas_item;
varying vec2 world_position;
uniform float WP_Size;
uniform sampler2D paper_texture;
uniform vec2 Panning_Speed = vec2 (0.1,0.1);
uniform vec4 Mult_Color = vec4(1.5,0.1,3.0,1.0);

void vertex(){
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0, 1.0)).xy;
}

void fragment(){
	//noise_texture = 1.0 - texture(noise_texture,UV).rgb;
	//COLOR = texture(screen_texture,mod(screen_uv+TIME*Panning_Speed,1.0),1.0) + texture(paper_texture,mod(screen_uv+TIME*Panning_Speed,1.0),1.0);
	COLOR = (texture(paper_texture,mod(world_position/WP_Size,1.0),1.0));
}
