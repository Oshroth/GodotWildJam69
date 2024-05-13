shader_type canvas_item;

// Uniforms
uniform sampler2D screen_texture : hint_screen_texture;
uniform float grain_amount : hint_range(0.0, 1.0) = 0.05; // Adjust the amount of grain
uniform float grain_size : hint_range(0.1, 10.0) = 1.0; // Adjust the size of the grain
uniform vec4 target_color: source_color;

vec3 when_eq(vec3 x, vec3 y) {
  return 1.0 - abs(sign(x - y));
}

bool colorMatch(vec4 c1, vec4 c2, float maxDiff) {
    return (
        abs(c1.r - c2.r) < maxDiff
        && abs(c1.g - c2.g) < maxDiff
        && abs(c1.b - c2.b) < maxDiff
    );
}

void fragment() {
    // Sample the original screen texture
    vec4 original_color = texture(screen_texture, SCREEN_UV);

    // Generate random noise
    float noise = (fract(sin(dot(UV, vec2(12.9898, 78.233))) * 43758.5453) - 0.5) * 2.0;

    // Add noise to the original color
	if (colorMatch(original_color,target_color,0.001)) {
		 original_color.rgb += noise * grain_amount * grain_size ;
		 
	}
   

    // Clamp the final color to make sure it stays in the valid range
   COLOR = clamp(original_color, 0.0, 1.0);
}
