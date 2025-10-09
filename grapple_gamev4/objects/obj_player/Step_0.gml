
// ---------------- INPUT ----------------
var joy_deadzone = 0.25;

// Left stick (movement)
var joy_x = gamepad_axis_value(0, gp_axislh);
var key_left  = keyboard_check(ord("A")) || keyboard_check(vk_left)  || (joy_x < -joy_deadzone);
var key_right = keyboard_check(ord("D")) || keyboard_check(vk_right) || (joy_x >  joy_deadzone);

// Jump (Space or A)
var press_jump = keyboard_check_pressed(vk_space) || gamepad_button_check_pressed(0, gp_face1);
var release_jump = keyboard_check_released(vk_space) || gamepad_button_check_released(0, gp_face1);

// Hold Shift (keyboard) OR LT (Xbox trigger) to hang
var hold_hang = keyboard_check(vk_shift) || gamepad_button_check(0, gp_shoulderlb);
// If your runtime maps triggers as axes instead of buttons, use this instead:
// var hold_hang = keyboard_check(vk_shift) || (gamepad_axis_value(0, gp_axisltrigger) > 0.5);


// Grapple (RT or RMB)
var rt_pressed  = gamepad_button_check_pressed(0, gp_shoulderrb);
var rt_held     = gamepad_button_check(0, gp_shoulderrb);
var rt_released = gamepad_button_check_released(0, gp_shoulderrb);

// Aim (right stick, fallback to mouse)
var joy_rx = gamepad_axis_value(0, gp_axisrh);
var joy_ry = gamepad_axis_value(0, gp_axisrv);
var stick_mag = sqrt(joy_rx*joy_rx + joy_ry*joy_ry);
var using_stick = (stick_mag > joy_deadzone);
// Defaults if you haven't set them in Create

// ---------------- JUMP BUFFER ----------------
if (press_jump) buffer = buffer_max;

// ---------------- FACING / SPRITE ----------------
if (key_left)      { image_xscale = -1; sprite_index = Sprite2; }
else if (key_right){ image_xscale =  1; sprite_index = Sprite2; }
else               { sprite_index = spr_player_idle; }

// ---------------- GROUND / COYOTE ----------------
on_ground = place_meeting(x, y + 1, obj_wall);
if (on_ground) { coyote = coyote_max; } else if (coyote > 0) { coyote -= 1; }

// ---------------- HORIZONTAL CONTROL ----------------
if (key_left)       hsp = -max_hsp;
else if (key_right) hsp =  max_hsp;
else                hsp =  0;

// ---------------- JUMP ----------------
if (buffer > 0) buffer -= 1;
if (buffer > 0 && coyote > 0) {
    vsp = -jump_speed;
    buffer = 0;
    coyote = 0;
}
if (release_jump && vsp < 0) vsp *= 0.5;

// ---------------- GRAVITY ----------------
vsp += grav;
if (vsp > max_fall) vsp = max_fall;

// ---------------- GRAPPLE: FIRE ----------------
if ((mouse_check_button_pressed(mb_right) || rt_pressed) && grapple_state == 0) {
    grapple_state = 1;
    hook_x = x; hook_y = y;
    if (using_stick) hook_dir = point_direction(0, 0, joy_rx, joy_ry);
    else             hook_dir = point_direction(x, y, mouse_x, mouse_y);
    _hook_travel = 0;
}

// ---------------- GRAPPLE: RELEASE / CANCEL ----------------
if ((mouse_check_button_released(mb_right) || rt_released) && grapple_state != 0) {
    grapple_state = 0;
    rope_lock_active = false;
    hook_x = x; hook_y = y;
}

// ---------------- GRAPPLE STATE MACHINE ----------------
switch (grapple_state) {
    case 0: { /* idle */ } break;

    case 1: { // firing ray
        var steps = hook_speed;
        var remaining = hook_max - _hook_travel; if (remaining < 0) remaining = 0;
        if (steps > remaining) steps = remaining;

        repeat (steps) {
            var nx = hook_x + lengthdir_x(1, hook_dir);
            var ny = hook_y + lengthdir_y(1, hook_dir);

            if (collision_point(nx, ny, obj_wall, false, true)) {
                hook_x = nx; hook_y = ny;
                grapple_state = 2;   // latched
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

        // Pull while RT/RMB held (adds grapple momentum; hang will override horizontal)
        if (rt_held || mouse_check_button(mb_right)) {
            var pull = (dist / 60) * pull_accel;
            var cap  = pull_accel * 1.5;
            if (pull < 0) pull = 0;
            if (pull > cap) pull = cap;
			
            gx += lengthdir_x(pull, dir);
            gy += lengthdir_y(pull, dir);

            var gspd = point_distance(0, 0, gx, gy);
            if (gspd > pull_max_speed) {
                var s = pull_max_speed / gspd;
                gx *= s; gy *= s;
            }
        }

        // ----- FALL STRAIGHT UNDER HOOK WHEN HOLDING SHIFT/LT -----
       // --- HOLD Shift/LT to start "fall straight under hook" hang ---
if (hold_hang) {
    if (!rope_lock_active) {
        lock_len = point_distance(x, y, hook_x, hook_y); // capture once
        rope_lock_active = true;
		pull_max_speed = -1;
    }
} else {
	pull_max_speed = 10000;
    rope_lock_active = false;
	
}

    } break;
}

// ---------------- DECAY GRAPPLE MOMENTUM ----------------
if (!(grapple_state == 2 && (rt_held || mouse_check_button(mb_right)))) {
    gx *= slingshot_decay;
    gy *= slingshot_decay;
    if (abs(gx) < 0.01) gx = 0;
    if (abs(gy) < 0.01) gy = 0;
}

// ---------------- COLLISION MOVEMENT ----------------
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
    if (!place_meeting(x + fracx, y, obj_wall)) x += fracx; else { hsp = 0; gx = 0; }
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
    if (!place_meeting(x, y + fracy, obj_wall)) y += fracy; else { vsp = 0; gy = 0; }
}

on_ground = place_meeting(x, y + 1, obj_wall);

// ---------------- FALL-STRAIGHT-DOWN ENFORCEMENT (while Shift/LT held) ----------------
if (grapple_state == 2 && rope_lock_active) {
    // 1) Kill horizontal (tangential) velocity so you stop swinging
    var total_h = hsp + gx;
    gx -= total_h;
    hsp = 0;

    // 2) Center under hook.x (blocked by walls); gentle approach
    var dx_to_hook = hook_x - x;
    var center_step = dx_to_hook;
    // Limit the centering speed without min/max:
    if (center_step < -4) center_step = -4;
    if (center_step >  4) center_step =  4;

    if (center_step != 0) {
        var sx2 = sign(center_step);
        var steps2 = abs(floor(center_step));
        repeat (steps2) {
            if (!place_meeting(x + sx2, y, obj_wall)) x += sx2; else break;
        }
        var frac2 = center_step - floor(abs(center_step)) * sx2;
        if (!place_meeting(x + frac2, y, obj_wall)) x += frac2;
    }

    // 3) Keep rope taut: never let distance exceed lock_len
    var cur_d = point_distance(x, y, hook_x, hook_y);
    if (cur_d > lock_len + 0.01) {
        var a  = point_direction(hook_x, hook_y, x, y);
        var tx = hook_x + lengthdir_x(lock_len, a);
        var ty = hook_y + lengthdir_y(lock_len, a);

        // collision-safe nudge to the circle (no axis bias)
        var nx = tx - x, ny = ty - y;
        var adx = abs(nx), ady = abs(ny);
        var bigger = adx; if (ady > adx) bigger = ady;
        var micro = ceil(bigger); if (micro > 512) micro = 512;

        if (micro > 0) {
            var stepx = nx / micro, stepy = ny / micro;
            var pri = (current_time & 1);
            repeat (micro) {
                var px = x + stepx, py = y + stepy;
                if (pri) {
                    if (!place_meeting(px, py, obj_wall)) { x = px; y = py; }
                    else { if (!place_meeting(px, y, obj_wall)) x = px;
                           if (!place_meeting(x, py, obj_wall)) y = py; }
                } else {
                    if (!place_meeting(px, py, obj_wall)) { x = px; y = py; }
                    else { if (!place_meeting(x, py, obj_wall)) y = py;
                           if (!place_meeting(px, y, obj_wall)) x = px; }
                }
                pri = 1 - pri;
            }
        }
    }
}
// --- SHOOTING: X (Xbox) or Left Click -> fire bullet toward same aim as grapple ---

/*// pressed once this step?
var shoot_pressed = gamepad_button_check_pressed(0, gp_face3) || mouse_check_button_pressed(mb_left);

if (shoot_pressed) {
    // aim same way as grapple: right stick if moved, else mouse
    var aim_dir;
    if (using_stick) {
        aim_dir = point_direction(0, 0, joy_rx, joy_ry);
    } else {
        aim_dir = point_direction(x, y, mouse_x, mouse_y);
    }

    // spawn a little in front of the player so it doesn't collide immediately
    var muzzle_offset = 18; // tweak to taste
    var sx = x + lengthdir_x(muzzle_offset, aim_dir);
    var sy = y + lengthdir_y(muzzle_offset, aim_dir);

    // choose a speed (uses player.bullet_speed if you already made one, else 14)
    var bs = 14;
    if (variable_instance_exists(id, "bullet_speed")) bs = bullet_speed;

    // create bullet
    var b = instance_create_layer(sx, sy, layer, obj_bullet);
    with (b) {
        direction   = aim_dir;
        speed       = bs;
        image_angle = direction;   // optional, for visuals
        owner       = other.id;    // optional, track who fired
    }
}

*/ 
var shoot_pressed = gamepad_button_check_pressed(0, gp_face3) || mouse_check_button_pressed(mb_left);

if (shoot_pressed) {
    if instance_exists(obj_enemy)
	{
		if place_meeting(x,y,obj_enemy)
		{
			
			effect_create_above(ef_firework,obj_enemy.x,obj_enemy.y,1,c_red);
			instance_destroy(obj_enemy);
		}
	}
}
