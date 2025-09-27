if water_cooldown = 1
{
	sprite_index = spr_boss_damage;
	alarm[3] = 10
	effect_create_above(ef_ring,x,y,30,c_red);
	hp -= 5;
	water_cooldown = 2
	alarm[9] = 30
}