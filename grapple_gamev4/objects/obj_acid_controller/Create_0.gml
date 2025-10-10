/// obj_acid_controller — Create (Directional Smooth)
CELL = 300;
cols = max(5, floor(room_width  / CELL));
rows = max(5, floor(room_height / CELL));

// ---- phases ----
phase = 0;                // 0 idle, 1 pre-delay, 2 shaft rise, 3 breach pause, 4 flood
acid_triggered = false;

// ---- timings (seconds, real-time) ----
pre_delay_s      = 0.50;   // small beat after grab
breach_pause_s   = 0.80;   // tiny pause at shaft top
cell_fill_s      = 1.5;   // time to fill one cell
neighbor_delay_s = 0.18;   // delay before starting neighbors
shaft_speed_px   = 200.0;  // shaft rise speed (px/sec)

t_phase = 0.0;

// Find shaft column from exit
// find the first diamond instance and store its position
var ex = instance_find(obj_diamond, 0);
if (ex != noone) {
    var diamond_x = ex.x;
    var diamond_y = ex.y;
}

shaft_c = (ex != noone) ? floor(ex.x / CELL) : 1;

// Shaft surface (starts below)
acid_y = room_height + CELL;

// ---- flood state ----
// Progress 0..1 for each cell
flood_prog   = ds_grid_create(cols, rows); ds_grid_clear(flood_prog, 0);
// Start timers (sec) for each cell (-1 = not scheduled; >=0 counting down)
flood_tstart = ds_grid_create(cols, rows); ds_grid_clear(flood_tstart, -1);
// Inflow direction for each cell (-1 unset; 0=from UP, 1=from DOWN, 2=from LEFT, 3=from RIGHT)
flood_dir    = ds_grid_create(cols, rows); ds_grid_clear(flood_dir, -1);
// Active frontier list of [c,r]
frontier     = ds_list_create();

if (!variable_global_exists("acid_triggered")) global.acid_triggered = false;
