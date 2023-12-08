/// @description Insert description here
// You can write your code in this editor

if active && !midMove {
		
	if user_input set_tiles()
	
	nextAction = get_next_action()
	
	if nextAction != pointer_null {
		
		midMove = true
		currentTurns--
		
		if user_input reset_tiles()
		
		if !preStarted {
			preStarted = true
			pre_start_toward_goal()
		}
		
		start_toward_goal()
	}
}

if active && midMove {
	
	increment_toward_goal()
	
	if check_if_goal_reached() {
		
		//do damage intersection here
		do_damage_intersection()
		
		if currentTurns > 0 {
			midMove = false
		} else {
			
			active = false
			
			preStarted = false
			
			if barrier_after
				my_barrier.barrier_count--
				
			//if object_index == obj_push instance_destroy()
			
			if immediate {
				instance_destroy()
			} else if !any_active() && !barrier_after {
				with obj_control start_next()
			}
		}
	}
}