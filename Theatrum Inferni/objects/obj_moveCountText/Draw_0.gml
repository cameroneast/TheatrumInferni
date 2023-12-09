/// @description Insert description here
// You can write your code in this editor

var turnObject = obj_control.elementQueue[obj_control.queuePointer]
if turnObject.user_input {
	draw_set_font(font_theatrum)
	draw_set_halign(fa_left)
	draw_text(x,y,string(turnObject.currentTurns) + "/" + string(turnObject.totalTurns))
}