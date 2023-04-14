shader_type spatial;

uniform float power = 0;
uniform float light_intensity = 1;
uniform vec3 light_color = vec3(1, 1, 1);

void fragment() {
	EMISSION = vec3(1, 1, 1) * power * light_intensity;
	ALPHA = power;
}
