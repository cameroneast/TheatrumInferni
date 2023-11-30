// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
#macro BOARD_DISTANCE_FROM_CORNER 24

function getTileCoords(_x, _y) {
	return [(_x - BOARD_DISTANCE_FROM_CORNER) / 16, (_y - BOARD_DISTANCE_FROM_CORNER) / 16]
}
function getWorldCoords(_x, _y) {
	return [(_x * 16) + BOARD_DISTANCE_FROM_CORNER, (_y * 16) + BOARD_DISTANCE_FROM_CORNER]
}

enum ActionType {
	move,
	spawn, //unused
	immediate, //unused
	animate
}

function step_toward_element(element) { //extend to step toward space
	global.grid = mp_grid_create(BOARD_DISTANCE_FROM_CORNER,BOARD_DISTANCE_FROM_CORNER,12,8,16,16)
	with obj_boardElement {
		if id != other.id && !id.passable && id.ground == ground && id != element //do ground here
			mp_grid_add_instances(global.grid, id, true)
	}
	var goalX, goalY
	global.path = path_add()
	if mp_grid_path(global.grid, global.path, x, y, element.x, element.y, false) {
		path_start(global.path, 0, path_action_stop, true)
		path_part = 16 / path_get_length(global.path)
		goalX = path_get_x(global.path, path_part)
		goalY = path_get_y(global.path, path_part)
		path_end()
	}
	return [goalX, goalY]
}

function get_next_action(){
	
	//see obj_tile
	if user_input {
		var oldUserInputBuffer = obj_control.userInputBuffer
		obj_control.userInputBuffer = pointer_null
		return oldUserInputBuffer
	}
	
	switch(object_index) {
		case obj_enemy1:
			
			var goal = step_toward_element(inst_8BA159E)
			return {
				type: ActionType.move,
				//parms: [x, y + 16]
				parms: [goal[0], goal[1]]
			}
			
		case obj_meleeSlash:
			
			return {
				type: ActionType.animate,
				parms: []
			}
	}
}

function start_toward_goal() {
	switch(nextAction.type) {
		case ActionType.move:
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
			array_insert(obj_control.elementQueue, ind,
				instance_create_layer(nextAction.parms[0],nextAction.parms[1],"BoardElements",nextAction.parms[2]))
			with obj_control start_next()
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
		case ActionType.animate:
			//image_index++
			break
	}
}
function check_if_goal_reached() {
	switch(nextAction.type) {
		case ActionType.move:
			return x == nextAction.parms[0] && y == nextAction.parms[1]
		case ActionType.animate:
			return image_index == image_number
	}
}

//this needs work. goes through this colliding with all others. then all others with this
//handles damage, move speed, and any other status effect
function do_damage_intersection() {
	var list = ds_list_create()
	var instances = instance_position_list(x, y, obj_boardElement, list, false)
	ds_list_delete(list, ds_list_find_index(list, id))
	
	switch (object_index) {
		case obj_meleeSlash:
			for (var i = 0; i < ds_list_size(list); i++) {
				subtract_health(ds_list_find_value(list, i), 1)
			}
			break
	}
}
function subtract_health(elm, amnt) {
	elm.hp -= amnt
	if elm.hp <= 0 {
		instance_destroy(elm)
	}
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
					if instance_position(highlightTiles[i][0], highlightTiles[i][1], obj_boardElement) == noone
						array_delete(highlightTiles, i, 1)
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