if lightning_damage == 1
{
	image_blend = c_red
	alarm[3] = 10;
	effect_create_above(ef_ring,x,y,30,c_red);
	hp -= 5;
	lightning_damage = 0;
	alarm[5] = 30;
}