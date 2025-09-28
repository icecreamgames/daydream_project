if spin_stay == 1
{
	alarm[8] = 30;
	ball = instance_create_layer(x,y,"instances",obj_light_ball);
	ball.speed = 7;
	ball.direction = point_direction(x,y,obj_player.x,obj_player.y);
}
