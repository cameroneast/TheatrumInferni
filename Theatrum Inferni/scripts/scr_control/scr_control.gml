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
	
	if elementQueue[queuePointer].user_input {
		change_input_selection(InputSelection.move)
		audio_play_sound(so_turnStart,1,false)
	}
	
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

function getRandomElement(probArray) {
	randomize()
	var ran = random(1)
	var arr = array_create(global.numBlockTypes, 0)
	arr[0] = probArray[0]
	for (var i = 1; i < global.numBlockTypes; i++) {
		arr[i] = arr[i-1] + probArray[i]
	}
	for (var i = 0; i < global.numBlockTypes; i++) {
		if ran <= arr[i] return i
	}
}

function normalizeArray(array) {
	var sum = 0
	for (var i = 0; i < array_length(array); i++) {
		sum += array[i]
	}
	for (var i = 0; i < array_length(array); i++) {
		array[i] /= sum
	}
	return array
}