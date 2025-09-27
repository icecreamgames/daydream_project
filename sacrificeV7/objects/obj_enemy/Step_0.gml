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