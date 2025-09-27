if water_damage == 1
{
	sprite_index = spr_moon_damage;
	health -= 5
	effect_create_above(ef_ring,x,y,30,c_red);
	water_damage = 0;
	alarm[2] = 30;
}