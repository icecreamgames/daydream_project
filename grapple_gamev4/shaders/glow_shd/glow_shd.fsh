// no hidden characters or BOM before this line!
#ifdef GL_ES
precision mediump float;
#endif

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform sampler2D gm_BaseTexture;

void main() {
    vec4 base = texture2D(gm_BaseTexture, v_vTexcoord) * v_vColour;

    // simple 4-tap blur for soft glow
    float s = 0.006;
    vec4 glow = vec4(0.0);
    glow += texture2D(gm_BaseTexture, v_vTexcoord + vec2( s,  0.0));
    glow += texture2D(gm_BaseTexture, v_vTexcoord + vec2(-s,  0.0));
    glow += texture2D(gm_BaseTexture, v_vTexcoord + vec2( 0.0,  s));
    glow += texture2D(gm_BaseTexture, v_vTexcoord + vec2( 0.0, -s));
    glow *= 0.25;

    // combine base + amplified glow
    vec3 final_rgb = base.rgb + glow.rgb * 2.0;
    gl_FragColor = vec4(final_rgb, base.a);
}
