attack = irandom_range(1,3);
if attack == 1
{
	alarm[2] = 300;
	alarm[4] = 240;
}
if attack == 2
{
	alarm[5] = 300;
}
if attack == 3
{
	alarm[7] = 300;
}
sprite_index = spr_boss_1;
instance_create_layer(x,y,"instances",obj_light);