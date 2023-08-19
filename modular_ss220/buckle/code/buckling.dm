//procs that handle the actual buckling and unbuckling
/atom/movable/buckle_mob(mob/living/M, force = FALSE, check_loc = TRUE)
	if(!buckled_mobs)
		buckled_mobs = list()

	if(!istype(M))
		return FALSE

	if(check_loc && !in_range(M, src))
		return FALSE

	if(check_loc && !M.Move(loc))
		return FALSE

	if((!can_buckle && !force) || M.buckled || (length(buckled_mobs) >= max_buckled_mobs) || (buckle_requires_restraints && !M.restrained()) || M == src)
		return FALSE
	M.buckling = src

	if(!M.can_buckle() && !force)
		if(M == usr)
			to_chat(M, "<span class='warning'>You are unable to buckle yourself to [src]!</span>")
		else
			to_chat(usr, "<span class='warning'>You are unable to buckle [M] to [src]!</span>")
		M.buckling = null
		return FALSE

	if(M.pulledby)
		if(buckle_prevents_pull)
			M.pulledby.stop_pulling()

	for(var/obj/item/grab/G in M.grabbed_by)
		qdel(G)

	if(!check_loc && M.loc != loc)
		M.forceMove(loc)

	if(!check_loc && M.loc != loc)
		M.Move(loc)

	if(!buckle_lying)
		M.set_body_position(STANDING_UP)
	else
		M.set_body_position(LYING_DOWN)

	if(M.pulling && M.pulling == src)
		M.stop_pulling()

	M.buckling = null
	M.buckled = src
	M.setDir(dir)
	buckled_mobs |= M
	ADD_TRAIT(M, TRAIT_IMMOBILIZED, BUCKLING_TRAIT)
	M.throw_alert("buckled", /obj/screen/alert/restrained/buckled)
	post_buckle_mob(M)
	SEND_SIGNAL(src, COMSIG_MOVABLE_BUCKLE, M, force)
	return TRUE
