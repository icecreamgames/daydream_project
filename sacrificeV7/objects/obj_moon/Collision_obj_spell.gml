sprite_index = spr_moon_damage;
health -= 5
instance_destroy(other);
effect_create_above(ef_ring,x,y,30,c_red);