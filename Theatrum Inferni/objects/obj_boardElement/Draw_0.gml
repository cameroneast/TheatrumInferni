/// @description Insert description here
// You can write your code in this editor

draw_self()
if object_index != obj_meleeSlash { //rewrite-demo only
	draw_set_color(c_black)
	draw_text(x,y,currentTurns)
	draw_set_color(c_green)
	draw_text(x,y-16,hp)
}