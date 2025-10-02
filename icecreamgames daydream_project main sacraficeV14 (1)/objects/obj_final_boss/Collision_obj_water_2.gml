if water_damage = 0
{
hp -= 5;
water_damage = 1;
alarm[5] = 10;
alarm[6] = 30;
image_blend = c_red;
effect_create_above(ef_firework,x,y,30,c_red);
}