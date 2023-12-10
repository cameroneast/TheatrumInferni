// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
#macro BOARD_DISTANCE_FROM_CORNER_X 96
#macro BOARD_DISTANCE_FROM_CORNER_Y 8

function getTileCoords(_x, _y) {
	return [(_x - BOARD_DISTANCE_FROM_CORNER_X) / 16, (_y - BOARD_DISTANCE_FROM_CORNER_Y) / 16]
}
function getWorldCoords(_x, _y) {
	return [(_x * 16) + BOARD_DISTANCE_FROM_CORNER_X, (_y * 16) + BOARD_DISTANCE_FROM_CORNER_Y]
}

enum ActionType {
	move,
	spawn, //unused
	immediate,
	animate,
	moveOther,
	incrementClock,
	transform,
	earlyTransform,
	melee2
}
enum Alignment {
	good,
	bad,
	neutral
}
//enum Direction {
//	left,
//	right,
//	up,
//	down
//}

//function getDirection(startX, startY, endX, endY) {
//	if endX > startX return Direction.right
//	if endX < startX return Direction.left
//	if endY > startY return Direction.up
//	if endY < startY return Direction.down
//	return pointer_null
//}

function step_toward_nearest_element(align) {
	var tryAvoid = true
	var nearest = get_nearest_element(align, tryAvoid)
	if nearest == pointer_null
		tryAvoid = false
	nearest = get_nearest_element(align, tryAvoid)
	if nearest == pointer_null
		nearest = self
	return step_toward_element(nearest, tryAvoid)
}

function step_toward_element(element, tryAvoid) { //extend to step toward space
	//global.grid = mp_grid_create(BOARD_DISTANCE_FROM_CORNER,BOARD_DISTANCE_FROM_CORNER,12,8,16,16)
	//with obj_boardElement {
	//	if id != other.id && !id.passable && id.ground == ground && id != element //do ground here
	//		mp_grid_add_instances(global.grid, id, true)
	//}
	//var goalX, goalY
	//global.path = path_add()
	//if mp_grid_path(global.grid, global.path, x, y, element.x, element.y, false) {
	//	path_start(global.path, 0, path_action_stop, true)
	//	path_part = 16 / path_get_length(global.path)
	//	goalX = path_get_x(global.path, path_part)
	//	goalY = path_get_y(global.path, path_part)
	//	path_end()
	//}
	//return [goalX, goalY]
	
	return step_toward_space_avoid(element.x, element.y, tryAvoid)
}

function get_nearest_element(align, tryAvoid) {
	var nearestElement = pointer_null
	var nearestDistance = pointer_null
	
	for (var i = 0; i < instance_number(obj_boardElement); ++i;)
	{
	    var element = instance_find(obj_boardElement,i);
		
		if element.alignment == align {
			
			make_path(element.x, element.y, tryAvoid)
			if global.path_working {
				if nearestElement == pointer_null || path_get_length(global.path) < nearestDistance {
					nearestElement = element
					nearestDistance = path_get_length(global.path)
				}
			}
			
		}
	}
	
	return nearestElement;
}

//function step_toward_space(_x, _y) {
//	make_path(_x, _y, true)
//	if global.path_working
//		step_toward_space_avoid(_x, _y, true)
//	else
//		step_toward_space_avoid(_x, _y, false)
//}

function step_toward_space_avoid(_x, _y, tryAvoid) { //extend to step toward space
	
	make_path(_x, _y, tryAvoid)
	
	var goalX, goalY
	if global.path_working {
		path_start(global.path, 0, path_action_stop, true)
		path_part = 16 / path_get_length(global.path)
		goalX = path_get_x(global.path, path_part)
		goalY = path_get_y(global.path, path_part)
		path_end()
	} else {
		goalX = x
		goalY = y
	}
	return [goalX, goalY]
}

function make_path(_x, _y, tryAvoid) {
	
	var overallList = ds_list_create()
	for (var i = 0; i < instance_number(obj_boardElement); ++i;)
	{
	    ds_list_add(overallList, instance_find(obj_boardElement,i))
	}
	
	var instancesAtGoal = ds_list_create()
	instance_position_list(_x,_y,obj_boardElement,instancesAtGoal,false)
	
	for (var i = ds_list_size(overallList)-1; i >= 0; i--) {
		if (ds_list_find_value(overallList,i).passable && (!ds_list_find_value(overallList,i).avoid || !tryAvoid)) || ds_list_find_value(overallList,i).ground != ground || ds_list_find_index(instancesAtGoal,ds_list_find_value(overallList,i)) != -1 || id == ds_list_find_value(overallList,i).id //do ground here
			ds_list_delete(overallList,i)
	}
	
	var instancesAtStart = ds_list_create()
	instance_position_list(x,y,obj_boardElement,instancesAtStart,false)
	for (var i = ds_list_size(instancesAtStart)-1; i >= 0; i--) {
		if ds_list_find_index(overallList,ds_list_find_value(instancesAtStart,i)) != -1 {
			var indexToDelete = ds_list_find_index(overallList,ds_list_find_value(instancesAtStart,i))
			ds_list_delete(overallList,indexToDelete)
		}
	}
	
	global.grid = mp_grid_create(BOARD_DISTANCE_FROM_CORNER_X,BOARD_DISTANCE_FROM_CORNER_Y,12,8,16,16)
	
	//with obj_boardElement {
	//	if id != other.id && ds_list_find_index(overallList,id) == -1
	//		mp_grid_add_instances(global.grid, id, true)
	//}
	
	for (var i = 0; i < ds_list_size(overallList); i++) {
		//if id != ds_list_find_value(overallList,i).id
			mp_grid_add_instances(global.grid, ds_list_find_value(overallList,i),true)
	}

	global.path = path_add()
	global.path_working = mp_grid_path(global.grid, global.path, x, y, _x, _y, false)
}

function enemy_adjacent(aligned) {
	var ls = ds_list_create()
	instance_position_list(x+16,y,obj_boardElement,ls,false)
	for (var i = 0; i < ds_list_size(ls); i++) {
		if ds_list_find_value(ls,i).alignment == aligned
			return true
	}
	var ls = ds_list_create()
	instance_position_list(x-16,y,obj_boardElement,ls,false)
	for (var i = 0; i < ds_list_size(ls); i++) {
		if ds_list_find_value(ls,i).alignment == aligned
			return true
	}
	var ls = ds_list_create()
	instance_position_list(x,y+16,obj_boardElement,ls,false)
	for (var i = 0; i < ds_list_size(ls); i++) {
		if ds_list_find_value(ls,i).alignment == aligned
			return true
	}
	var ls = ds_list_create()
	instance_position_list(x,y-16,obj_boardElement,ls,false)
	for (var i = 0; i < ds_list_size(ls); i++) {
		if ds_list_find_value(ls,i).alignment == aligned
			return true
	}
	return false
}

function get_next_action(){
	
	//see obj_tile
	if user_input {
		var oldUserInputBuffer = obj_control.userInputBuffer
		obj_control.userInputBuffer = pointer_null
		return oldUserInputBuffer
	}
	
	switch(object_index) {
		case obj_tortured:
		
			if enemy_adjacent(Alignment.good) {
				return {
					type: ActionType.immediate,
					//parms: [x, y + 16]
					parms: [x,y, obj_meleeSlash],
					moveCost: 1,
					manaCost: 0
				}
			}
			
			var go = [x,y]
			switch(irandom_range(0,3)) {
				case 0: if position_meeting(x + 16, y, obj_tile) go = [x + 16, y] break
				case 1: if position_meeting(x - 16, y, obj_tile) go = [x - 16, y] break
				case 2: if position_meeting(x, y + 16, obj_tile) go = [x, y + 16] break
				case 3: if position_meeting(x, y - 16, obj_tile) go = [x, y - 16] break
			}
			return {
				type: ActionType.move,
				//parms: [x, y + 16]
				parms: [go[0], go[1]],
				moveCost: 1,
				manaCost: 0
			}
		
		case obj_eyebat:
		case obj_enemy1:
		case obj_lostSoul:
		case obj_angel:
		
		var al
		if object_index == obj_angel
			al = Alignment.bad
		else
			al = Alignment.good
			
			if object_index != obj_lostSoul {
				
				if enemy_adjacent(al) {
					return {
						type: ActionType.immediate,
						//parms: [x, y + 16]
						parms: [x,y, obj_meleeSlash],
						moveCost: 1,
						manaCost: 0
					}
				}
				
			}	
			
			//var goal = step_toward_element(inst_8BA159E)
				var goal = step_toward_nearest_element(al)

			return {
				type: ActionType.move,
				//parms: [x, y + 16]
				parms: [goal[0], goal[1]],
				moveCost: 1,
				manaCost: 0
			}
			
		case obj_meleeSlash:
		case obj_meleeSlash2:
			
			return {
				type: ActionType.animate,
				parms: [],
				moveCost: 1,
				manaCost: 0
			}
			
		case obj_push:
			return {
				type: ActionType.moveOther,
				parms: [],
				moveCost: 1,
				manaCost: 0
			}
		
		case obj_incrementClock:
			return {
				type: ActionType.incrementClock,
				parms: [],
				moveCost: 1,
				manaCost: 0
			}
			
		case obj_transform:
			return {
				type: ActionType.transform,
				parms: [],
				moveCost: 1,
				manaCost: 0
			}
			
	}
}

function spawn_board_element(_x,_y,kind, ind) {
	//if obj_control.queuePointer >= 0
	//	obj_control.queuePointer--
	var newElement = instance_create_layer(_x,_y,"Floor",kind)
	array_insert(obj_control.elementQueue, ind, newElement)
	return newElement
}

function pre_start_toward_goal() {
	switch(nextAction.type) {
		case ActionType.moveOther:
			elements_to_push = ds_list_create()
			instance_position_list(x,y,obj_boardElement,elements_to_push,false)
			break
	}
}

function can_pass(elm1, elm2) {
	if elm1.passable || elm2.passable
		return true
	return elm1.ground != elm2.ground
}

function start_toward_goal() {
	switch(nextAction.type) {
		case ActionType.spawn:
			var ind = array_get_index(obj_control.elementQueue, id) + 1
			spawn_board_element(nextAction.parms[0],nextAction.parms[1],obj_angel,ind)
			obj_control.queuePointer--
			with obj_control start_next()
			break
		case ActionType.move:
			start = [x,y] //used to see if moved at end
			break
		case ActionType.moveOther:
			//first delete any objects in list that are dead or not pushable
			
			for (var i = ds_list_size(elements_to_push)-1; i >= 0; i--) {
				if !instance_exists(ds_list_find_value(elements_to_push,i)) || !ds_list_find_value(elements_to_push,i).pushable
					ds_list_delete(elements_to_push,i)
			}
			
			for (var i = 0; i < ds_list_size(elements_to_push); i++) {
				var a_elm = ds_list_find_value(elements_to_push,i)
				a_elm.push_to = [a_elm.x + push_direction[0], a_elm.y + push_direction[1]]
				a_elm.push_start = [a_elm.x,a_elm.y]
					
				var foundSolid = false
				var elements_at_goal = ds_list_create()
				instance_position_list(a_elm.push_to[0],a_elm.push_to[1],obj_boardElement,elements_at_goal,false)
					
				for (var j = 0; j < ds_list_size(elements_at_goal); j++) {
					if !can_pass(ds_list_find_value(elements_to_push,i), ds_list_find_value(elements_at_goal,j)) {
						foundSolid = true
						break
					}
				}
				
				if !position_meeting(a_elm.push_to[0], a_elm.push_to[1],obj_tile)
					foundSolid = true
				
				if foundSolid
					a_elm.push_to = a_elm.push_start
			}
				
			//push_to = [x + push_direction[0], y + push_direction[1]]
			break
		case ActionType.animate:
			image_index = 0
			image_speed = 1
			break
		case ActionType.immediate:
			active = false
			midMove = false
			
			var ind = array_get_index(obj_control.elementQueue, id)
			
			obj_control.queuePointer--
			
			//push
			var newBarrier = spawn_board_element(0,0,obj_barrier,ind)
			newBarrier.barrier_count = 4
			
			var iter = [[0,16],[0,-16],[16,0],[-16,0]]
			for (var i = 0; i < 4; i++) {
				
				var newObject = spawn_board_element(x+iter[i][0],y+iter[i][1],obj_push,ind)
				newObject.my_barrier = newBarrier
				newObject.push_direction = [iter[i][0], iter[i][1]]
			}
			//end push
			
			var newBarrier = spawn_board_element(0,0,obj_barrier,ind)
			newBarrier.barrier_count = 4

			var iter = [[0,16],[0,-16],[16,0],[-16,0]]
			for (var i = 0; i < 4; i++) {
				
				var newObject = spawn_board_element(x+iter[i][0],y+iter[i][1],obj_meleeSlash,ind)
				newObject.my_barrier = newBarrier
			}
			
			//obj_control.queuePointer--
			//newObject = instance_create_layer(nextAction.parms[0],nextAction.parms[1],"BoardElements",nextAction.parms[2])
			//array_insert(obj_control.elementQueue, ind, newObject)
			//newObject.my_barrier = newBarrier
				
			with obj_control start_next()
			break
			
		case ActionType.melee2:
			active = false
			midMove = false
			var ind = array_get_index(obj_control.elementQueue, id)
			
			obj_control.queuePointer--
			spawn_board_element(nextAction.parms[0],nextAction.parms[1],obj_meleeSlash2,ind)
			with obj_control start_next()
			break
			
		case ActionType.incrementClock:
			if !obj_clock.firstTurn {
				obj_clock.werewolfTimer = (obj_clock.werewolfTimer + 1) % 8
				if obj_clock.werewolfTimer == 0 || obj_clock.werewolfTimer == 4 {
					var ind = array_get_index(obj_control.elementQueue, id) + 1
					var trans = spawn_board_element(0,0,obj_transform,ind)
					trans.transitionType = -1
					trans.temporary = false
					with obj_control start_next()
				}
			}
			else
				obj_clock.firstTurn = false
			break
			
		case ActionType.transform:
			if transitionType == -1
				isHumanTemp = obj_clock.werewolfTimer == 0
			else
				isHumanTemp = transitionType == 0
			if !isHumanTemp {
				var num_array = [0,1,2,3,4,5,6,7,8,9,10]
				num_array = array_shuffle(num_array)
				array_delete(num_array,5,6)
				obj_control.card_array = array_create(0)
				for (var i = 0; i < 5; i++) {
					var newCard = instance_create_layer(107,184,"Control",obj_card)
					newCard.passedThreshold = false
					newCard.myNum = num_array[i]
					array_push(obj_control.card_array,newCard)
				}
			}
			if !temporary {
				obj_player.isHuman = isHumanTemp
				if obj_player.isHuman	
					obj_control.mana = obj_control.total_mana
			}
			done = false
			break
			
		case ActionType.earlyTransform:
			if nextAction.parms == true && isHuman {
				obj_clock.werewolfTimer = 0
			} else if nextAction.parms == false && isHuman {
				
				obj_clock.werewolfTimer = 4

				var ind = array_get_index(obj_control.elementQueue, id) + 1
					
				var trans = spawn_board_element(0,0,obj_transform,ind)
				trans.transitionType = 1
				trans.temporary = false
					
				with obj_control start_next()
			} else if nextAction.parms == true && !isHuman {
				obj_clock.werewolfTimer = 0

				var ind = array_get_index(obj_control.elementQueue, id) + 1
					
				var trans = spawn_board_element(0,0,obj_transform,ind)
				trans.transitionType = 0
				trans.temporary = false
				
				with obj_control start_next()
			} else {
				active = false
				midMove = false
				
				obj_clock.werewolfTimer = 4
				
				obj_control.queuePointer -= 2

				var ind = array_get_index(obj_control.elementQueue, id) - 1//still need to complete this
				
				var trans = spawn_board_element(0,0,obj_transform,ind)
				trans.transitionType = 1
				trans.temporary = false
				
				var trans2 = spawn_board_element(0,0,obj_transform,ind)
				trans2.transitionType = 0
				trans2.temporary = true
				
				with obj_control start_next()
				
			}
	}
}
function increment_toward_goal() {
	switch(nextAction.type) {
		case ActionType.move:
			//if x < nextAction.parms[0] x++ else if x > nextAction.parms[0] x--
			//if y < nextAction.parms[1] y++ else if y > nextAction.parms[1] y--
			
			if point_distance(x,y,nextAction.parms[0],nextAction.parms[1]) < 1 {
				x=nextAction.parms[0]
				y=nextAction.parms[1]
				speed = 0
			} else
				move_towards_point(nextAction.parms[0],nextAction.parms[1],1)
			
			break
		case ActionType.moveOther:
		
			for (var i = 0; i < ds_list_size(elements_to_push); i++) {
				var current_element = ds_list_find_value(elements_to_push,i) //CONTINUE HERE
			
				if point_distance(current_element.x,current_element.y,current_element.push_to[0],current_element.push_to[1]) < 1 {
					current_element.x=current_element.push_to[0]
					current_element.y=current_element.push_to[1]
					current_element.speed = 0
				} else
					with current_element move_towards_point(push_to[0],push_to[1],1)
			}
		
			break
		
		case ActionType.animate:
			//image_index++
			break
		case ActionType.transform:
			if !isHumanTemp {
				for (var i = 0; i < 5; i++) {
					if i == 0 || obj_control.card_array[i - 1].passedThreshold {
						var currCard = obj_control.card_array[i]
						var Xgoal = (((10 - i) + 1) * 34) - 97 //copied below to check if done
						
						if point_distance(currCard.x,currCard.y,Xgoal,currCard.y) < 2 {
							currCard.x = Xgoal
							currCard.speed = 0
						} else
							with currCard move_towards_point(Xgoal,currCard.y,2)
							
						currCard.image_xscale = (min((currCard.x - 107) /34,1.)*2)-1
						
						if currCard.x >= 124 {
							currCard.sprite_index = spr_cards
							currCard.image_index = currCard.myNum
						}
						
						if currCard.x > 141
							currCard.passedThreshold = true
					} else
						continue
				}
				done = true
				for (var i = 0; i < 5; i++) {
					var Xgoal = (((10 - i) + 1) * 34) - 97 //copied from above
					if obj_control.card_array[i].x != Xgoal {
						done = false
						break
					}
				}
			} else {
				for (var i = 0; i < array_length(obj_control.card_array); i++) {
					var currCard = obj_control.card_array[i]
					var Xgoal = 107
					if instance_exists(currCard) {
						if point_distance(currCard.x,currCard.y,Xgoal,currCard.y) < 2 {
							currCard.x = Xgoal
							currCard.speed = 0
						} else
							with currCard move_towards_point(Xgoal,currCard.y,2)
						currCard.image_xscale = (min((currCard.x - 107) /34,1.)*2)-1
						if currCard.x <= 124 {
							currCard.sprite_index = spr_cardBack
						}
					}
				}
				done = true
				for (var i = 0; i < array_length(obj_control.card_array); i++) {
					var currCard = obj_control.card_array[i]
					if instance_exists(currCard) {
						if currCard.x != 107 {
							done = false
							break
						}
					}
				}
				if done {
					for (var i = 0; i < array_length(obj_control.card_array); i++)
						instance_destroy(obj_control.card_array[i])
				}
			}
	}
}
function check_if_goal_reached() {
	switch(nextAction.type) {
		case ActionType.move:
			return x == nextAction.parms[0] && y == nextAction.parms[1]
		case ActionType.moveOther:
			//if ds_list_size(elements_to_push) == 0 return true
			for (var i = 0; i < ds_list_size(elements_to_push); i++) {
				var el = ds_list_find_value(elements_to_push,i)
				if el.x != el.push_to[0] || el.y != el.push_to[1]
					return false
			}
			return true
			break
		case ActionType.animate:
			return image_index >= image_number
		case ActionType.incrementClock:
			return true
		case ActionType.transform:
			return done
		case ActionType.earlyTransform:
			return true
		case ActionType.spawn:
			return true
	}
}

function do_individual_damage_intersection(elm1, elm2) {
	switch(elm1.object_index) {
		case obj_meleeSlash:
		case obj_meleeSlash2:
			subtract_health(elm2,1)
			break
		case obj_lava:
			if elm2.ground
				subtract_health(elm2,1)
			break
		case obj_leaf:
			if elm2.currentTurns > 0 && elm2.ground
				elm2.currentTurns--
			break
		case obj_lostSoul:
			subtract_health(elm2,elm1.hp)
			subtract_health(elm1,elm1.hp)
	}
}

//this needs work. goes through this colliding with all others. then all others with this
//handles damage, move speed, and any other status effect
function do_damage_intersection() {
	
	//for push, need to call intersection for all objects pushed
	
	//use helper functions for each indivudal collision
	
	if object_index == obj_push {
		for (var i = 0; i < ds_list_size(elements_to_push); i++) {
			var a_elm = ds_list_find_value(elements_to_push,i)
			if a_elm.x != a_elm.push_start[0] || a_elm.y != a_elm.push_start[1] {
				var landedOn = ds_list_create()
				instance_position_list(a_elm.x,a_elm.y,obj_boardElement,landedOn,false)
				ds_list_delete(landedOn,ds_list_find_index(landedOn,a_elm.id))
				for (var j = 0; j < ds_list_size(landedOn); j++) {
					var other_elm = ds_list_find_value(landedOn,j)
					if instance_exists(a_elm) && instance_exists(other_elm)
						do_individual_damage_intersection(a_elm,other_elm)
					if instance_exists(a_elm) && instance_exists(other_elm)
						do_individual_damage_intersection(other_elm,a_elm)
				}
			}
		}
	} else if nextAction.type == ActionType.move {
		if x != start[0] || y != start[1] {
			var landedOn = ds_list_create()
			instance_position_list(x, y, obj_boardElement, landedOn, false)
			ds_list_delete(landedOn, ds_list_find_index(landedOn, id))
			
			for (var j = 0; j < ds_list_size(landedOn); j++) {
				var other_elm = ds_list_find_value(landedOn,j)
				if instance_exists(id) && instance_exists(other_elm)
					do_individual_damage_intersection(id,other_elm)
				if instance_exists(id) && instance_exists(other_elm)
					do_individual_damage_intersection(other_elm,id)
			}
		}
	} else {
		
		var landedOn = ds_list_create()
		var currentOn = ds_list_create()
		
		instance_position_list(x, y, obj_boardElement, landedOn, false)
		ds_list_delete(landedOn, ds_list_find_index(landedOn, id))
		ds_list_add(currentOn,id)
		
		for (var i = 0; i < ds_list_size(landedOn); i++) {
			for (var j = 0; j < ds_list_size(currentOn); j++) {
				var elm1 = ds_list_find_value(currentOn,j)
				var elm2 = ds_list_find_value(landedOn,i)
			
				if instance_exists(elm1) && instance_exists(elm2) {
					do_individual_damage_intersection(elm1,elm2)
				}
				if instance_exists(elm1) && instance_exists(elm2) {
					do_individual_damage_intersection(elm2,elm1)
				}
			
			}
		}
	
	}
	
	//old below
	
	//var landedOn = ds_list_create()
	//var currentOn = ds_list_create()
	
	//if object_index == obj_push {
		
	//	if ds_list_size(elements_to_push) > 0 {
	//		var a_elm = ds_list_find_value(elements_to_push,0)
	//		instance_position_list(a_elm.x, a_elm.y, obj_boardElement, landedOn, false)
	//		currentOn = elements_to_push
	//		for (var i = ds_list_size(landedOn)-1; i >= 0; i--) {
	//			if ds_list_find_index(currentOn, ds_list_find_value(landedOn,i)) != -1
	//				ds_list_delete(landedOn,i)
	//		}
	//	}
	//} else {
		//instance_position_list(x, y, obj_boardElement, landedOn, false)
		//ds_list_delete(landedOn, ds_list_find_index(landedOn, id))
		//ds_list_add(currentOn,id)
	//}
	
	//for (var i = 0; i < ds_list_size(landedOn); i++) {
	//	for (var j = 0; j < ds_list_size(currentOn); j++) {
	//		var elm1 = ds_list_find_value(currentOn,j)
	//		var elm2 = ds_list_find_value(landedOn,i)
			
	//		show_debug_message("did it")
			
	//		if instance_exists(elm1) && instance_exists(elm2) {
	//			do_individual_damage_intersection(elm1,elm2)
	//		}
	//		if instance_exists(elm1) && instance_exists(elm2) {
	//			do_individual_damage_intersection(elm2,elm1)
	//		}
			
	//	}
	//}
	
}
function subtract_health(elm, amnt) {
	if !elm.invincible {
		elm.hp -= amnt
		if elm.hp <= 0 {
			if elm.object_index == obj_player {
				obj_control.game_froze = true
				obj_control.game_won = false
				
				obj_control.alarm[1] = 50
				obj_control.alarm[0] = 200
				
				destroy_all_immediates()
				
				reset_tiles()
				
				instance_destroy(elm)
				
			} else {
				instance_destroy(elm)
				
				if are_all_enemies_dead() {
					obj_control.game_froze = true
					obj_control.game_won = true
				
					obj_control.alarm[1] = 50
					obj_control.alarm[0] = 200
				
					destroy_all_immediates()
					
					reset_tiles()
				}
			}
			//instance_destroy(elm)
		}
	}
}
function are_all_enemies_dead() { //actually checks if 1 is still alive
	var count = 0
	with obj_boardElement {
		if enemy return false
	}
	return true
}
function destroy_all_immediates() {
	with obj_boardElement {
		if immediate
			instance_destroy()
	}
}

function make_death() {
	var death = instance_create_layer(x,y,sorting_layer,obj_death)
	death.sprite_index = sprite_index
	death.image_index = image_index
	death.image_xscale = image_xscale
	visible = false
}

function set_tiles() {
	
	if get_current_active().user_input {
	
		var highlightTiles = array_create(0)
		var myTile = getTileCoords(x,y)
	
		switch (obj_control.selection) {
			case InputSelection.move:
				array_push(highlightTiles, getWorldCoords(myTile[0] + 1, myTile[1]))
				array_push(highlightTiles, getWorldCoords(myTile[0] - 1, myTile[1]))
				array_push(highlightTiles, getWorldCoords(myTile[0], myTile[1] + 1))
				array_push(highlightTiles, getWorldCoords(myTile[0], myTile[1] - 1))
			
				for (var i = array_length(highlightTiles)-1; i >= 0; i--) {
					var list = ds_list_create()
					var instances = instance_position_list(highlightTiles[i][0], highlightTiles[i][1], obj_boardElement, list, false)
					for (var j = ds_list_size(list)-1; j >= 0; j--) {
						if !passable && !ds_list_find_value(list, j).passable && (ds_list_find_value(list, j).ground == ground) { //do ground here
							array_delete(highlightTiles, i, 1)
							break
						}
					}
				}
				break
				
			case InputSelection.meleeSword:
				array_push(highlightTiles, getWorldCoords(myTile[0] + 1, myTile[1]))
				array_push(highlightTiles, getWorldCoords(myTile[0] - 1, myTile[1]))
				array_push(highlightTiles, getWorldCoords(myTile[0], myTile[1] + 1))
				array_push(highlightTiles, getWorldCoords(myTile[0], myTile[1] - 1))
			
				for (var i = array_length(highlightTiles)-1; i >= 0; i--) {
					var list = ds_list_create()
					instance_position_list(highlightTiles[i][0], highlightTiles[i][1],obj_boardElement,list,false)
					
					var foundStrikable = false
					for (var j = 0; j < ds_list_size(list); j++) {
						if !ds_list_find_value(list,j).invincible {
							foundStrikable = true
							break
						}
					}
					
					if !foundStrikable
						array_delete(highlightTiles, i, 1)
				}
				break
				
			case InputSelection.theSun:
			case InputSelection.theMoon:
				array_push(highlightTiles, getWorldCoords(myTile[0], myTile[1]))
				break
				
			case InputSelection.theLovers:
			case InputSelection.theChariot:
				case InputSelection.theHermit:
				case InputSelection.theWheel:
				case InputSelection.theDevil:
				case InputSelection.theTower:
				case InputSelection.theStar:
				case InputSelection.judgement:
				case InputSelection.theWorld:
				
				for (var i = 0; i < instance_number(obj_tile); ++i;)
				{
				    var tile = instance_find(obj_tile,i)
					array_push(highlightTiles, [tile.x,tile.y])
				}
				break
				
		}
	
		for (var i = 0; i < array_length(highlightTiles); i++) {
			var instance = instance_position(highlightTiles[i][0], highlightTiles[i][1], obj_tile)
			if instance_exists(instance)
				instance.highlighted = true
		}
	
	}
}
function reset_tiles() {
	with obj_tile highlighted = false
}

function removeFromQueue(elem) {
	var index = array_get_index(obj_control.elementQueue, elem)
	var moveQueuePointer = index <= obj_control.queuePointer
	array_delete(obj_control.elementQueue, index, 1)
	if moveQueuePointer obj_control.queuePointer--
}
function any_active() {
	for (var i = 0; i < array_length(obj_control.elementQueue); i++) {
		if obj_control.elementQueue[i].active
			return true
	}
	return false
}