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

global.numBlockTypes = 9
var diffAdder = global.circle * 10
var probs = [2,3,3,4,2,2,5,1,60 + diffAdder]

probs = normalizeArray(probs)

with obj_tile {
	
	reposition(self)
	if position_meeting(x,y,obj_player) continue
	var newElm = pointer_null
	switch(getRandomElement(probs)) {
		case 0: newElm = instance_create_layer(x,y,"Ground",obj_enemy1) break
		case 1: newElm = instance_create_layer(x,y,"Ground",obj_eyebat) break
		case 2: newElm = instance_create_layer(x,y,"Ground",obj_impassableRock) break
		case 3: newElm = instance_create_layer(x,y,"Ground",obj_lava) break
		case 4: newElm = instance_create_layer(x,y,"Ground",obj_leaf) break
		case 5: newElm = instance_create_layer(x,y,"Ground",obj_lostSoul) break
		case 6: newElm = instance_create_layer(x,y,"Ground",obj_rock) break
		case 7: newElm = instance_create_layer(x,y,"Ground",obj_tortured) break
		//case 8: newElm = instance_create_layer(x,y,"Ground",obj_enemy1) break
	}
	if newElm != pointer_null
		array_push(other.elementQueue,newElm)
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