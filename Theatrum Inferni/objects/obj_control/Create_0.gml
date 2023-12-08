/// @description Insert description here
// You can write your code in this editor

//for all the many moves, attacks, spell types
enum InputSelection {
	move,
	meleeSword,
	fireball
}
selection = InputSelection.move
userInputBuffer = pointer_null

elementQueue = array_create(0)
queuePointer = -1

for (var i = 0; i < instance_number(obj_boardElement); ++i;)
{
	reposition(instance_find(obj_boardElement,i))
	
    array_push(elementQueue, instance_find(obj_boardElement,i))
}

total_mana = 4
mana = total_mana

didWerewolfStart = false

start_next()