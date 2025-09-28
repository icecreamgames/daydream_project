if damaged = 0
{
sprite_index = spr_boss_damage;
alarm[3] = 10;
effect_create_above(ef_smoke,x,y,30,c_green);
hp -= 20;
damaged = 1
}