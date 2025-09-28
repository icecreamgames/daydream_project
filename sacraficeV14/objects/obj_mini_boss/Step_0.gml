if (!instance_exists(obj_player_1)) exit;

// Get angle to player
var target_dir = point_direction(x, y, obj_player_1.x, obj_player_1.y)+180;

// Find smallest angle difference
var diff = angle_difference(direction, target_dir);

// Slowly turn toward target
if (abs(diff) < turn_speed) {
    direction = target_dir; // snap if nearly aligned
} else {
    direction += sign(diff) * turn_speed;
}

// Keep moving forward
speed = 4;
image_angle = direction;
