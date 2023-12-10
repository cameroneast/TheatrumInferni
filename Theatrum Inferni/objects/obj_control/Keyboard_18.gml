/// @description Insert description here
// You can write your code in this editor

if(keyboard_check_pressed(ord("K"))){
	//for (var i = 0; i < instance_number(obj_boardElement); i++;)
	//{
	//   var elm = instance_find(obj_boardElement,i);
	//   if elm.enemy {
	//	   subtract_health(elm, elm.hp)
	//   }
	//}
	with obj_boardElement {
		if enemy subtract_health(self, hp)
	}
}

if(keyboard_check_pressed(ord("H"))){
	obj_player.hp = obj_player.total_hp
}

if(keyboard_check_pressed(ord("M"))){
	obj_control.mana = obj_control.total_mana
}