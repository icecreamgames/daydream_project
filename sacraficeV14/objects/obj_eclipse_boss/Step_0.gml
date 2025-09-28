if hp <= 0
{
if instance_exists(obj_fire_ring)
	{
		instance_destroy(obj_fire_ring);
	}
if instance_exists(obj_fire_side)
	{
		instance_destroy(obj_fire_side);
	}
if instance_exists(obj_water_side)
	{
		instance_destroy(obj_water_side);
	}
instance_destroy()
}