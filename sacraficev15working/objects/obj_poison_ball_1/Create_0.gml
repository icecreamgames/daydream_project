
speed = 7;
if obj_final_boss.hp <= 40
{
	direction = point_direction(x,y,obj_player_1.x,obj_player_1.y);
}
else
{
	direction = point_direction(x,y,obj_enemy_pedastal.x,obj_enemy_pedastal.y);
}



image_blend = c_green;