speed = 3;
knockback = 0;

direction = random_range(1,360);
attack = irandom_range(1,3);
if attack == 1
{
	alarm[2] = 300;
	alarm[4] = 240;
}
if attack == 2
{
	alarm[5] = 300;
}
if attack == 3
{
	alarm[7] = 300;
}
spin = 0;
spin_stay = 0;
hp = 100;