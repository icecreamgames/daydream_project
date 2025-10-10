draw_self();

// === CONTROLLER INPUT ===
var joy_rx = gamepad_axis_value(0, gp_axisrh);
var joy_ry = gamepad_axis_value(0, gp_axisrv);
var rt_pressed = gamepad_button_check(0, gp_shoulderrb); // RT hold or press
var joy_deadzone = 0.25;

// === CONDITIONS TO SHOW LINE ===
var stick_moved = (abs(joy_rx) > joy_deadzone || abs(joy_ry) > joy_deadzone);

// Red dotted aim line (stops on walls)
if (stick_moved && !rt_pressed) {
    var aim_dir = point_direction(0, 0, joy_rx, joy_ry);
    var aim_len = 1000;  // max length
    var step = 10;       // spacing between dots
    var cx = x;
    var cy = y;

    draw_set_color(c_red);
    draw_set_alpha(0.9);

    var dist = 0;
    var hit = false;

    while (dist < aim_len && !hit) {
        var nx = cx + lengthdir_x(dist, aim_dir);
        var ny = cy + lengthdir_y(dist, aim_dir);

        if (position_meeting(nx, ny, obj_wall)) {
            hit = true; // stop when wall hit
        } else {
            draw_circle(nx, ny, 4, false);
        }
        dist += step;
    }

    //draw_set_alpha(1);
    draw_set_color(c_white);
}

if (grapple_state == 1 || grapple_state == 2) {
    draw_set_color(c_white);
    draw_line(x, y, hook_x, hook_y);
}
