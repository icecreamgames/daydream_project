
	obj_player.have_spell = 0;
	instance_destroy();
	other.image_blend = c_red;
	other.alarm[0] = 60;
	obj_gate.image_speed = 1;
	instance_destroy(other);
