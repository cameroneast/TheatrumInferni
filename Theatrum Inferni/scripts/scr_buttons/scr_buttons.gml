// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function change_input_selection(sel){
	
	obj_control.selection = sel
	reset_tiles()
	with get_current_active() set_tiles()

}

function is_interactable() {
	var current_active = get_current_active()
	if object_index == obj_card && current_active.object_index != obj_player return false
	return current_active.active && !current_active.midMove && !obj_control.game_froze
}