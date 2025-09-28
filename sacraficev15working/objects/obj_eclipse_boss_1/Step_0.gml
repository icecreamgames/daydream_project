if hp <= 0
{
if instance_exists(obj_fire_ring_1)
	{
		instance_destroy(obj_fire_ring_1);
	}
if instance_exists(obj_fire_side_1)
	{
		instance_destroy(obj_fire_side_1);
	}
if instance_exists(obj_water_side_1)
	{
		instance_destroy(obj_water_side_1);
	}
instance_destroy()
obj_player_1.x = Object110.x;
obj_player_1.y = Object110.y;
obj_camera_point.x = Object110.x;
obj_camera_point.y = Object110.y;
}