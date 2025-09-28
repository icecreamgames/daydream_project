no = 0;
speed = 6;
if obj_final_boss.hp <= 20
{
		direction = point_direction(x,y,obj_enemy_pedastal.x,obj_enemy_pedastal.y);
		no = 1;
}
else
{
	if (instance_exists(obj_player_1)) {
	    direction = point_direction(x, y, obj_player_1.x, obj_player_1.y);
	}
	
}
// Tuning values
turn_speed   = .4;   // how fast they curve toward player (degrees/step)
avoid_radius = 24;  // how close before they push off each other
avoid_force  = 4;   // how strongly they repel each other
