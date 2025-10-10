/// obj_acid_controller — Step (Directional Smooth)
var dt = delta_time * 0.000001; // seconds
if (dt <= 0) dt = 1 / max(30, room_speed);

// Trigger from diamond
if (!acid_triggered && global.acid_triggered) {
    acid_triggered = true;
    phase = 1;
    t_phase = pre_delay_s;
}

switch (phase) {

    case 0: break;

    case 1:
        t_phase -= dt;
        if (t_phase <= 0) {
            phase = 2;
            acid_y = room_height + CELL;
        }
        break;

    case 2: // Shaft rise
        acid_y -= shaft_speed_px * dt;
        if (acid_y <= 1.0 * CELL) {
            acid_y = 1.0 * CELL;
            phase = 3;
            t_phase = breach_pause_s;

            // Seed top entrance cell: inflow FROM DOWN (rising up the shaft)
            var c0 = clamp(shaft_c, 1, cols - 2);
            var r0 = 1;
            flood_tstart[# c0, r0] = 0.0;
            flood_dir[# c0, r0]    = 1;   // from DOWN
            ds_list_add(frontier, [c0, r0]);
        }
        break;

    case 3: // tiny pause
        t_phase -= dt;
        if (t_phase <= 0) phase = 4;
        break;

    case 4: { // Direction-aware flood
        // Advance existing frontier cells
        var new_frontier = ds_list_create();
        var n = ds_list_size(frontier);
        for (var i = 0; i < n; i++) {
            var cell = ds_list_find_value(frontier, i);
            var c = cell[0], r = cell[1];
            if (c < 1 || c > cols-2 || r < 1 || r > rows-2) continue;
            if (instance_position(c*CELL, r*CELL, obj_wall) != noone) continue;

            // Start if timer already hit zero
            if (flood_tstart[# c, r] <= 0) {
                // Progress this cell
                var p = flood_prog[# c, r];
                if (p <= 0) p = 0.0001;
                p += dt / cell_fill_s;
                if (p > 1) p = 1;
                flood_prog[# c, r] = p;

                // When crossing 0.6, enqueue neighbors with proper inflow direction (just once)
                if (p >= 0.6 && p - (dt / cell_fill_s) < 0.6) {
                    var t0 = neighbor_delay_s;

                    // Up neighbor: its inflow is FROM DOWN
                    if (r-1 >= 1 && instance_position(c*CELL, (r-1)*CELL, obj_wall) == noone && flood_tstart[# c, r-1] < 0) {
                        flood_tstart[# c, r-1] = t0;
                        flood_dir[# c, r-1]    = 1; // from DOWN
                        ds_list_add(new_frontier, [c, r-1]);
                    }
                    // Down neighbor: inflow FROM UP
                    if (r+1 <= rows-2 && instance_position(c*CELL, (r+1)*CELL, obj_wall) == noone && flood_tstart[# c, r+1] < 0) {
                        flood_tstart[# c, r+1] = t0;
                        flood_dir[# c, r+1]    = 0; // from UP
                        ds_list_add(new_frontier, [c, r+1]);
                    }
                    // Left neighbor: inflow FROM RIGHT
                    if (c-1 >= 1 && instance_position((c-1)*CELL, r*CELL, obj_wall) == noone && flood_tstart[# c-1, r] < 0) {
                        flood_tstart[# c-1, r] = t0;
                        flood_dir[# c-1, r]    = 3; // from RIGHT
                        ds_list_add(new_frontier, [c-1, r]);
                    }
                    // Right neighbor: inflow FROM LEFT
                    if (c+1 <= cols-2 && instance_position((c+1)*CELL, r*CELL, obj_wall) == noone && flood_tstart[# c+1, r] < 0) {
                        flood_tstart[# c+1, r] = t0;
                        flood_dir[# c+1, r]    = 2; // from LEFT
                        ds_list_add(new_frontier, [c+1, r]);
                    }
                }

                // Keep cell active until fully filled
                if (p < 1.0) ds_list_add(new_frontier, cell);
            } else {
                // Countdown to start
                flood_tstart[# c, r] = max(0, flood_tstart[# c, r] - dt);
                ds_list_add(new_frontier, cell);
            }
        }

        // Replace frontier
        ds_list_destroy(frontier);
        frontier = new_frontier;
        break;
    }
}
