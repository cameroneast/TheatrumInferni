// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function advance_clock(){
	werewolfTimer = (werewolfTimer + 1) % 8
	with obj_player {
		if other.werewolfTimer == 0
			isHuman = true
		else if other.werewolfTimer = 4
			isHuman = false
	}
}