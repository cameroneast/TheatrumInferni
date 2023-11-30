/// @description Insert description here
// You can write your code in this editor

if highlighted {
	switch(obj_control.selection) {
		case InputSelection.move:
			obj_control.userInputBuffer = {
				type: ActionType.move,
				parms: [x, y]
			}
			break;
			
		case InputSelection.meleeSword:
			obj_control.userInputBuffer = {
				type: ActionType.immediate,
				parms: [x,y, obj_meleeSlash]
			}
			break;
	}
}