/// @function scr_draw_glow(sprite, frame, xx, yy, scale, angle, glow_col, radius, intensity, samples)
/// @desc Draws a 360° colored glow around a sprite.
/// @param sprite     Sprite index
/// @param frame      Image index
/// @param xx, yy     Position
/// @param scale      Sprite scale
/// @param angle      Rotation in degrees
/// @param glow_col   Glow color (e.g. c_red)
/// @param radius     Distance of glow radius (pixels)
/// @param intensity  Alpha of glow copies (0.1–0.5 typical)
/// @param samples    Number of copies around 360° (e.g. 24–48)

function scr_draw_glow(_spr, _frame, _x, _y, _scale, _angle, _col, _radius, _intensity, _samples)
{
    gpu_set_blendenable(true);
    gpu_set_blendmode(bm_add);

    // draw copies around 360°
    for (var i = 0; i < _samples; i++)
    {
        var ang = i * (360 / _samples);
        var nx = _x + lengthdir_x(_radius, ang);
        var ny = _y + lengthdir_y(_radius, ang);
        draw_sprite_ext(_spr, _frame, nx, ny, _scale, _scale, _angle, _col, _intensity);
    }

    // draw the main sprite in the middle
    gpu_set_blendmode(bm_normal);
    draw_sprite_ext(_spr, _frame, _x, _y, _scale, _scale, _angle, c_white, 1);
    gpu_set_blendenable(false);
}

