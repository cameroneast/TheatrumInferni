/// @description Insert description here
// You can write your code in this editor

//currentSprite = Yin_Human_idle
if x > oldX && obj_control.elementQueue[obj_control.queuePointer] == id {
	image_xscale = 1
	sprite_index = isHuman ? Yin_Human_Move_Side : Yin_Wolf_Move_Side
	isAttacking = false
} else if x < oldX && obj_control.elementQueue[obj_control.queuePointer] == id {
	image_xscale = -1
	sprite_index = isHuman ? Yin_Human_Move_Side : Yin_Wolf_Move_Side
	isAttacking = false
} else if y > oldY && obj_control.elementQueue[obj_control.queuePointer] == id {
	sprite_index = isHuman ? Yin_Human_Move_Down : Yin_Wolf_Move_Down
	isAttacking = false
} else if y < oldY && obj_control.elementQueue[obj_control.queuePointer] == id{
	sprite_index = isHuman ? Yin_Human_Move_Up : Yin_Wolf_Move_Up
	isAttacking = false
} else if !isAttacking {
	sprite_index = isHuman ? Yin_Human_idle : Yin_Wolf_Idle
	isAttacking = false
} else {
	sprite_index = isHuman ? Yin_Human_Attack : Yin_Wolf_Attack
}

oldX = x
oldY = y