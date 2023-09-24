shader_type spatial;
render_mode blend_mix, depth_draw_always  ;


// Varyings
varying float height;
varying vec2 uv_global;
varying vec3 world_pos;
uniform float uv_scale;
uniform float uvx : hint_range(0, 10, 0.00999999977648) = 0;
uniform float uvy : hint_range(0, 10, 0.00999999977648);
uniform float Terrain_height : hint_range(0, 255, 1) = 255;
uniform sampler2D HeightMap : source_color,repeat_disable;
uniform float gradient_blend;
uniform sampler2D gradient_texture;
uniform sampler2D ground_texture : filter_nearest;

void vertex() {

	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;

	uv_global = world_pos.xz / (256.0 * uv_scale);
	height = texture(HeightMap, uv_global).r;
	VERTEX.y += height * Terrain_height;


}

void fragment() {

	vec4 height_texture_data;
// Texture2D:3
	height_texture_data = texture(HeightMap, uv_global);

	// distance fade
	vec2 world_pos2 = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xz;
	vec2 dist_vert = vec2(VERTEX.x,VERTEX.z);	
	float dist = distance(vec2(0,0),dist_vert);
	float darken = 1.0;
	if (dist > 150.0){
		darken = clamp(1.0 - ((dist - 150.0) / 10.0),0.0,1.0);
		//ALPHA = ALPHA * darken;
	}	
	
	//color_amp

	vec3 sampled_color = texture(gradient_texture, vec2(height_texture_data.r,0.0)).rgb;
	
	vec3 texture_color = texture(ground_texture, uv_global).rgb;
	ALBEDO = mix(sampled_color,texture_color,gradient_blend);
	ROUGHNESS = 1.0;
	METALLIC = 1.0;
// Output:0



}
