shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float brightness = 1.0;

uniform float night = 0.0;

void fragment() {
    vec3 col = texture(screen_texture, SCREEN_UV).xyz * brightness;
	
    float strength = 0.0;
	strength = (col.r + col.g + col.b) / 3.0;
		
	vec3 component = col.rgb * (strength + ((1.0 - strength) * (1.0 - night)));
	component.r -= (0.4 * col.r * (1.0 - strength)) * night;
	component.g -= (0.1 * col.g * (1.0 - strength)) * night;
	component.b += (0.5 * col.b * (1.0 - strength)) * night;
	
	COLOR = vec4(component, COLOR.a);
}
