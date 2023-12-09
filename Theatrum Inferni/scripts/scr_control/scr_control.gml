// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function start_next(){
	
	if game_froze return
	
	do {
		queuePointer++
		if array_length(elementQueue) <= queuePointer {
			queuePointer = 0
			for (var i = 0; i < array_length(elementQueue); i++) {
				elementQueue[i].currentTurns = elementQueue[i].totalTurns
			}
		}
	} until (elementQueue[queuePointer].currentTurns > 0)
	
	userInputBuffer = pointer_null
	
	elementQueue[queuePointer].active = true
	elementQueue[queuePointer].midMove = false
	
	if elementQueue[queuePointer].user_input
		change_input_selection(InputSelection.move)
	
	//if elementQueue[queuePointer].object_index != obj_push
	//	with elementQueue[queuePointer] do_damage_intersection()
	
	if elementQueue[queuePointer].barrier_after
		start_next()
}

function reposition(elm) {
	elm.x += 72
	elm.y -= 16
}

function unfreeze_start_game() {
	game_froze = false
	queuePointer = -1
	start_next()
}

function tarotCost(cardNum) {
	return 1
}