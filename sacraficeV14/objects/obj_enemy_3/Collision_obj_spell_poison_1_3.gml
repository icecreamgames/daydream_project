sprite_index = spr_boss_damage;
alarm[3] = 10;
instance_destroy(other);
effect_create_above(ef_smoke,x,y,30,c_green);
hp -= 1;