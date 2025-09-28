speed = 4; 
if obj_final_boss.hp <= 80
{
	direction = point_direction(x,y,obj_enemy_pedastal.x,obj_enemy_pedastal.y);
	stop = 0;
}
else
{
direction = point_direction(x,y,obj_player_1.x,obj_player_1.y);
	stop = 0;
}