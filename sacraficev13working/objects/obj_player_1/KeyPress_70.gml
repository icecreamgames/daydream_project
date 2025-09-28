if have_spell_lightning = 1 and lightning_cooldown = 0
{
	instance_create_layer(mouse_x,mouse_y,"instances",obj_lightning);
	alarm[3] = 300
	lightning_cooldown = 1;
}