// Move up
if keyboard_check(ord("W"))
{
    if !place_meeting(x, y - move_speed, obj_wall)
    {
        y -= move_speed;
    }
}

// Move down
if keyboard_check(ord("S"))
{
    if !place_meeting(x, y + move_speed, obj_wall)
    {
        y += move_speed;
    }
}

// Move left
if keyboard_check(ord("A"))
{
    if !place_meeting(x - move_speed, y, obj_wall)
    {
        x -= move_speed;
    }
}

// Move right
if keyboard_check(ord("D"))
{
    if !place_meeting(x + move_speed, y, obj_wall)
    {
        x += move_speed;
    }
}
image_angle = point_direction(x, y, mouse_x, mouse_y) + 90;
