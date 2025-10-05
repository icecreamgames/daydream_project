/// ===============================
/// Platformer + Grapple (Shift = hang at current length, swing OK)
/// ===============================

// --- INPUT ---
var key_left  = keyboard_check(ord("A")) || keyboard_check(vk_left);
var key_right = keyboard_check(ord("D")) || keyboard_check(vk_right);
var holding_shift = keyboard_check(vk_shift);
if (keyboard_check_pressed(vk_space)) buffer = buffer_max;

// --- GROUND / COYOTE ---
on_ground = place_meeting(x, y + 1, obj_wall);
if (on_ground) coyote = coyote_max; else if (coyote > 0) coyote--;

// --- HORIZONTAL CONTROL (instant stop) ---
if (key_left)       hsp = -max_hsp;
else if (key_right) hsp =  max_hsp;
else                hsp =  0;

// --- JUMP ---
if (buffer > 0) buffer--;
if (buffer > 0 && coyote > 0) {
    vsp = -jump_speed;
    buffer = 0;
    coyote = 0;
}
if (keyboard_check_released(vk_space) && vsp < 0) vsp *= 0.5;

// --- GRAVITY ---
vsp += grav;
if (vsp > max_fall) vsp = max_fall;

// --- GRAPPLE INPUT ---
if (mouse_check_button_pressed(mb_right) && grapple_state == 0) {
    grapple_state = 1;
    hook_x = x; hook_y = y;
    hook_dir = point_direction(x, y, mouse_x, mouse_y);
    _hook_travel = 0;
}

// Release only when button released
if (mouse_check_button_released(mb_right) && grapple_state != 0) {
    grapple_state = 0;
    rope_lock_active = false;
    hook_x = x; hook_y = y;
}

// --- SHIFT: toggle hang while grappled ---
if (grapple_state == 2) {
    if (keyboard_check_pressed(vk_shift)) {
        lock_len = point_distance(x, y, hook_x, hook_y); // capture once
        rope_lock_active = true;
    }
    if (keyboard_check_released(vk_shift)) {
        rope_lock_active = false;
    }
} else {
    rope_lock_active = false;
}

// --- GRAPPLE STATE MACHINE ---
switch (grapple_state) {
    case 0: {
        // idle
    } break;

    case 1: { // firing
        var steps = hook_speed;
        var remaining = hook_max - _hook_travel;
        if (remaining < 0) remaining = 0;
        if (steps > remaining) steps = remaining;

        repeat (steps) {
            var nx = hook_x + lengthdir_x(1, hook_dir);
            var ny = hook_y + lengthdir_y(1, hook_dir);

            if (collision_point(nx, ny, obj_wall, false, true)) {
                hook_x = nx; hook_y = ny;
                grapple_state = 2; // latched
                rope_lock_active = false;
                break;
            }

            hook_x = nx; hook_y = ny;
            _hook_travel += 1;

            if (_hook_travel >= hook_max) {
                grapple_state = 0;
                hook_x = x; hook_y = y;
                break;
            }
        }
    } break;

    case 2: { // latched
        var dist = point_distance(x, y, hook_x, hook_y);
        if (dist < 0.0001) dist = 0.0001;
        var dir  = point_direction(x, y, hook_x, hook_y);

        // Pull only while button held (hang lock will prevent length change)
        if (mouse_check_button(mb_right)) {
            // pull = clamp((dist/60)*pull_accel, 0, pull_accel*1.5) without min/max
            var pull = (dist / 60) * pull_accel;
            var cap  = pull_accel * 1.5;
            if (pull < 0) pull = 0;
            if (pull > cap) pull = cap;

            gx += lengthdir_x(pull, dir);
            gy += lengthdir_y(pull, dir);

            // Cap grapple speed (no min/max)
            var gspd = point_distance(0, 0, gx, gy);
            if (gspd > pull_max_speed) {
                var s = pull_max_speed / gspd;
                gx *= s; gy *= s;
            }
        }
    } break;
}

// --- DECAY GRAPPLE MOMENTUM ---
if (!(grapple_state == 2 && mouse_check_button(mb_right))) {
    gx *= slingshot_decay;
    gy *= slingshot_decay;
    if (abs(gx) < 0.01) gx = 0;
    if (abs(gy) < 0.01) gy = 0;
}

// --- COLLISION MOVEMENT (no sinking) ---
var mvx = hsp + gx;
var mvy = vsp + gy;

// Horizontal
if (mvx != 0) {
    var sx = sign(mvx);
    var absv = abs(floor(mvx));
    repeat (absv) {
        if (!place_meeting(x + sx, y, obj_wall)) x += sx;
        else { hsp = 0; gx = 0; break; }
    }
    var fracx = mvx - floor(abs(mvx)) * sx;
    if (!place_meeting(x + fracx, y, obj_wall)) x += fracx;
    else { hsp = 0; gx = 0; }
}

// Vertical
if (mvy != 0) {
    var sy = sign(mvy);
    var absvy = abs(floor(mvy));
    repeat (absvy) {
        if (!place_meeting(x, y + sy, obj_wall)) y += sy;
        else { vsp = 0; gy = 0; break; }
    }
    var fracy = mvy - floor(abs(mvy)) * sy;
    if (!place_meeting(x, y + fracy, obj_wall)) y += fracy;
    else { vsp = 0; gy = 0; }
}

on_ground = place_meeting(x, y + 1, obj_wall);

// --- HANG ENFORCEMENT (only if locked by Shift) ---
// Keeps exact lock_len, unbiased (no left/clockwise drift), still allows swing.
if (grapple_state == 2 && rope_lock_active) {
    var cur_d = point_distance(x, y, hook_x, hook_y);
    var eps_d = 0.05;

    if (cur_d != 0 && abs(cur_d - lock_len) > eps_d) {
        var a  = point_direction(hook_x, hook_y, x, y);
        var tx = hook_x + lengthdir_x(lock_len, a);
        var ty = hook_y + lengthdir_y(lock_len, a);

        // If line is clear, snap exactly (no step bias)
        if (!collision_line(x, y, tx, ty, obj_wall, false, true)) {
            x = tx; y = ty;
        } else {
            // Symmetric micro-steps, alternating axis priority to avoid bias
            var dx = tx - x, dy = ty - y;
            var adx = abs(dx), ady = abs(dy);
            var bigger = adx; if (ady > adx) bigger = ady;
            var steps = ceil(bigger); if (steps > 512) steps = 512;

            if (steps > 0) {
                var stepx = dx / steps, stepy = dy / steps;
                var pri = (current_time & 1); // flips each micro-step

                repeat (steps) {
                    var nx = x + stepx, ny = y + stepy;

                    if (pri) {
                        if (!place_meeting(nx, ny, obj_wall)) { x = nx; y = ny; }
                        else { if (!place_meeting(nx, y, obj_wall)) x = nx;
                               if (!place_meeting(x, ny, obj_wall)) y = ny; }
                    } else {
                        if (!place_meeting(nx, ny, obj_wall)) { x = nx; y = ny; }
                        else { if (!place_meeting(x, ny, obj_wall)) y = ny;
                               if (!place_meeting(nx, y, obj_wall)) x = nx; }
                    }
                    pri = 1 - pri;
                }
            }
        }
    }

    // Remove radial velocity from grapple momentum ONLY (keeps swing)
    var rx = x - hook_x, ry = y - hook_y;
    var rlen = point_distance(0, 0, rx, ry);
    if (rlen < 0.0001) rlen = 0.0001;

    var ux = rx / rlen, uy = ry / rlen;          // radial unit
    var tvx = hsp + gx, tvy = vsp + gy;          // total velocity
    var radial_v = tvx * ux + tvy * uy;          // component along rope

    gx -= radial_v * ux;
    gy -= radial_v * uy;

    // Tiny tangent deadzone (clears float fuzz without killing swing)
    var txu = -uy, tyu = ux;                      // tangent unit
    var tan_v = (hsp + gx) * txu + (vsp + gy) * tyu;
    if (abs(tan_v) < 0.00025) { gx -= tan_v * txu; gy -= tan_v * tyu; }
}
