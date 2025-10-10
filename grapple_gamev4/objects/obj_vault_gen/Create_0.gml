/// obj_vault_gen — Create (regenerates until start→finish path exists)
randomize();

var CELL = 300;
var cols = max(5, floor(room_width  / CELL));
var rows = max(5, floor(room_height / CELL));
var enemy_num = 15;
// how many times we’ll try before giving up (very unlikely to need many on 13×13)
var MAX_TRIES = 1000000000000000000000000000000000000000000000;

var attempt, ok;
ok = false;

for (attempt = 0; attempt < MAX_TRIES && !ok; attempt++) {

    // ---------- CLEAN PREVIOUS ATTEMPT ----------
    with (obj_wall)    instance_destroy();
    with (obj_exit)    instance_destroy();
    with (obj_enemy)   instance_destroy();
    with (obj_player)  instance_destroy();

    // ---------- PICK SHAFT & GUARDS ----------
    var shaft_side = irandom(1);                 // 0 = left, 1 = right
    var shaft_c    = (shaft_side == 0) ? 1 : (cols - 2);
    if (shaft_c % 2 == 0) shaft_c += (shaft_side == 0) ? 1 : -1; // prefer odd interior

    // guards exist only if they’re true neighbors (avoid overlapping shaft)
    var guard_l = (shaft_c > 1)        ? shaft_c - 1 : -1;
    var guard_r = (shaft_c < cols - 2) ? shaft_c + 1 : -1;

    // ---------- CHOOSE START (odd interior, not on guards) ----------
    var sc = clamp(floor(x / CELL), 1, cols - 2);
    var sr = clamp(floor(y / CELL), 1, rows - 2);
    if (sc % 2 == 0) sc += (sc < cols - 2) ? 1 : -1;
    if (sr % 2 == 0) sr += (sr < rows - 2) ? 1 : -1;
    if (sc == guard_l) sc = clamp(sc - 1, 1, cols - 2);
    if (sc == guard_r) sc = clamp(sc + 1, 1, cols - 2);
    if (sc % 2 == 0) sc += (sc < cols - 2) ? 1 : -1;

    // ---------- DATA ----------
    var visited = ds_grid_create(cols, rows); ds_grid_clear(visited, 0);
    var dist    = ds_grid_create(cols, rows); ds_grid_clear(dist, -1);
    var st      = ds_stack_create();

    // ---------- LAY DOWN WALLS ----------
    for (var j = 0; j < rows; j++) {
        for (var i = 0; i < cols; i++) {
            instance_create_layer(i * CELL, j * CELL, layer, obj_wall);
        }
    }

    // ---------- DFS MAZE (turn-biased, skip guards below row 1) ----------
    visited[# sc, sr] = 1;
    dist[# sc, sr] = 0;
    ds_stack_push(st, (sc << 16) | sr);

    // open start
    var w0 = instance_position(sc * CELL, sr * CELL, obj_wall);
    if (w0 != noone) with (w0) instance_destroy();

    while (!ds_stack_empty(st)) {
        var p  = ds_stack_top(st);
        var cc = (p >> 16) & $FFFF;
        var rr = p & $FFFF;

        // previous direction estimate from dist
        var prev_dir = -1; // 0=up,1=down,2=left,3=right
        var dcur = dist[# cc, rr];
        if (dcur > 0) {
            if (rr - 2 >= 1        && visited[# cc, rr - 2] && dist[# cc, rr - 2] == dcur - 1) prev_dir = 0;
            else if (rr + 2 <= rows-2 && visited[# cc, rr + 2] && dist[# cc, rr + 2] == dcur - 1) prev_dir = 1;
            else if (cc - 2 >= 1        && visited[# cc - 2, rr] && dist[# cc - 2, rr] == dcur - 1) prev_dir = 2;
            else if (cc + 2 <= cols-2   && visited[# cc + 2, rr] && dist[# cc + 2, rr] == dcur - 1) prev_dir = 3;
        }

        var opts_turn = ds_list_create();
        var opts_stra = ds_list_create();

        // helper to add candidate if not carving into guard columns for r>=2
        var c2, r2, is_guard;

        // up
        c2 = cc; r2 = rr - 2;
        if (r2 >= 1 && !visited[# c2, r2]) {
            is_guard = (r2 >= 2) && ((guard_l != -1 && c2 == guard_l) || (guard_r != -1 && c2 == guard_r));
            if (!is_guard) ds_list_add(((prev_dir == 0) ? opts_stra : opts_turn), (c2<<16)|r2);
        }
        // down
        c2 = cc; r2 = rr + 2;
        if (r2 <= rows - 2 && !visited[# c2, r2]) {
            is_guard = (r2 >= 2) && ((guard_l != -1 && c2 == guard_l) || (guard_r != -1 && c2 == guard_r));
            if (!is_guard) ds_list_add(((prev_dir == 1) ? opts_stra : opts_turn), (c2<<16)|r2);
        }
        // left
        c2 = cc - 2; r2 = rr;
        if (c2 >= 1 && !visited[# c2, r2]) {
            is_guard = (r2 >= 2) && ((guard_l != -1 && c2 == guard_l) || (guard_r != -1 && c2 == guard_r));
            if (!is_guard) ds_list_add(((prev_dir == 2) ? opts_stra : opts_turn), (c2<<16)|r2);
        }
        // right
        c2 = cc + 2; r2 = rr;
        if (c2 <= cols - 2 && !visited[# c2, r2]) {
            is_guard = (r2 >= 2) && ((guard_l != -1 && c2 == guard_l) || (guard_r != -1 && c2 == guard_r));
            if (!is_guard) ds_list_add(((prev_dir == 3) ? opts_stra : opts_turn), (c2<<16)|r2);
        }

        var chosen = -1;
        if (ds_list_size(opts_turn) > 0 && irandom(99) < 80) {
            chosen = ds_list_find_value(opts_turn, irandom(ds_list_size(opts_turn) - 1));
        } else {
            var total = ds_list_size(opts_turn) + ds_list_size(opts_stra);
            if (total > 0) {
                var pick = irandom(total - 1);
                if (pick < ds_list_size(opts_turn)) chosen = ds_list_find_value(opts_turn, pick);
                else chosen = ds_list_find_value(opts_stra, pick - ds_list_size(opts_turn));
            }
        }

        if (chosen != -1) {
            var nc = (chosen >> 16) & $FFFF;
            var nr =  chosen        & $FFFF;

            visited[# nc, nr] = 1;
            dist[# nc, nr] = dcur + 1;

            // knock out midpoint + destination
            var mid_c = (cc + nc) >> 1;
            var mid_r = (rr + nr) >> 1;

            var w_mid = instance_position(mid_c * CELL, mid_r * CELL, obj_wall);
            if (w_mid != noone) with (w_mid) instance_destroy();

            var w_dst = instance_position(nc * CELL, nr * CELL, obj_wall);
            if (w_dst != noone) with (w_dst) instance_destroy();

            ds_stack_push(st, chosen);
        } else {
            ds_stack_pop(st);
        }

        ds_list_destroy(opts_turn);
        ds_list_destroy(opts_stra);
    }

    // ---------- outer border ----------
    for (var i = 0; i < cols; i++) {
        if (!instance_position(i*CELL, 0, obj_wall))                 instance_create_layer(i*CELL, 0, layer, obj_wall);
        if (!instance_position(i*CELL, (rows-1)*CELL, obj_wall))     instance_create_layer(i*CELL, (rows-1)*CELL, layer, obj_wall);
    }
    for (var j = 0; j < rows; j++) {
        if (!instance_position(0, j*CELL, obj_wall))                 instance_create_layer(0, j*CELL, layer, obj_wall);
        if (!instance_position((cols-1)*CELL, j*CELL, obj_wall))     instance_create_layer((cols-1)*CELL, j*CELL, layer, obj_wall);
    }

    // ---------- guaranteed corridor to top entrance (row 1 → shaft_c) ----------
    var cc2 = sc, rr2 = sr;
    while (rr2 != 1) {
        rr2 -= 1;
        var wV = instance_position(cc2 * CELL, rr2 * CELL, obj_wall);
        if (wV != noone) with (wV) instance_destroy();
    }
    while (cc2 != shaft_c) {
        cc2 += sign(shaft_c - cc2);
        var wH = instance_position(cc2 * CELL, rr2 * CELL, obj_wall);
        if (wH != noone) with (wH) instance_destroy();
    }

    // ---------- carve shaft & seal guards (single entrance only) ----------
    for (var rS = 1; rS <= rows - 2; rS++) {
        var wC = instance_position(shaft_c * CELL, rS * CELL, obj_wall);
        if (wC != noone) with (wC) instance_destroy();
    }
    for (var rG = 2; rG <= rows - 2; rG++) {
        if (guard_l != -1 && !instance_position(guard_l * CELL, rG * CELL, obj_wall))
            instance_create_layer(guard_l * CELL, rG * CELL, layer, obj_wall);
        if (guard_r != -1 && !instance_position(guard_r * CELL, rG * CELL, obj_wall))
            instance_create_layer(guard_r * CELL, rG * CELL, layer, obj_wall);
    }

    // ---------- place exit at bottom of shaft ----------
    var exit_c = shaft_c;
    var exit_r = rows - 2;
    instance_create_layer(exit_c * CELL, exit_r * CELL, layer, obj_diamond);

    // ---------- choose a LOW spawn cell (not shaft/guards), then place player ----------
    var pc = sc, pr = sr, found = false;
    for (var rFind = rows - 2; rFind >= 1 && !found; rFind--) {
        for (var cFind = 1; cFind <= cols - 2; cFind++) {
            var in_shaft = (cFind == shaft_c && rFind >= 1 && rFind <= rows - 2);
            var in_guard = ((cFind == guard_l || cFind == guard_r) && rFind >= 2);
            if (!in_shaft && !in_guard && instance_position(cFind * CELL, rFind * CELL, obj_wall) == noone) {
                pc = cFind; pr = rFind; found = true; break;
            }
        }
    }
    instance_create_layer(pc * CELL + CELL * 0.5, pr * CELL + CELL * 0.5, layer, obj_player);

    // ---------- CONNECTIVITY CHECK: can we reach exit from player? ----------
    var reach = ds_grid_create(cols, rows); ds_grid_clear(reach, 0);
    var q = ds_list_create();
    ds_list_add(q, (pc<<16)|pr);
    reach[# pc, pr] = 1;

    while (ds_list_size(q) > 0) {
        var pp = ds_list_find_value(q, 0); ds_list_delete(q, 0);
        var cx = (pp >> 16) & $FFFF;
        var cy =  pp        & $FFFF;

        // 4-neighbors over open cells only
        var nx, ny;

        nx = cx; ny = cy - 1;
        if (ny >= 1 && instance_position(nx*CELL, ny*CELL, obj_wall) == noone && reach[# nx, ny] == 0) {
            reach[# nx, ny] = 1; ds_list_add(q, (nx<<16)|ny);
        }
        nx = cx; ny = cy + 1;
        if (ny <= rows-2 && instance_position(nx*CELL, ny*CELL, obj_wall) == noone && reach[# nx, ny] == 0) {
            reach[# nx, ny] = 1; ds_list_add(q, (nx<<16)|ny);
        }
        nx = cx - 1; ny = cy;
        if (nx >= 1 && instance_position(nx*CELL, ny*CELL, obj_wall) == noone && reach[# nx, ny] == 0) {
            reach[# nx, ny] = 1; ds_list_add(q, (nx<<16)|ny);
        }
        nx = cx + 1; ny = cy;
        if (nx <= cols-2 && instance_position(nx*CELL, ny*CELL, obj_wall) == noone && reach[# nx, ny] == 0) {
            reach[# nx, ny] = 1; ds_list_add(q, (nx<<16)|ny);
        }
    }

    ok = (reach[# exit_c, exit_r] == 1);
	// ===== ENEMY SPAWN =====
if (ok) {
    var safe_cells = 3;                         // min cell distance from player/diamond
    var tries_max  = 2000;                      // attempts budget
    var spawned    = 0;

    var used = ds_grid_create(cols, rows); ds_grid_clear(used, 0);

    /* diamond cell (same as exit)
    var dc = exit_c;
    var dr = exit_r;

    repeat (tries_max) {
        if (spawned >= enemy_num) break;

        var ec = irandom_range(1, cols - 2);
        var er = irandom_range(1, rows - 2);

        // must be an open carved cell
        if (instance_position(ec * CELL, er * CELL, obj_wall) != noone) continue;

        // exclude shaft column and its guard columns (below row 1 for guards)
        var in_shaft  = (ec == shaft_c && er >= 1 && er <= rows - 2);
        var in_guard  = ((ec == guard_l || ec == guard_r) && er >= 2);
        if (in_shaft || in_guard) continue;

        // keep distance from player spawn and diamond cell
        if (point_distance(ec, er, pc, pr) <= safe_cells) continue;
        if (point_distance(ec, er, dc, dr) <= safe_cells) continue;

        // unique cell & clear of walls (pixel collision check at center)
        if (used[# ec, er] == 1) continue;

        var sx = ec * CELL + CELL * 0.5;
        var sy = er * CELL + CELL * 0.5;
        if (collision_circle(sx, sy, CELL * 0.2, obj_wall, true, true) != noone) continue;

        // also avoid stacking on another enemy (pixel radius)
        if (instance_position(sx, sy, obj_enemy) != noone) continue;

        instance_create_layer(sx, sy, layer, obj_enemy);
        used[# ec, er] = 1;
        spawned += 1;
    }
*/
    ds_grid_destroy(used);
	
}


    // cleanup DS for this attempt
    ds_list_destroy(q);
    ds_grid_destroy(reach);
    ds_grid_destroy(visited);
    ds_grid_destroy(dist);
    ds_stack_destroy(st);
}

// If we ever hit MAX_TRIES without a valid path (extremely rare), you’ll still have the last build.
// You can show a debug message if you want:
// if (!ok) show_debug_message("Maze gen: fell back after MAX_TRIES");
