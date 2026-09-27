/obj/structure/ladder
	name = "ladder"
	desc = "A ladder connecting levels."
	icon_state = "ladder"
	anchored = TRUE

/obj/structure/ladder/attack_hand(mob/user)
	if(!user || !Adjacent(user))
		return ..()

	var/obj/structure/ladder/upper_ladder = get_linked_ladder(UP)
	var/obj/structure/ladder/lower_ladder = get_linked_ladder(DOWN)
	var/list/climb_choices = list()
	if(upper_ladder)
		climb_choices += "Up"
	if(lower_ladder)
		climb_choices += "Down"

	if(!length(climb_choices))
		to_chat(user, SPAN_WARNING("This ladder does not connect to another level."))
		return TRUE

	var/choice = show_radial_menu(user, src, climb_choices, custom_check = CALLBACK(src, PROC_REF(can_climb), user), require_near = TRUE)
	if(!choice || !can_climb(user))
		return TRUE

	var/turf/destination
	var/move_direction
	var/obj/structure/ladder/target_ladder
	switch(choice)
		if("Up")
			target_ladder = get_linked_ladder(UP)
			destination = get_turf(target_ladder)
			move_direction = UP
		if("Down")
			target_ladder = get_linked_ladder(DOWN)
			destination = get_turf(target_ladder)
			move_direction = DOWN
	if(!destination)
		to_chat(user, SPAN_WARNING("That direction is no longer connected."))
		return TRUE

	// A ladder can sit on a sector edge; avoid triggering an unrelated
	// horizontal space transition while moving to the paired ladder.
	ADD_TRAIT(user, TRAIT_CURRENTLY_Z_MOVING, ROUNDSTART_TRAIT)
	var/moved = user.Move(destination, move_direction)
	REMOVE_TRAIT(user, TRAIT_CURRENTLY_Z_MOVING, ROUNDSTART_TRAIT)
	if(moved)
		user.hud_used?.update_multiz_plane_visibility()
		user.update_sight()
	if(!moved)
		to_chat(user, SPAN_WARNING("You cannot climb in that direction."))
	return TRUE

/obj/structure/ladder/proc/get_linked_ladder(direction)
	var/turf/ladder_turf = get_turf(src)
	if(!ladder_turf)
		return null
	var/turf/target_turf
	if(direction == UP)
		target_turf = get_turf_above(ladder_turf)
	else if(direction == DOWN)
		target_turf = get_turf_below(ladder_turf)
	if(!target_turf)
		return null
	return locate(/obj/structure/ladder) in target_turf

/obj/structure/ladder/proc/can_climb(mob/user)
	return user && !QDELETED(src) && Adjacent(user)
