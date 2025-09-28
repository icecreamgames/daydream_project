if spin == 1
{
	image_angle += 5;
	
}
if spin_stay == 1
{
	image_angle += 5;
	
}

if place_meeting(x,y,obj_wall)
{
	alarm[0] = 1;
}

if hp<= 0
{
	inst = instance_create_layer(1117,2124,"instances",obj_pedastal);
	inst.image_xscale = 3;
	inst.image_yscale = 3;
	instance_destroy();
	if instance_exists(obj_light)
	{
		instance_destroy(obj_light);
	}
	if instance_exists(obj_light_ball)
	{
		instance_destroy(obj_light_ball);
	}
}