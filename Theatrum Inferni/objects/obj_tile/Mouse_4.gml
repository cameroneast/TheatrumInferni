/// @description Insert description here
// You can write your code in this editor

if highlighted {
	
	with obj_player attack_animate(-1)
	
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
		
			if obj_player.isHuman {
		
				obj_control.userInputBuffer = {
					type: ActionType.melee2,
					parms: [x,y, obj_meleeSlash],
					moveCost: 1,
					manaCost: 0
				}
			
			} else {
				
				obj_control.userInputBuffer = {
					type: ActionType.immediate,
					parms: [x,y, obj_meleeSlash],
					moveCost: 1,
					manaCost: 0
				}
				
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
			
						case InputSelection.theLovers:
			case InputSelection.theChariot:
				case InputSelection.theHermit:
				case InputSelection.theWheel:
				case InputSelection.theDevil:
				case InputSelection.theTower:
				case InputSelection.theStar:
				case InputSelection.judgement:
				case InputSelection.theWorld:
							obj_control.userInputBuffer = {
				type: ActionType.spawn,
				parms: [x,y],
				moveCost: 0,
				manaCost: 2
			}
			break;
	}
}