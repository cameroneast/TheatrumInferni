/// @description Insert description here
// You can write your code in this editor

draw_self()
//draw_set_color(c_black)
//draw_text(x,y,currentTurns)
//draw_set_color(c_green)
//draw_text(x,y-16,hp)

if hp < total_hp && object_index != obj_player {
	var lineWidth = 14 * (hp / total_hp)
	draw_line_width_color(x - 7, y+6, (x + 7), y+6, 2, c_black, c_black)
	draw_line_width_color(x - 7, y+6, (x - 7) + lineWidth, y+6, 2, c_red, c_red)
}