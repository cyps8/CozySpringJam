shader_type canvas_item;

uniform vec4 color : source_color = vec4(1.0);

uniform bool colder_shadows = false;

void fragment() {
	if (COLOR.a > 0.00001)
	{
		float strength = 0.0;
		if (COLOR.r > 0.0)
		{
			strength = (COLOR.r + COLOR.g + COLOR.b) / 3.0;
		}
		vec3 component = color.rgb * strength;
		if (colder_shadows)
		{
			component.r -= 0.3 * color.r * (1.0 - strength);
			component.g -= 0.2 * color.g * (1.0 - strength);
			component.b -= 0.1 * color.b * (1.0 - strength);
		}
		COLOR = vec4(component, COLOR.a);
	}
}
