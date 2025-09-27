if have_spell_water == 1 and cooldown = 0
{
	instance_create_layer(x,y,"instances",obj_water);
	alarm[0] = 60
	cooldown = 1
}