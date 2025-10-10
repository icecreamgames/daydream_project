/// obj_acid_controller — Draw (transparent base + bubbling effects)

// ---------- base colors / alpha ----------
var base_alpha = 0.70;
var c_top = make_color_rgb(80, 240, 160);
var c_bot = make_color_rgb(40, 160, 110);

// ---------- 1) Draw the transparent acid base ----------
draw_set_alpha(base_alpha);

// Shaft column (Phase 2+)
if (phase >= 2) {
    var sx1 = shaft_c * CELL, sx2 = sx1 + CELL;
    var sy1 = acid_y,        sy2 = room_height;
    if (sy1 < sy2) draw_rectangle_colour(sx1, sy1, sx2, sy2, c_top, c_top, c_bot, c_bot, false);
}

// Flooded maze cells (Phase 4+), with per-cell fill amount
if (phase >= 4) {
    for (var r = 1; r <= rows-2; r++) {
        for (var c = 1; c <= cols-2; c++) {
            var p = flood_prog[# c, r];
            if (p > 0) {
                var x1 = c * CELL, y1 = r * CELL;
                var x2 = x1 + CELL, y2 = y1 + CELL;

                // Directional fill (uses flood_dir you already track)
                if (flood_dir[# c, r] == 1) { // from DOWN: bottom -> top
                    var ty = y2 - (p * CELL);
                    draw_rectangle_colour(x1, ty, x2, y2, c_top, c_top, c_bot, c_bot, false);
                } else if (flood_dir[# c, r] == 0) { // from UP: top -> bottom
                    var by = y1 + (p * CELL);
                    draw_rectangle_colour(x1, y1, x2, by, c_top, c_top, c_bot, c_bot, false);
                } else if (flood_dir[# c, r] == 2) { // from LEFT: left -> right
                    var rx = x1 + (p * CELL);
                    draw_rectangle_colour(x1, y1, rx, y2, c_top, c_top, c_bot, c_bot, false);
                } else if (flood_dir[# c, r] == 3) { // from RIGHT: right -> left
                    var lx = x2 - (p * CELL);
                    draw_rectangle_colour(lx, y1, x2, y2, c_top, c_top, c_bot, c_bot, false);
                } else {
                    // fallback: bottom -> top
                    var ty2 = y2 - (p * CELL);
                    draw_rectangle_colour(x1, ty2, x2, y2, c_top, c_top, c_bot, c_bot, false);
                }
            }
        }
    }
}

// ---------- 2) Add bubbling green “explosion” effects on top ----------
if (phase >= 4) {
    var t = current_time * 0.001;

    // how many bubbles per frame
    var bub_count = 36;

    repeat (bub_count) {
        var bx = irandom(room_width);
        var by = irandom(room_height);

        // decide if the random point is inside visible acid
        var in_acid = false;

        // inside shaft?
        if (phase >= 2) {
            var scx1 = shaft_c * CELL, scx2 = scx1 + CELL;
            if (bx >= scx1 && bx < scx2 && by >= acid_y) in_acid = true;
        }

        // inside flooded cell?
        if (!in_acid && phase >= 4) {
            var cc = floor(bx / CELL);
            var rr = floor(by / CELL);
            if (cc >= 1 && cc <= cols-2 && rr >= 1 && rr <= rows-2) {
                var pcell = flood_prog[# cc, rr];
                if (pcell > 0.55) in_acid = true; // only when cell is mostly filled
            }
        }

        if (in_acid) {
            // pulsing size + slight randomization
            var size  = 10 + random(24);
            var pulse = 0.5 + 0.5 * abs(sin(t + random(3)));
            var rad   = size * pulse;

            // soft green burst
			effect_create_above(ef_spark,bx,by,2,c_green);
            draw_set_alpha(0.22 + random(0.18));
            var c_outer = make_color_rgb(40 + irandom(20), 255, 100 + irandom(40));
            var c_inner = make_color_rgb(10, 180 + irandom(40), 60 + irandom(30));
            draw_circle_color(bx, by, rad, c_inner, c_outer, false);
        }
    }
}

// optional: thin shimmering surface line at shaft top (nice highlight)
if (phase >= 2 && acid_y < room_height) {
    draw_set_alpha(0.35);
    draw_set_color(make_color_rgb(120, 255, 180));
    draw_rectangle(shaft_c*CELL, acid_y-2, shaft_c*CELL + CELL, acid_y, false);
}

// reset state
draw_set_alpha(1);
draw_set_color(c_white);
// --- Damage player if touching acid ---
with (obj_player) {
    var cc = floor(x / other.CELL);
    var rr = floor(y / other.CELL);
    var in_acid = false;

    // Rising shaft column
    if (x >= other.shaft_c * other.CELL && x < (other.shaft_c + 1) * other.CELL && y >= other.acid_y)
        in_acid = true;

    // Flooded room cells
    if (!in_acid && other.phase >= 4) {
        if (cc >= 1 && cc <= other.cols - 2 && rr >= 1 && rr <= other.rows - 2) {
            if (other.flood_prog[# cc, rr] > 0.55) in_acid = true;
        }
    }

    // Apply damage
    if (in_acid) hp -= 1;
	if (in_acid)
	{
		obj_player.image_blend = c_red;
	}
}
// --- Damage player if touching acid ---
with (obj_enemy) {
    var cc = floor(x / other.CELL);
    var rr = floor(y / other.CELL);
    var in_acid = false;

    // Rising shaft column
    if (x >= other.shaft_c * other.CELL && x < (other.shaft_c + 1) * other.CELL && y >= other.acid_y)
        in_acid = true;

    // Flooded room cells
    if (!in_acid && other.phase >= 4) {
        if (cc >= 1 && cc <= other.cols - 2 && rr >= 1 && rr <= other.rows - 2) {
            if (other.flood_prog[# cc, rr] > 0.55) in_acid = true;
        }
    }

    // Apply damage
   
	if (in_acid)
	{
		instance_destroy();
		effect_create_above(ef_explosion,x,y,1,c_green);
	}
}

