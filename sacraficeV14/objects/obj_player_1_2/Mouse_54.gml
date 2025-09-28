if have_spell == 1 and cooldown = 0
{
	instance_create_layer(x,y,"instances",obj_spell_1);
	alarm[0] = 60
	cooldown = 1
}