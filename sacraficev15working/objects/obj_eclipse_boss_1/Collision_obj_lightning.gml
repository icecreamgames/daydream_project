if lightning_damage = 0
{
image_blend = c_red
alarm[3] = 10;
effect_create_above(ef_smoke,x,y,30,c_green);
hp -= 20;
lightning_damage = 1;
}