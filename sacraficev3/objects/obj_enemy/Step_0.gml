if spin == 1
{
	image_angle += 3;
	speed= 10;
}
else
{
	speed = 3;
}

if place_meeting(x,y,obj_wall)
{
	alarm[0] = 1;
}
