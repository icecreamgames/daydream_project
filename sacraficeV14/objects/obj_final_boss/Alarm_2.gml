instance_create_layer(x-50,y,"instances",obj_poison_ball);
instance_create_layer(x+50,y,"instances",obj_poison_ball);
instance_create_layer(x-100,y,"instances",obj_poison_ball);
instance_create_layer(x+100,y,"instances",obj_poison_ball);
instance_create_layer(x+200,y,"instances",obj_poison_ball);
instance_create_layer(x-200,y,"instances",obj_poison_ball);
instance_create_layer(x+300,y,"instances",obj_poison_ball);
instance_create_layer(x-300,y,"instances",obj_poison_ball);
instance_create_layer(x+400,y,"instances",obj_poison_ball);
instance_create_layer(x-400,y,"instances",obj_poison_ball);
attack = irandom_range(1,4);
if attack == 1
{
	if not obj_player_1.have_spell
	{
		alarm[0] = 200;
	}
	else
	{
		alarm[4] = 1;
	}
}

if attack == 2
{
	if not obj_player_1.have_spell_water
	{
		alarm[1] = 200;
	}
	else
	{
		alarm[4] = 1;
	}
}
if attack == 3
{
	if not obj_player_1.have_spell_poison
	{
		alarm[2] = 200;
	}
	else
	{
		alarm[4] = 1;
	}
}
if attack == 4
{
	if not obj_player_1.have_spell_lightning
	{
		alarm[3] = 200;
	}
	else
	{
		alarm[4] = 1;
	}
}