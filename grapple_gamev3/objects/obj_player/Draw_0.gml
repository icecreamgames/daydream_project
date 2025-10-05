/// -------- Platformer + Grapple: DRAW --------
if (grapple_state == 1 || grapple_state == 2) {
    draw_set_color(c_white);
    draw_line(x, y, hook_x, hook_y);
}
draw_self();
// Your sprite draw as usual afterward (or let default draw run)
