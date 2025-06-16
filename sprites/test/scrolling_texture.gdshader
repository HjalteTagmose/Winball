shader_type canvas_item;

uniform sampler2D scroll_texture: filter_nearest;
uniform vec4 replace_color : source_color;
uniform vec2 tiling = vec2(1.0, 1.0);
uniform vec2 direction = vec2(1.0, 1.0);
uniform float speed = 1.0;
uniform float rotation = 0.0;
uniform float scale = 1.0;

vec2 rotated(vec2 a, float angle) {
	float s = sin(angle);
	float c = cos(angle);
	vec2 res = a - 0.5;

	res.x = a.x * c - a.y * s;
	res.y = a.x * s + a.y * c;

	return res + 0.5;
}

void fragment() {
	if (COLOR == replace_color)
	{
		vec2 newUV = (UV - 0.5) * scale + 0.5;
		newUV = rotated(newUV, rotation);
	    newUV *= tiling;
        newUV += direction * TIME * speed;

		newUV = fract(newUV);
		COLOR = texture(scroll_texture, newUV);
	}
}
