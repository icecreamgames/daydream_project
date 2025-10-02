attack = irandom_range(1,3)
if attack == 1
{
	sprite_index = spr_eclipse;
	alarm[0] = 100;
	
}
if attack == 2
{
	sprite_index = spr_sun_eclipse;
	alarm[1] = 100
	explode = 1;
	
}
if attack == 3
{
	sprite_index = spr_moon_eclipse;
	alarm[2] = 100
	explode = 1;
	
}
explode = 0;
hp = 200
water_damage = 0;
lightning_damage = 0;
image_xscale = 3;
image_yscale = 3;