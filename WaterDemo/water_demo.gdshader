shader_type spatial;

uniform float time_scale : hint_range(0.0, 10.0, 0.25) = 1.0;
uniform float roughness : hint_range(0.0, 1.0, 0.1) = 0.2;

uniform sampler2D water_normal_noise;

uniform vec3 water_color : source_color;

uniform bool use_screen_texture = true;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable;

void fragment() {
	vec2 _uv = UV;

	// move the UV values independently so that it will be more flow-like
	_uv.x += sin(TIME * time_scale + (_uv.x + _uv.y) * 25.0) * 0.01;
	_uv.y += sin(TIME * time_scale + (_uv.x - _uv.y) * 25.0) * 0.01;

	// Using the water color variable is just setting the ALBEDO
	if (use_screen_texture) {
		vec2 _suv = SCREEN_UV;
		// move the UV values independently so that it will be more flow-like
		_suv.x += sin(TIME * time_scale + (_suv.x + _suv.y) * 25.0) * 0.01;
		_suv.y += sin(TIME * time_scale + (_suv.x - _suv.y) * 25.0) * 0.01;
		// use the screen_texture to show what's below it
		ALBEDO = texture(screen_texture, _suv).rgb;
	} else {
		ALBEDO = water_color;
	}

	ROUGHNESS = roughness;

	NORMAL_MAP = texture(water_normal_noise, _uv).rgb;
	NORMAL *= 0.5;
}