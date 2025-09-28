if damaged == 0
{
sprite_index = spr_moon_damage;
hp -= 20
effect_create_above(ef_ring,x,y,30,c_red);
damaged = 1;
}