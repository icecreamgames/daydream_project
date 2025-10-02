if (dash_timer > 0) dash_timer--;
if (cooldown_timer > 0) cooldown_timer--;

if (post_dash_click_timer > 0) post_dash_click_timer++;
if (combo_blue_timer > 0)      combo_blue_timer--;

// Read WASD as a vector (so we know dash direction)
var dx = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var dy = keyboard_check(ord("S")) - keyboard_check(ord("W"));

// Update last non-zero direction (so dash works from idle)
if (dx != 0 || dy != 0) {
    // normalize to unit vector
    var len = point_distance(0, 0, dx, dy);
    dx /= len; dy /= len;
    last_dx = dx; last_dy = dy;
}

// Start dash (Space)
if (!dashing && cooldown_timer <= 0 && keyboard_check_pressed(vk_shift)) {
    // Use current input dir or last facing if idle
    var ndx = (dx == 0 && dy == 0) ? last_dx : dx;
    var ndy = (dx == 0 && dy == 0) ? last_dy : dy;

    // If somehow still zero, default down
    if (ndx == 0 && ndy == 0) { ndx = 0; ndy = 1; }

    dash_dir_x = ndx;
    dash_dir_y = ndy;

    dashing    = true;
	post_dash_click_window = 30; // click window after dash start
    dash_timer = dash_duration;
	post_dash_click_timer = 1; // start counting frames since dash start

    cooldown_timer = dash_cooldown;
}

// Make dashing grant i-frames (ties into your invincible flag)
//invincible = dashing;

if (dashing) {
    // Move in dash direction, 1 pixel at a time for solid collision safety
    var dir = point_direction(0, 0, dash_dir_x, dash_dir_y);

    repeat (dash_speed) {
        var nx = x + lengthdir_x(1, dir);
        var ny = y + lengthdir_y(1, dir);

        if (!place_meeting(nx, ny, obj_wall)) {
            x = nx; y = ny;
        } else break; // stop dash on collision
    }

    if (dash_timer <= 0) {
       dashing = false;
    }

} else {
    // ===== Normal movement (your original logic, with the same sprites) =====
    // Move up
    if combo_blue_timer <= 0
	{
		if (keyboard_check(ord("W"))) {
	        if (!place_meeting(x, y - move_speed, obj_wall)) {
	            y -= move_speed;
	            sprite_index = spr_player_back;
	        }
	    }

	    // Move down
	    if (keyboard_check(ord("S"))) {
	        if (!place_meeting(x, y + move_speed, obj_wall)) {
	            y += move_speed;
	            sprite_index = spr_player_front;
	        }
	    }

	    // Move left
	    if (keyboard_check(ord("A"))) {
	        if (!place_meeting(x - move_speed, y, obj_wall)) {
	            x -= move_speed;
	            sprite_index = spr_player_side_left;
	        }
	    }

	    // Move right
	    if (keyboard_check(ord("D"))) {
	        if (!place_meeting(x + move_speed, y, obj_wall)) {
	            x += move_speed;
	            sprite_index = spr_player_side_right;
	        }
	    }
	}
	//else if combo_blue_timer > 0
	//{
		//speed = 7;
		//direction = point_direction(x,y,obj_player_1.x,obj_player_1.y);
	//}
}

if hp <= 0
{
	room_restart();
	room_goto(rm_gameover);
	
}
// Color priority: combo blue > invincible red > normal white
if (combo_blue_timer > 0) {
    image_blend = c_blue;
} else if (invincible) {
    image_blend = c_red;
} else {
    image_blend = c_white;
}


if (mouse_check_button_pressed(mb_left)) {
    if (post_dash_click_timer >= 10 && post_dash_click_timer <= 30) {
        combo_blue_timer = 120; // stay blue for 20 frames
        post_dash_click_timer = 0; // stop further triggers
    }
}
