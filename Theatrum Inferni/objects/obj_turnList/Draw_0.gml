/// @description Insert description here
// You can write your code in this editor

var frame = 0
selector_frame = (selector_frame + 1) % 40
if selector_frame < 20
	frame = 1

var current = 0
for (var i = obj_control.queuePointer; i < array_length(obj_control.elementQueue); i++) {
	var elm = array_get(obj_control.elementQueue, i)
	if !elm.turn_list_ignore {
		current = i
		break
	}
}

var numCells = 0
for (var i = 0; i < array_length(obj_control.elementQueue); i++) {
	var elm = array_get(obj_control.elementQueue,i)
	
	if !elm.turn_list_ignore {
		var xPos = x + floor(numCells / 7) * 16
		var yPos = y + (numCells % 7) * 17
		draw_sprite(spr_turnCounter,0,xPos,yPos)
		draw_sprite_part_ext(elm.sprite_index,0,1,1,14,13,xPos-7,yPos-6,1,1,c_white,1)
		if i == current {
			draw_sprite(spr_turnSelect,frame,xPos,yPos)
		}
		numCells++
	}
}