/mob/proc/add_pixel_shift_component()
	return

/mob/Initialize(mapload)
	. = ..()
	add_pixel_shift_component()

/mob/living/add_pixel_shift_component()
	AddComponent(/datum/component/pixel_shift)

/mob/living/silicon/ai/add_pixel_shift_component()
	return

/mob/living/movement_delay()
	if(SEND_SIGNAL(src, COMSIG_MOB_PIXEL_SHIFTING) & COMPONENT_LIVING_PIXEL_SHIFTING)
		return 0
	. = ..()

/*
/mob/living/Move_Pulled(atom/A)
	. = ..()
	if(!. || !isliving(A))
		return
	var/mob/living/pulled_mob = A
	SEND_SIGNAL(pulled_mob, COMSIG_MOB_UNPIXEL_SHIFT)
*/

/*
/atom/movable/post_buckle_mob(mob/living/M)
	. = ..()

	M.unpixel_shift()
*/

/mob/living/CanPass(atom/movable/mover, turf/target, height)
	if(!istype(mover, /obj/item/projectile) && !mover.throwing)
		if(SEND_SIGNAL(src, COMSIG_MOB_PIXEL_SHIFT_PASSABLE, get_dir(src, mover)) & COMPONENT_LIVING_PASSABLE)
			return TRUE
	return ..()

