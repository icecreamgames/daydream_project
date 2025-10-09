/// Step Event — Basic Patrol + Ground Detection

// --- Gravity ---
vsp += grav;
if (vsp > 8) vsp = 8;

// --- Ground Check ---
on_ground = place_meeting(x, y + 1, obj_wall);

// --- Patrol Movement ---
hsp = walk_spd * dir;

// --- Turn Around Logic ---
// If about to hit a wall OR about to walk off an edge, flip direction
var front_x = x + (dir * 40); // check ahead
var front_y = y + 1;

// 1) If there’s a wall in front
if (place_meeting(front_x, y, obj_wall)) {
    dir *= -1;
	image_xscale *= -1;
}

// 2) If no floor ahead (avoid falling off)
else if (!place_meeting(front_x, front_y + 4, obj_wall)) {
    dir *= -1;
	

}

// --- Apply Horizontal Movement ---
if (!place_meeting(x + hsp, y, obj_wall)) {
    x += hsp;
} else {
    // hit wall -> turn around
    dir *= -1;
	image_xscale *= -1;
}

// --- Apply Vertical Movement ---
if (!place_meeting(x, y + vsp, obj_wall)) {
    y += vsp;
} else {
    // stop falling if on ground
    while (!place_meeting(x, y + sign(vsp), obj_wall)) {
        y += sign(vsp);
    }
    vsp = 0;
}

// --- Optional: Tiny jump if stuck (uncomment if enemies get trapped)
// if (on_ground && place_meeting(x + dir * 20, y, obj_wall)) {
 //    vsp = -1000;
// }

image_xscale = dir;