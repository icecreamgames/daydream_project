if have_spell_water == 1 and water_cooldown = 0
{
	instance_create_layer(x,y,"instances",obj_water_2);
	alarm[1] = 180
	water_cooldown = 1
}