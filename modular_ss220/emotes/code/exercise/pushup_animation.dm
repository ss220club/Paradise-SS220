/datum/pushup/proc/pushup_animation(temp_time_mod = 1)
	var/target_y = -5
	var/delay = 0.6 SECONDS * temp_time_mod
	var/time_low = 0.2 SECONDS * temp_time_mod
	var/time_hight = 0.8 SECONDS * temp_time_mod
	animate(user, pixel_y = target_y, time = time_hight, easing = QUAD_EASING) // Down to the floor
	if(!do_after(user, delay, TRUE))
		animate(user, pixel_y = 0, time = time_low, easing = QUAD_EASING)
		return FALSE
	animate(user, pixel_y = 0, time = time_hight, easing = QUAD_EASING) // Back up
	if(!do_after(user, delay, TRUE))
		animate(user, pixel_y = 0, time = time_low, easing = QUAD_EASING)
		return FALSE
	return TRUE

/datum/pushup/proc/clear_pushup_animation()
	if(isliving(user))
		var/mob/living/L = user
		L.clear_forced_look(quiet = TRUE)

/datum/pushup/proc/prepare_for_pushup_animation()
	if(isliving(user))
		var/mob/living/L = user
		// In BYOND-angles 0 is NORTH, 90 is EAST, 180 is SOUTH and 270 is WEST.
		if(L.lying_prev == 90)
			L.forced_look = EAST
		else
			L.forced_look = WEST
		return
	else if(isobserver(user))
		var/matrix/matrix = matrix() // All this to make their face actually face the floor... sigh... I hate resting code
		switch(user.dir)
			if(WEST)
				matrix.Turn(270)
			if(EAST)
				matrix.Turn(90)
			else
				if(prob(50))
					user.dir = EAST
					matrix.Turn(90)
				else
					user.dir = WEST
					matrix.Turn(270)
		user.transform = matrix
