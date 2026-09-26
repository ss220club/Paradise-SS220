/datum/space_level
	var/name = "Your config settings failed, you need to fix this for the datum space levels to work"
	var/zpos = 1
	var/flags = list() // We'll use this to keep track of whether you can teleport/etc

	// Map transition stuff
	var/list/neighbors = list()
	// # How this level connects with others. See __MAP_DEFINES.dm for defines
	// It's UNAFFECTED by default because none of the space turfs are normally linked up
	// so we don't need to rebuild transitions if an UNAFFECTED level is requested
	var/linkage = UNAFFECTED
	var/transition_tag
	// # imaginary placements on the grid - these reflect the point it is linked to
	var/xi
	var/yi
	var/list/transit_north = list()
	var/list/transit_south = list()
	var/list/transit_east = list()
	var/list/transit_west = list()

	var/transition_border_north
	var/transition_border_east
	var/transition_border_south
	var/transition_border_west

	// Init deferral stuff
	var/dirt_count = 0
	var/list/init_list = list()

	/// This is a list of ruins on the space_level. Used to prevent certain ruins from spawning on the same level as other ruins.
	var/list/our_ruin_list = list()

/datum/space_level/New(z, level_name, transition_type = SELFLOOPING, traits = list(BLOCK_TELEPORT), transition_tag_)
	name = level_name
	zpos = z
	flags = traits
	transition_tag = transition_tag_

	set_transition_borders()
	build_space_destination_arrays()
	set_linkage(transition_type)
	set_navbeacon()

/// Whether this level connects vertically to the level immediately above it.
/datum/space_level/proc/connects_up()
	return ZTRAIT_UP in flags

/// Whether this level connects vertically to the level immediately below it.
/datum/space_level/proc/connects_down()
	return ZTRAIT_DOWN in flags

/// Get the corresponding turf one level above, if the link is enabled.
/proc/get_turf_above(turf/T)
	if(!T || !GLOB.space_manager.initialized)
		return null
	var/datum/space_level/current_level = GLOB.space_manager.z_list["[T.z]"]
	var/datum/space_level/above_level = GLOB.space_manager.z_list["[T.z + 1]"]
	if(!current_level || !above_level)
		return null
	if(!current_level.connects_up() || !above_level.connects_down())
		return null
	return locate(T.x, T.y, T.z + 1)

/// Get the corresponding turf one level below, if the link is enabled.
/proc/get_turf_below(turf/T)
	if(!T || T.z <= 1 || !GLOB.space_manager.initialized)
		return null
	var/datum/space_level/current_level = GLOB.space_manager.z_list["[T.z]"]
	var/datum/space_level/below_level = GLOB.space_manager.z_list["[T.z - 1]"]
	if(!current_level || !below_level)
		return null
	if(!current_level.connects_down() || !below_level.connects_up())
		return null
	return locate(T.x, T.y, T.z - 1)

/// Get a turf in the requested planar direction, crossing a vertical connection first when needed.
/proc/get_step_multiz(atom/movable/mover, direction)
	var/turf/current_turf = get_turf(mover)
	if(!current_turf)
		return null
	if(direction & UP)
		var/turf/above_turf = get_turf_above(current_turf)
		return above_turf ? get_step(above_turf, direction & ~UP) : null
	if(direction & DOWN)
		var/turf/below_turf = get_turf_below(current_turf)
		return below_turf ? get_step(below_turf, direction & ~DOWN) : null
	return get_step(current_turf, direction)

/// Get the movement direction, including vertical direction when the turfs are linked.
/proc/get_dir_multiz(atom/us, atom/them)
	var/turf/source_turf = get_turf(us)
	var/turf/target_turf = get_turf(them)
	if(!source_turf || !target_turf)
		return NONE
	if(source_turf.z == target_turf.z)
		return get_dir(source_turf, target_turf)
	var/turf/adjacent_level_turf = get_turf_above(source_turf)
	var/vertical_direction = UP
	if(!adjacent_level_turf || adjacent_level_turf.z != target_turf.z)
		adjacent_level_turf = get_turf_below(source_turf)
		vertical_direction = DOWN
	if(!adjacent_level_turf || adjacent_level_turf.z != target_turf.z)
		return get_dir(source_turf, target_turf)
	return vertical_direction | get_dir(source_turf, target_turf)

/// Walk down connected levels and return the lowest matching turf.
/proc/get_lowest_turf(atom/thing)
	var/turf/current_turf = get_turf(thing)
	var/turf/next_turf = get_turf_below(current_turf)
	while(next_turf)
		current_turf = next_turf
		next_turf = get_turf_below(current_turf)
	return current_turf

/// Walk up connected levels and return the highest matching turf.
/proc/get_highest_turf(atom/thing)
	var/turf/current_turf = get_turf(thing)
	var/turf/next_turf = get_turf_above(current_turf)
	while(next_turf)
		current_turf = next_turf
		next_turf = get_turf_above(current_turf)
	return current_turf

/// Move a zero-gravity mob vertically through a corresponding open tile.
/mob/living/proc/try_multiz_hud_move(direction)
	if(incapacitated())
		return FALSE
	var/turf/current_turf = get_turf(src)
	if(!current_turf)
		return FALSE
	var/turf/destination
	if(direction == UP)
		destination = get_turf_above(current_turf)
		if(!destination)
			to_chat(src, SPAN_WARNING("There is no level connected above you."))
			return FALSE
		if(!isspaceturf(destination))
			to_chat(src, SPAN_WARNING("There is a ceiling above you."))
			return FALSE
		if(mob_has_gravity(destination))
			to_chat(src, SPAN_WARNING("You cannot float up while there is gravity above you."))
			return FALSE
		var/turf/space/destination_space = destination
		if(destination_space.get_multiz_airflow_direction(current_turf) == DOWN)
			to_chat(src, SPAN_WARNING("The airflow is pushing you down."))
			return FALSE
	else if(direction == DOWN)
		if(!isspaceturf(current_turf) || mob_has_gravity(current_turf))
			to_chat(src, SPAN_WARNING("There is a floor beneath you."))
			return FALSE
		destination = get_turf_below(current_turf)
		if(!destination)
			to_chat(src, SPAN_WARNING("There is no level connected below you."))
			return FALSE
		var/turf/space/current_space = current_turf
		if(current_space.get_multiz_airflow_direction(destination) == UP)
			to_chat(src, SPAN_WARNING("The airflow is pushing you up."))
			return FALSE
	else
		return FALSE
	if(destination.density)
		to_chat(src, SPAN_WARNING("You cannot move through the opening in that direction."))
		return FALSE
	// The destination turf can sit on a sector edge. Suppress the normal
	// horizontal z-transition while moving between linked vertical levels.
	ADD_TRAIT(src, TRAIT_CURRENTLY_Z_MOVING, ROUNDSTART_TRAIT)
	var/moved = Move(destination, direction)
	REMOVE_TRAIT(src, TRAIT_CURRENTLY_Z_MOVING, ROUNDSTART_TRAIT)
	if(!moved)
		to_chat(src, SPAN_WARNING("You cannot move through the opening in that direction."))
		return FALSE
	return TRUE

/datum/space_level/proc/set_transition_borders()
	// can't set these in declaration because world.maxx/y are null for some reason
	transition_border_north = TRANSITION_BORDER_NORTH
	transition_border_east = TRANSITION_BORDER_EAST
	transition_border_south = TRANSITION_BORDER_SOUTH
	transition_border_west = TRANSITION_BORDER_WEST

/datum/space_level/Destroy()
	if(linkage == CROSSLINKED)
		if(GLOB.space_manager.linkage_maps[transition_tag])
			remove_from_space_network(GLOB.space_manager.linkage_maps[transition_tag])

	GLOB.space_manager.unbuilt_space_transitions -= src
	GLOB.space_manager.z_list -= "[zpos]"
	return ..()

/datum/space_level/proc/build_space_destination_arrays()
	// We skip `add_to_transit` here because we want to skip the checks in order to save time
	// Bottom border
	for(var/turf/S in block(locate(1,1,zpos),locate(world.maxx,transition_border_south,zpos)))
		transit_south |= S

	// Top border
	for(var/turf/S in block(locate(1,world.maxy,zpos),locate(world.maxx,transition_border_north,zpos)))
		transit_north |= S

	// Left border
	for(var/turf/S in block(locate(1, transition_border_south + 1, zpos), locate(transition_border_west, transition_border_north - 1, zpos)))
		transit_west |= S

	// Right border
	for(var/turf/S in block(locate(transition_border_east, transition_border_south + 1, zpos),locate(world.maxx, transition_border_north - 1, zpos)))
		transit_east |= S

/datum/space_level/proc/add_to_transit(turf/S)
	if(S.y <= transition_border_south)
		transit_south |= S
		return

	// Top border
	if(S.y >= transition_border_north)
		transit_north |= S
		return

	// Left border
	if(S.x <= transition_border_west)
		transit_west |= S
		return

	// Right border
	if(S.x >= transition_border_east)
		transit_east |= S

/datum/space_level/proc/remove_from_transit(turf/S)
	if(S.y <= transition_border_south)
		transit_south -= S
		return

	// Top border
	if(S.y >= transition_border_north)
		transit_north -= S
		return

	// Left border
	if(S.x <= transition_border_west)
		transit_west -= S
		return

	// Right border
	if(S.x >= transition_border_east)
		transit_east -= S

/datum/space_level/proc/apply_transition(turf/S)
	if(src in GLOB.space_manager.unbuilt_space_transitions)
		return // Let the space manager handle this one
	switch(linkage)
		if(UNAFFECTED)
			S.remove_transitions()
		if(SELFLOOPING,CROSSLINKED)
			var/datum/space_level/E = get_connection()
			if(S in transit_north)
				E = get_connection(Z_LEVEL_NORTH)
				S.set_transition_north(E.zpos)
			if(S in transit_south)
				E = get_connection(Z_LEVEL_SOUTH)
				S.set_transition_south(E.zpos)
			if(S in transit_east)
				E = get_connection(Z_LEVEL_EAST)
				S.set_transition_east(E.zpos)
			if(S in transit_west)
				E = get_connection(Z_LEVEL_WEST)
				S.set_transition_west(E.zpos)


/datum/space_level/proc/get_turfs()
	return block(1, 1, zpos, world.maxx, world.maxy, zpos)

/datum/space_level/proc/set_linkage(transition_type)
	if(linkage == transition_type)
		return
	// Remove ourselves from the linkage map if we were cross-linked
	if(linkage == CROSSLINKED)
		if(GLOB.space_manager.linkage_maps[transition_tag])
			remove_from_space_network(GLOB.space_manager.linkage_maps[transition_tag])

	GLOB.space_manager.unbuilt_space_transitions |= src
	linkage = transition_type
	switch(transition_type)
		if(UNAFFECTED)
			reset_connections()
		if(SELFLOOPING)
			link_to_self() // `link_to_self` is defined in space_transitions.dm

//create docking ports for navigation consoles to jump to
/datum/space_level/proc/set_navbeacon()
	var/obj/docking_port/stationary/D = new /obj/docking_port/stationary(src)
	D.name = name
	D.id = "nav_z[zpos]"
	D.register()
	D.forceMove(locate(200, 200, zpos))

GLOBAL_LIST_INIT(atmos_machine_typecache, typecacheof(/obj/machinery/atmospherics))
GLOBAL_LIST_INIT(cable_typecache, typecacheof(/obj/structure/cable))

/datum/space_level/proc/resume_init()
	if(dirt_count > 0)
		throw EXCEPTION("Init told to resume when z-level still dirty. Z level: '[zpos]'")
	var/list/our_atoms = init_list // OURS NOW!!! (Keeping this list to ourselves will prevent hijack)
	init_list = list()
	listclearnulls(our_atoms)
	var/list/pipes = typecache_filter_list(our_atoms, GLOB.atmos_machine_typecache)
	var/list/cables = typecache_filter_list(our_atoms, GLOB.cable_typecache)
	SSatoms.InitializeAtoms(our_atoms, FALSE)
	our_atoms.Cut()
	if(length(pipes))
		do_pipes(pipes)
	if(length(cables))
		do_cables(cables)

/datum/space_level/proc/do_pipes(list/pipes)
	SSair._setup_atmos_machinery(pipes)
	SSair._setup_pipenets(pipes)
	pipes.Cut()

/datum/space_level/proc/do_cables(list/cables)
	SSmachines.setup_template_powernets(cables)
	cables.Cut()

/datum/space_level/proc/has_all_traits(list/traits)
	// Cool, horrible set inclusion
	return length(flags & traits) == length(traits)

/datum/space_level/lavaland/set_transition_borders()
	// really no reason why these need to be so large,
	// especially since ruin placement is already constrained
	transition_border_north = (world.maxy - 4)
	transition_border_east = (world.maxx - 4)
	transition_border_south = 3
	transition_border_west = 3

// space levels have no UI of their own so borrowing this proc for serialization
// for other UIs
/datum/space_level/ui_data(mob/user)
	. = list(
		"name" = name,
		"zpos" = zpos,
		"linkage" = linkage,
		"transition_tag" = transition_tag,
		"traits" = flags,
	)

	.["neighbors"] = list()
	for(var/direction in list(Z_LEVEL_SOUTH, Z_LEVEL_NORTH, Z_LEVEL_EAST, Z_LEVEL_WEST))
		var/datum/space_level/neighbor = get_connection(direction)
		if(neighbor)
			var/dirname = dir2text(text2num(direction))
			.["neighbors"][dirname] = neighbor.zpos

	.["ruins"] = list()
	for(var/obj/effect/landmark/ruin/ruin_landmark in GLOB.ruin_landmarks)
		if(ruin_landmark.z == zpos)
			.["ruins"] += list(list(
				"name" = ruin_landmark.ruin_template.name,
				"mappath" = ruin_landmark.ruin_template.mappath,
				"coords" = list(
					"x" = ruin_landmark.x,
					"y" = ruin_landmark.y,
					"z" = ruin_landmark.z,
				),
			))
