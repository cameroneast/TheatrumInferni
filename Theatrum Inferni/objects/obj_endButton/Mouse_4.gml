/// @description Insert description here
// You can write your code in this editor

var current_active = get_current_active()
if current_active.user_input {
	current_active.active = false
	current_active.midMove = false
	reset_tiles()
	with obj_control start_next()
}