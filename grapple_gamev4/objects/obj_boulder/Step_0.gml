/// Step Event — Basic Patrol + Ground Detection

// --- Gravity ---
vsp += grav;
if (vsp > 8) vsp = 8;

// --- Ground Check ---
on_ground = place_meeting(x, y + 1, obj_wall);





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

