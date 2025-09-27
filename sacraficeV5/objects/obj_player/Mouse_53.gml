if have_spell == 1 and cooldown = 0
{
	instance_create_layer(x,y,"instances",spr_fireball);
	alarm[0] = 60
	cooldown = 1
}