if damaged = 0
{
hp -= 20;
damaged = 1;
alarm[5] = 10;
alarm[7] = 30;
image_blend = c_red;
effect_create_above(ef_firework,x,y,30,c_red);
}