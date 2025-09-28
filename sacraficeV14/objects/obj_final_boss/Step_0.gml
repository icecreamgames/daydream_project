direction = point_direction(x,y,obj_player_1.x,obj_player_1.y);
if hp <= 0
{
	if stop == 0
	{
	instance_create_layer(x+50,  y,      "instances", obj_mini_boss);
	instance_create_layer(x-50,  y,      "instances", obj_mini_boss);
	instance_create_layer(x,      y+50,  "instances", obj_mini_boss);
	instance_create_layer(x,      y-50,  "instances", obj_mini_boss);
	instance_create_layer(x+50,  y+50,   "instances", obj_mini_boss);
	instance_create_layer(x+50,  y-50,   "instances", obj_mini_boss);
	instance_create_layer(x-50,  y+50,   "instances", obj_mini_boss);
	instance_create_layer(x-50,  y-50,   "instances", obj_mini_boss);

	instance_create_layer(x+100, y,      "instances", obj_mini_boss);
	instance_create_layer(x-100, y,      "instances", obj_mini_boss);
	instance_create_layer(x,      y+100, "instances", obj_mini_boss);
	instance_create_layer(x,      y-100, "instances", obj_mini_boss);
	instance_create_layer(x+100, y+50,   "instances", obj_mini_boss);
	instance_create_layer(x+100, y-50,   "instances", obj_mini_boss);
	instance_create_layer(x-100, y+50,   "instances", obj_mini_boss);
	instance_create_layer(x-100, y-50,   "instances", obj_mini_boss);

	instance_create_layer(x+150, y,      "instances", obj_mini_boss);
	instance_create_layer(x-150, y,      "instances", obj_mini_boss);
	instance_create_layer(x,      y+150, "instances", obj_mini_boss);
	instance_create_layer(x,      y-150, "instances", obj_mini_boss);
	instance_create_layer(x+150, y+50,   "instances", obj_mini_boss);
	instance_create_layer(x+150, y-50,   "instances", obj_mini_boss);
	instance_create_layer(x-150, y+50,   "instances", obj_mini_boss);
	instance_create_layer(x-150, y-50,   "instances", obj_mini_boss);

	instance_create_layer(x+200, y,      "instances", obj_mini_boss);
	instance_create_layer(x-200, y,      "instances", obj_mini_boss);
	instance_create_layer(x,      y+200, "instances", obj_mini_boss);
	instance_create_layer(x,      y-200, "instances", obj_mini_boss);
	instance_create_layer(x+200, y+50,   "instances", obj_mini_boss);
	instance_create_layer(x+200, y-50,   "instances", obj_mini_boss);
	instance_create_layer(x-200, y+50,   "instances", obj_mini_boss);
	instance_create_layer(x-200, y-50,   "instances", obj_mini_boss);

	instance_create_layer(x+250, y,      "instances", obj_mini_boss);
	instance_create_layer(x-250, y,      "instances", obj_mini_boss);
	instance_create_layer(x,      y+250, "instances", obj_mini_boss);
	instance_create_layer(x,      y-250, "instances", obj_mini_boss);
	instance_create_layer(x+250, y+50,   "instances", obj_mini_boss);
	instance_create_layer(x+250, y-50,   "instances", obj_mini_boss);
	instance_create_layer(x-250, y+50,   "instances", obj_mini_boss);
	instance_create_layer(x-250, y-50,   "instances", obj_mini_boss);

	instance_create_layer(x+300, y,      "instances", obj_mini_boss);
	instance_create_layer(x-300, y,      "instances", obj_mini_boss);
	instance_create_layer(x,      y+300, "instances", obj_mini_boss);
	instance_create_layer(x,      y-300, "instances", obj_mini_boss);
	instance_create_layer(x+300, y+50,   "instances", obj_mini_boss);
	instance_create_layer(x+300, y-50,   "instances", obj_mini_boss);
	instance_create_layer(x-300, y+50,   "instances", obj_mini_boss);
	instance_create_layer(x-300, y-50,   "instances", obj_mini_boss);

	instance_create_layer(x+150, y+150,  "instances", obj_mini_boss);
	
	instance_create_layer(x-150, y-150,  "instances", obj_mini_boss);
	stop = 1;
	instance_destroy();
	}

}