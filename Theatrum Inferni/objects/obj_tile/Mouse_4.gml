/// @description Insert description here
// You can write your code in this editor

if highlighted {
	
	with obj_card {
		if obj_control.selection == (image_index + tarotStart)
			instance_destroy()
	}
	
	switch(obj_control.selection) {
		case InputSelection.move:
			obj_control.userInputBuffer = {
				type: ActionType.move,
				parms: [x, y],
				moveCost: 1,
				manaCost: 0
			}
			break;
			
		case InputSelection.meleeSword:
			obj_control.userInputBuffer = {
				type: ActionType.immediate,
				parms: [x,y, obj_meleeSlash],
				moveCost: 1,
				manaCost: 0
			}
			break;
			
		case InputSelection.theSun:
			obj_control.userInputBuffer = {
				type: ActionType.earlyTransform,
				parms: true,
				moveCost: 0,
				manaCost: tarotCost(obj_control.selection)
			}
			break;
			
		case InputSelection.theMoon:
			obj_control.userInputBuffer = {
				type: ActionType.earlyTransform,
				parms: false,
				moveCost: 0,
				manaCost: tarotCost(obj_control.selection)
			}
			break;
	}
}