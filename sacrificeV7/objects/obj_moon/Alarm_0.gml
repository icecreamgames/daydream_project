instance_create_layer(spawn_side,irandom_range(2000, 3000),"instances",obj_wave);
if side = 1
{
	obj_wave.direction = 0
	obj_wave.image_xscale = 1
}
if side = 2
{
	obj_wave.direction = 180
	obj_wave.image_xscale = -1
}
alarm[0] = 120
side = irandom_range(1, 2)