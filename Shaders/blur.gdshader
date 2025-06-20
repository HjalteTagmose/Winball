shader_type canvas_item;

uniform float blur = 2.0;
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

void fragment(){
	COLOR = texture(screen_texture, SCREEN_UV, blur);
}