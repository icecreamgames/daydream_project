move_speed = 5;
have_spell = 1;
have_spell_water = 1;
cooldown = 0
water_cooldown = 0
have_spell_poison = 1;
hp = 100
invincible = false
lightning_cooldown = 0
have_spell_lightning = 1
// Turn off viewport 0
view_visible[0] = false;

// Turn on viewport 1
view_visible[1] = true;

draw_set_color(c_white);
draw_text(32, 32, "Health: " + string(hp));