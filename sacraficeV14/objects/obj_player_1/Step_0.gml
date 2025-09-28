// Move up
if keyboard_check(ord("W"))
{
    if !place_meeting(x, y - move_speed, obj_wall)
    {
        y -= move_speed;
		sprite_index = spr_player_back
    }
}

// Move down
if keyboard_check(ord("S"))
{
    if !place_meeting(x, y + move_speed, obj_wall)
    {
        y += move_speed;
		sprite_index = spr_player_front
    }
}

// Move left
if keyboard_check(ord("A"))
{
    if !place_meeting(x - move_speed, y, obj_wall)
    {
        x -= move_speed;
		sprite_index = spr_player_side_left
    }
}

// Move right
if keyboard_check(ord("D"))
{
    if !place_meeting(x + move_speed, y, obj_wall)
    {
        x += move_speed;
		sprite_index = spr_player_side_right
    }
}
//image_angle = point_direction(x, y, mouse_x, mouse_y) + 90;
if hp <= 0
{
	room_restart();
	room_goto(rm_gameover);
	
}
if invincible == true
{
	image_blend = c_red;

}
else
{
	image_blend = c_white;
}
