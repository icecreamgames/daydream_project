move_speed = 5;
have_spell = 1;
have_spell_water = 1;
have_spell_lightning = 1;
cooldown = 0
water_cooldown = 0
have_spell_poison = 1;
hp = 100;
invincible = false
lightning_cooldown = 0;
/// Dash vars
dash_speed     = 20;   // pixels per step while dashing
dash_duration  = 10;   // steps the dash lasts
dash_cooldown  = 20;   // steps before you can dash again

dashing        = false;
dash_timer     = 0;
cooldown_timer = 0;

last_dx = 0; // last non-zero move direction (x)
last_dy = 1; // ...and (y), default facing down
post_dash_click_timer = 0; // counts frames since dash started
combo_blue_timer      = 0; // how long to stay blue after the combo triggers
