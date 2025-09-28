if instance_exists(obj_fire_ring)
{
	instance_destroy(obj_fire_ring);
}
if instance_exists(obj_fire_side)
{
	instance_destroy(obj_fire_side);
}
if instance_exists(obj_water_side)
{
	instance_destroy(obj_water_side);
}
inst = instance_create_layer(800,1600,"instances",obj_fire_side);
inst.image_xscale = 10;
inst.image_yscale = 20;
attack = irandom_range(1,3)
if attack == 1
{
	sprite_index = Sprite24;
	alarm[0] = 100;
	explode = 1;
}
if attack == 2
{
	sprite_index = Sprite24_1
	alarm[1] = 100
	explode = 1;
}
if attack == 3
{
	sprite_index = Sprite27
	alarm[2] = 100
	explode = 1;
}