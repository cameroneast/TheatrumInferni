/// @description Insert description here
// You can write your code in this editor

var death = instance_create_layer(x,y,sorting_layer,obj_death)
death.sprite_index = sprite_index
death.image_index = image_index
death.image_xscale = image_xscale

removeFromQueue(id)
if !any_active() && !barrier_after
	with obj_control start_next()