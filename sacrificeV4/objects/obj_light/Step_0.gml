// Predict next position
var nx = x + hspeed;
var ny = y + vspeed;

// --- Horizontal collision ---
if (place_meeting(nx, y, obj_wall)) {
    // Slide up to the wall edge so we don't get stuck inside
    while (!place_meeting(x + sign(hspeed), y, obj_wall)) {
        x += sign(hspeed);
    }
    // Reflect horizontal component
    hspeed = -hspeed;
}

// --- Vertical collision ---
if (place_meeting(x, ny, obj_wall)) {
    // Slide up to the wall edge so we don't get stuck inside
    while (!place_meeting(x, y + sign(vspeed), obj_wall)) {
        y += sign(vspeed);
    }
    // Reflect vertical component
    vspeed = -vspeed;
}

// Move
x += hspeed;
y += vspeed;

// Face direction of movement
if (hspeed != 0 || vspeed != 0) {
    image_angle = point_direction(0, 0, hspeed, vspeed);
}
