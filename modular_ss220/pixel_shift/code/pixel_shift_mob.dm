/mob/proc/add_pixel_shift_component()
	return

/mob/living/add_pixel_shift_component()
	AddComponent(/datum/component/pixel_shift)

/mob/living/silicon/ai/add_pixel_shift_component()
	return

// Да, костыльно, но модульно по другому не вижу как
/mob/living/Process_Spacemove(movement_dir)
	if(SEND_SIGNAL(src, COMSIG_MOB_PIXEL_SHIFTING) & COMPONENT_LIVING_PASSABLE)
		SEND_SIGNAL(src, COMSIG_MOB_PIXEL_SHIFT, movement_dir)
		return FALSE
	. = ..()
