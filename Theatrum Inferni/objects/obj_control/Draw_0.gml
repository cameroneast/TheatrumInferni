/// @description Insert description here
// You can write your code in this editor




//try{
//	mp_grid_draw(global.grid)
//}

//try {
//	draw_set_color(c_white)
//	draw_path(global.path,0,0,true)
//}

//draw_set_color(c_white)
//draw_rectangle(mouse_x,mouse_y,mouse_x+4,mouse_y+4,false)

//show_debug_message(object_get_name(elementQueue[queuePointer].object_index))
//show_debug_message(elementQueue[queuePointer].currentTurns)

if show_end_text {
	draw_set_font(font_theatrum_big)
	draw_set_color(c_white)
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	if game_won {
		if global.circle == 1
			draw_text(room_width/2,room_height/2,"Hell\nconquered.")
		else
			draw_text(room_width/2,room_height/2,"Circle\nconquered.")
	}
	else
		draw_text(room_width/2,room_height/2,"You're\ndoomed.")
}