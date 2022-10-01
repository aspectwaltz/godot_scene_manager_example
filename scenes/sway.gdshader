shader_type spatial;
render_mode depth_draw_alpha_prepass;

uniform sampler2D stack_sheet : hint_albedo;

void vertex(){
	VERTEX.x = VERTEX.x + (1.0-COLOR.b*COLOR.g)*0.1*sin(TIME + COLOR.b*COLOR.g);
	VERTEX.z = VERTEX.z + (1.0-COLOR.b*COLOR.g)*0.1*cos(TIME + COLOR.b*COLOR.g);
}


void fragment() {
	float layer_height = COLOR.g;
	float layer_index = COLOR.b;
	vec4 albedo_tex = texture(stack_sheet, UV * vec2(1, layer_height) + vec2(0, layer_index * layer_height));
	ALPHA = albedo_tex.a;
	ALBEDO = albedo_tex.rgb;
}