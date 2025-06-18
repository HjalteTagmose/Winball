shader_type canvas_item;
varying vec2 world_position;

uniform sampler2D screen_texture;
uniform sampler2D paper_texture;
uniform vec2 Panning_Speed = vec2 (0.1,0.1);

void fragment(){
	vec2 scroll = texture(screen_texture, UV +TIME*Panning_Speed,1.0).xy;
	vec2 screen_uv = SCREEN_UV;
	vec2 screen_paper = texture(paper_texture, UV +TIME*Panning_Speed,1.0).xy;
	vec2 texture_combined = scroll*0.5 + screen_paper;
	COLOR = texture(screen_texture,mod(screen_uv+TIME*Panning_Speed,1.0),1.0) + texture(paper_texture,mod(screen_uv+TIME*Panning_Speed,1.0),1.0);
	COLOR.a = 0.4;
}
