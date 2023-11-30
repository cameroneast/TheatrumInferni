/// @description Insert description here
// You can write your code in this editor

draw_set_halign(fa_center)

if state == 1 {
	draw_set_color(c_green)
	draw_text(x,y,"You won")
} else if state == 2 {
	draw_set_color(c_red)
	draw_text(x,y,"You lost")
}

draw_set_color(c_white)
draw_text(x,y-160,"Theatrum Inferni")