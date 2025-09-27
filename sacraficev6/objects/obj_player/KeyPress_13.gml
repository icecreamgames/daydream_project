if have_spell_poison == 1
{
	instance_create_layer(x,y,"instances",obj_spell_poison);
	alarm[0] = 60
	cooldown = 1
}