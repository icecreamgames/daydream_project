

// --- Movement variables ---
move_speed = 0.6;
max_hsp = 4.5;
jump_speed = 8;
grav = 0.4;        // <— gravity replacement
max_fall = 15;
coyote_max = 6;
buffer_max = 6;

hsp = 0;
vsp = 0;
on_ground = false;
coyote = 0;
buffer = 0;

// --- Grappling hook variables ---
grapple_state = 0;  // 0=idle, 1=firing, 2=latched
hook_x = x;
hook_y = y;
hook_dir = 0;
hook_speed = 50;
hook_max = 1000;

pull_accel = 1.3;
pull_max_speed = 10000.0;
slingshot_decay = 0;
rope_lock_active = false; // true while Shift is holding the length
lock_len = 0;
// the captured rope length for the current hold
// the captured rope length for the current hold
pull_rate = 5;
aim_active = false;
aim_neutral = true;


gx = 0;  // grapple x velocity
gy = 0;  // grapple y velocity
_hook_travel = 0;
// Grapple air-drag tuning
swing_drag   = 0.9999; // hanging (latched but not pulling) -> very light damping for smooth swings
release_drag = 0.90;  // fully detached -> heavier damping so you slow quickly
g_epsilon    = 0.02;  // cutoff for tiny drift
if room == rm_vault
{
	instance_create_layer(x,y,"instances",obj_exit);
}
// restart room if more than one diamond exists
if (instance_number(obj_diamond) > 1) {
    room_restart();
}
hp = 100;