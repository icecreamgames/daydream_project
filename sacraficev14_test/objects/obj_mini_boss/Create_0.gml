// Aim them at the player to start
if (instance_exists(obj_player_1)) {
    direction = point_direction(x, y, obj_player_1.x, obj_player_1.y);
}
speed = 4;

// Tuning values
turn_speed   = .5;   // how fast they curve toward player (degrees/step)
avoid_radius = 24;  // how close before they push off each other
avoid_force  = 4;   // how strongly they repel each other
