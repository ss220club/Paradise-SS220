/turf/proc/CanAtmosPass(direction, consider_objects = TRUE)
	if(blocks_air)
		return FALSE

	if(!consider_objects)
		return TRUE

	if(IS_DIR_DIAGONAL(direction))
		// We only need special handling for diagonal directions.
		// Just check if atmos can pass in any of the adjacent cardinal directions.
		var/h_comp = direction & (direction - 1)
		var/v_comp = direction ^ h_comp

		var/turf/h_turf = get_step(src, h_comp)
		var/turf/v_turf = get_step(src, v_comp)

		var/can_pass_adjacent = \
			h_turf && CanAtmosPass(h_comp, consider_objects) && h_turf.CanAtmosPass(v_comp, consider_objects) \
			|| v_turf && CanAtmosPass(v_comp, consider_objects) && v_turf.CanAtmosPass(h_comp, consider_objects)

		if(!can_pass_adjacent)
			return FALSE

	for(var/obj/O in contents)
		if(istype(O, /obj/item))
			// Items can't block atmos.
			continue

		if(!O.CanAtmosPass(direction))
			return FALSE

	return TRUE

/turf/proc/CanAtmosPassBidirectional(direction, consider_objects = TRUE)
	var/turf/target = get_step(src, direction)
	if(!target)
		return FALSE
	if(!CanAtmosPass(direction, consider_objects))
		return FALSE
	if(!target.CanAtmosPass(REVERSE_DIR(direction), consider_objects))
		return FALSE
	return TRUE

/atom/movable/proc/CanAtmosPass(direction)
	return TRUE

/atom/proc/CanPass(atom/movable/mover, border_dir)
	return !density

/turf/CanPass(atom/movable/mover, border_dir)
	var/turf/target = get_step(src, border_dir)
	if(!target)
		return FALSE

	if(istype(mover)) // turf/Enter(...) will perform more advanced checks
		return !density

	else // Now, doing more detailed checks for air movement and air group formation
		if(target.blocks_air||blocks_air)
			return 0

		for(var/obj/obstacle in src)
			if(!obstacle.CanPass(mover, border_dir))
				return 0
		for(var/obj/obstacle in target)
			if(!obstacle.CanPass(mover, src))
				return 0

		return 1

/atom/movable/proc/get_superconductivity(direction)
	return OPEN_HEAT_TRANSFER_COEFFICIENT

/atom/movable/proc/recalculate_atmos_connectivity()
	for(var/turf/T in locs) // used by double wide doors and other nonexistant multitile structures
		T.recalculate_atmos_connectivity()

/atom/movable/proc/move_update_air(turf/T)
	if(isturf(T))
		T.recalculate_atmos_connectivity()
	recalculate_atmos_connectivity()

//returns a list of adjacent turfs that can share air with this one.
//alldir includes adjacent diagonal tiles that can share
//	air with both of the related adjacent cardinal tiles
/turf/proc/GetAtmosAdjacentTurfs(alldir = 0)
	if(!issimulatedturf(src))
		return list()

	var/adjacent_turfs = list()
	var/range_edge_turfs = RANGE_EDGE_TURFS(1, src)
	for(var/turf/T in range_edge_turfs)
		var/direction = get_dir(src, T)
		if(!CanAtmosPass(direction))
			continue
		if(!T.CanAtmosPass(REVERSE_DIR(direction)))
			continue
		adjacent_turfs += T

	if(alldir)
		adjacent_turfs += src

	return adjacent_turfs

/atom/movable/proc/atmos_spawn_air(flag, amount) //because a lot of people loves to copy paste awful code lets just make a easy proc to spawn your plasma fires
	var/turf/simulated/T = get_turf(src)
	if(!istype(T))
		return
	T.atmos_spawn_air(flag, amount)

/turf/simulated/proc/atmos_spawn_air(flag, amount)
	if(!flag || !amount || blocks_air)
		return

	var/datum/gas_mixture/G = new()

	if(flag & LINDA_SPAWN_20C)
		G.set_temperature(T20C)

	if(flag & LINDA_SPAWN_HEAT)
		G.set_temperature(G.temperature() + 1000)

	if(flag & LINDA_SPAWN_COLD)
		G.set_temperature(TCMB)

	if(flag & LINDA_SPAWN_TOXINS)
		G.set_toxins(G.toxins() + amount)

	if(flag & LINDA_SPAWN_OXYGEN)
		G.set_oxygen(G.oxygen() + amount)

	if(flag & LINDA_SPAWN_CO2)
		G.set_carbon_dioxide(G.carbon_dioxide() + amount)

	if(flag & LINDA_SPAWN_NITROGEN)
		G.set_nitrogen(G.nitrogen() + amount)

	if(flag & LINDA_SPAWN_N2O)
		G.set_sleeping_agent(G.sleeping_agent() + amount)

	if(flag & LINDA_SPAWN_AGENT_B)
		G.set_agent_b(G.agent_b() + amount)

	if(flag & LINDA_SPAWN_AIR)
		G.set_oxygen(G.oxygen() + MOLES_O2STANDARD * amount)
		G.set_nitrogen(G.nitrogen() + MOLES_N2STANDARD * amount)

	blind_release_air(G)
