instance_create_layer(spawn_side,irandom_range(1000, 2000),"instances",obj_wave_1);
if side = 1
{
	obj_wave_1.direction = 0
	obj_wave_1.image_xscale = 1
}
if side = 2
{
	obj_wave_1.direction = 180
	obj_wave_1.image_xscale = -1
}
alarm[0] = 120
side = irandom_range(1, 2)