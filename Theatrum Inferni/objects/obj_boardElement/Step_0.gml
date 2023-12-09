/// @description Insert description here
// You can write your code in this editor

if active && !midMove && !obj_control.game_froze {
		
	if user_input set_tiles()
	
	nextAction = get_next_action()
	
	if nextAction != pointer_null {
		if nextAction.moveCost > currentTurns || nextAction.manaCost > obj_control.mana
			nextAction = pointer_null
	}
	
	if nextAction != pointer_null {
		
		midMove = true
		
		currentTurns -= nextAction.moveCost
		obj_control.mana -= nextAction.manaCost
		
		if user_input reset_tiles()
		
		if !preStarted {
			preStarted = true
			pre_start_toward_goal()
		}
		
		start_toward_goal()
	}
}

if active && midMove && !obj_control.game_froze {
	
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