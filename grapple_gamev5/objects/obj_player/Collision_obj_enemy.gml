var shoot_pressed = gamepad_button_check_pressed(0, gp_face3) || mouse_check_button_pressed(mb_left);

if (shoot_pressed) {		
	effect_create_above(ef_firework,obj_enemy.x,obj_enemy.y,1,c_red);
	instance_destroy(other);
}
hp  = 100;