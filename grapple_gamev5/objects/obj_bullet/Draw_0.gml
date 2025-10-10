// --- GLOW (no shader) ---
var r = 10;                // pixel radius of the halo (try 2–6)
var repeats = 20;          // how many rings (1–3)
var col = make_color_rgb(255, 200, 120); // glow color
var a = 0.35;             // per-pass alpha (0.2–0.5 looks good)

gpu_set_blendenable(true);
gpu_set_blendmode(bm_add);

for (var ring = 1; ring <= repeats; ring++) {
    var off = r * ring;
    // 8 directions
   // draw glow copies evenly around the sprite in 360 degrees
var steps = 24; // number of directions (higher = smoother circle)
for (var i = 0; i < steps; i++) {
    var ang = i * (360 / steps);
    var nx = x + lengthdir_x(off, ang);
    var ny = y + lengthdir_y(off, ang);
    draw_sprite_ext(sprite_index, image_index, nx, ny,
        image_xscale, image_yscale, image_angle, col, a);
}

}

gpu_set_blendmode(bm_normal);
gpu_set_blendenable(false);

// Draw the crisp base sprite on top
draw_self();