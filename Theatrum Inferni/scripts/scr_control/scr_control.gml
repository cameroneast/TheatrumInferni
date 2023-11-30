// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function start_next(){
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
}