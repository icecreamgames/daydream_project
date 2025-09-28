if instance_exists(obj_fire_ring_1)
{
	instance_destroy(obj_fire_ring_1);
}
if instance_exists(obj_fire_side_1)
{
	instance_destroy(obj_fire_side_1);
}
if instance_exists(obj_water_side_1)
{
	instance_destroy(obj_water_side_1);
}
inst = instance_create_layer(800,30,"instances",obj_water_side_1);
inst.image_xscale = -20;
inst.image_yscale = 20;
inst.image_blend = c_blue;
attack = irandom_range(1,3)
if attack == 1
{
	sprite_index = spr_eclipse;
	alarm[0] = 100;
	explode = 1;
}
if attack == 2
{
	sprite_index = spr_sun_eclipse
	alarm[1] = 100
	explode = 1;
}
if attack == 3
{
	sprite_index = spr_moon_eclipse
	alarm[2] = 100
	explode = 1;
}