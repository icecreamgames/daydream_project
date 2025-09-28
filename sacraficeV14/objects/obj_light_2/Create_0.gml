// Create Event for ball
speed = 7;
alarm[0] = 120;
direction = point_direction(x,y,obj_player_1.x,obj_player_1.y);

// Make the sprite face its motion
image_angle = direction;
alarm[0] = 60;
destroy = 0;

