if lightning_damage == 1
{
	sprite_index = spr_moon_damage;
	hp -= 5
	effect_create_above(ef_ring,x,y,30,c_red);
	lightning_damage = 0;
	alarm[3] = 30;
	
}