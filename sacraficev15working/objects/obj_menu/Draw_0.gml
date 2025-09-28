draw_set_font(Font1);
draw_set_colour(c_black);
if text == 0
{
    draw_text_transformed(x-100,y,"C0SM1C SACR1F1CE",6,9,0);
    draw_text_transformed(x,y+200,"(PRESS SPACE)",4,7,0);
}

if text == 1
{
    draw_text_transformed(x-200,y,"The w0rld 1s 1n danger!!",4,7,0);
    draw_text_transformed(x-200,y+150,"Save 1T!!",4,7,0);
    draw_text_transformed(x-200,y+270,"But sacraf1ces must be made!!",4,7,0);
    draw_text_transformed(x-200,y+390,"(Press Space)",4,7,0);
}

if text == 2
{
    draw_text_transformed(x-200,y,"F1ght B0sses",4,7,0);
    draw_text_transformed(x-200,y+150,"After y0u are d0ne. Sacraf1ce spells",4,7,0);
    draw_text_transformed(x-200,y+270,"by sh00t1ng them at pedasta1s.",4,7,0);
    draw_text_transformed(x-200,y+390,"(Press Space)",4,7,0);
}

if text == 3
{
    draw_text_transformed(x-200,y,"F1re Spe11: R1ght c1ick",4,7,0);
    draw_text_transformed(x-200,y+150,"Water Spe11: Space",4,7,0);
    draw_text_transformed(x-200,y+270,"Pea Sh00ter: Left c1ick",4,7,0);
    draw_text_transformed(x-200,y+390,"L1ghtn1ng: F",4,7,0);
    draw_text_transformed(x-200,y+520,"(Press Space)",4,7,0);
}

if text == 4
{
    draw_text_transformed(x-200,y,"G0",4,7,0);
    draw_text_transformed(x-200,y+200,"(Press Space)",4,7,0);
}

if text >= 5
{
	audio_stop_all();
	room_goto(Room1);
}