if side = 1
{
	spawn_side = 0
}
if side = 2
{
	spawn_side = 1400
}
if hp <= 0
{
	instance_destroy();
	inst = instance_create_layer(Object26.x,Object26.y,"instances",obj_pedastal_2);
	inst.image_xscale = 3;
	inst.image_yscale = 3;
}