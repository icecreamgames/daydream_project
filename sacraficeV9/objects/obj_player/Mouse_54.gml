if have_spell == 1 and cooldown = 0
{
	instance_create_layer(x,y,"instances",obj_spell);
	alarm[0] = 60
	cooldown = 1
}