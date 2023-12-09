/// @description Insert description here
// You can write your code in this editor

draw_self()

if instance_exists(obj_player) {
	var lineHeight = 114 * (obj_player.hp / obj_player.total_hp)

	draw_line_width_color(x-13,y+12,x-13,y+lineHeight+12,4,c_red,c_red)
}

var lineHeight = 105 * (obj_control.mana / obj_control.total_mana)

draw_line_width_color(x-6,y+22,x-6,y+lineHeight+22,4,c_blue,c_purple)
