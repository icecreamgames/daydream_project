// Create Event for ball

var spd = 6;

// Get the player's position
var px = obj_player.x;
var py = obj_player.y;

// Point from ball (self) toward player
var ang = point_direction(x, y, px, py);

// Set velocity
hspeed = lengthdir_x(spd, ang);
vspeed = lengthdir_y(spd, ang);

// Optional: set an alarm for later logic
alarm[0] = 120;

// Make the sprite face its motion
image_angle = ang;
