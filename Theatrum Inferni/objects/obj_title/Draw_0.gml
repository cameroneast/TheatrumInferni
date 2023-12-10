/// @description Insert description here
// You can write your code in this editor

draw_self()
draw_set_color(c_white)
draw_set_font(font_theatrum)
draw_set_halign(fa_middle)
draw_set_valign(fa_top)
draw_set_alpha(abs(sin(current_time / 500)))
draw_text(x,y+30,"Click to start")
draw_set_alpha(1)