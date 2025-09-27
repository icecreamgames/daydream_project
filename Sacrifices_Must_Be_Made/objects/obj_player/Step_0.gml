// Move up
if keyboard_check(vk_up)
{
    if !place_meeting(x, y - move_speed, obj_wall)
    {
        y -= move_speed;
    }
}

// Move down
if keyboard_check(vk_down)
{
    if !place_meeting(x, y + move_speed, obj_wall)
    {
        y += move_speed;
    }
}

// Move left
if keyboard_check(vk_left)
{
    if !place_meeting(x - move_speed, y, obj_wall)
    {
        x -= move_speed;
    }
}

// Move right
if keyboard_check(vk_right)
{
    if !place_meeting(x + move_speed, y, obj_wall)
    {
        x += move_speed;
    }
}
image_angle = point_direction(x, y, mouse_x, mouse_y) + 90;

