/// @description Insert description here
// You can write your code in this editor

if global.circle == 9 {
	text = "In the realm where shadows intertwine,\n     a Werewolf named Yin Fang,\nAn inner battle, a cosmic pang,\n     in him, conflicting currents sang.\n\nA noble soul, within him lies,\n     yet an uncontrollable tide,\nHis other side, a feral guide,\n     in the cosmic dance does bide.\n\nFor disobedience to self,\n     he plummeted, to the abyss profound,\nThe lowest circle, Treachery's ground,\n     where redemption is rarely found.\n\nNine circles await, trials profound,\n     each a cosmic test,\nTarot cards, his only bequest,\n     in this infernal quest.\n\nYin Fang, in the dark abyss,\n     must confront his inner strife,\nA symphony of cosmic life,\n     through nine circles, his journey's rife.\n\nYet within his Wolf form,\n     salvation howls through the air,\nThrough trials profound, a savior rare,\n     in the cosmic tapestry's solemn glare.\n"
	startY = 331
	endY = -114
	nextRoom = room_inGame
} else {
	text = "Design\n\nLogan Bodenheimer\n\n\nProduction\n\nCameron East\n\n\nArt\n\nAndrew Campbell\n\n\nProgramming\n\nMax Levine\n\n\nThanks for playing!"
	startY = 352
	endY = -82
	nextRoom = room_title
}

draw_set_color(c_white)
draw_set_font(font_theatrum)
draw_set_halign(fa_center)
draw_set_valign(fa_middle)

x = room_width/2
y = startY