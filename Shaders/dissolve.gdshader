shader_type spatial;
// This is needed for toroids and other objects with faces behind other faces.
// It also allows for shadows on meshes with this shader.
render_mode depth_prepass_alpha;

uniform sampler2D noise_texture;

uniform sampler2D depth_texture : hint_depth_texture;

uniform vec3 base_color : source_color = vec3(0.0, 1.0, 0.0);

// The height of the dissolve effect. This can be thought of as a percentage
// of how much is dissolved.
uniform float dissolve_height : hint_range(0.0, 1.0, 0.01) = 1.0;

// How much of the noise should effect the value
uniform float noise_scale: hint_range(0.0, 1.0, 0.1) = 0.1;

// Color the object should Glow.
// This requires that the camera have an environment that supports glowing.
// This color also needs to have a value > 1.0 for whatever color we want to
// glow.
uniform vec3 glow_color : source_color;
uniform float glow_thickness: hint_range(0.0, 1.0) = 0.05;

varying float yPos;

void vertex() {
	// normalize from -1.0 - 1.0 => 0 - 1.0
	yPos = (VERTEX.y + 1.0) * 0.5;
}

void fragment() {
	// get a noise value and only use one the r channel
	float noise_at = texture(noise_texture, UV + TIME * 0.1).r * noise_scale;

	// we want to normalize the noise_val so that we get something
	// between 0.0 and 1.0. This can cause some floating point issues
	float noise_val = 0.0;

	if (dissolve_height < 1.0) {
		//// Originally I was dividing this by 2.0, but that's before I added in the
		//// noise_scale variable.
		noise_val = (yPos + noise_at);
	}

	// always set the base_color
	//ALBEDO = vec3(yPos,0.0, 0.0);
	ALBEDO = base_color;

	// fade out the parts of the shape that should be gone
	ALPHA = 1.0 - step(dissolve_height, noise_val);

	// add the glow line based on the glow_thickness using the glow_color
	EMISSION = step(dissolve_height - glow_thickness, noise_val) * glow_color;
}
