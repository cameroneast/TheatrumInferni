/// @description Insert description here
// You can write your code in this editor
#macro tarotStart 3
#macro tarotEnd 13
//for all the many moves, attacks, spell types
enum InputSelection {
	move,
	meleeSword,
	fireball, //unused
	
	theLovers,
	theChariot,
	theHermit,
	theWheel,
	theDevil,
	theTower,
	theStar,
	theMoon,
	theSun,
	judgement,
	theWorld
}
selection = InputSelection.move
userInputBuffer = pointer_null

elementQueue = array_create(0)
queuePointer = -1

array_push(elementQueue, instance_create_layer(0,0,"Ground",obj_incrementClock))

for (var i = 0; i < instance_number(obj_boardElement); ++i;)
{
	reposition(instance_find(obj_boardElement,i))
	
    array_push(elementQueue, instance_find(obj_boardElement,i))
}

card_array = array_create(0)

total_mana = 4
mana = total_mana

game_froze = true
game_won = pointer_null
show_end_text = false
queuePointer = 0

instance_create_layer(0,0,"Fade",obj_fade)

//unfreeze_start_game()