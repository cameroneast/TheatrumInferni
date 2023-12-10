/// @description Insert description here
// You can write your code in this editor

shader_set(sha_fade)
shader_set_uniform_f(darkness,darkness_val)
if fade_in
	darkness_val -= .025
else
	darkness_val += .025
draw_self()
shader_reset()

if fade_in && darkness_val <= -.4 {
	with obj_control unfreeze_start_game()
	instance_destroy()
}
else if !fade_in && darkness_val >= 1.4 {
	
	if room == room_title {
		room_goto_next()
	} else {
	
		if obj_control.game_won {
			global.circle--
			if global.circle <= 0
				room_goto(room_text)
			else
				room_restart()
		}
		else
			room_goto(room_title)
		
	}
}