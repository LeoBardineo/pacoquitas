shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float blur_force : hint_range(0.0, 5.0) = 2.5;

void fragment() {
    vec4 color = textureLod(screen_texture, SCREEN_UV, blur_force);
    COLOR = color * vec4(0.7, 0.7, 0.7, 1.0); 
}