/turf/space
	icon = 'icons/turf/space.dmi'
	name = "\proper space"
	desc = "The infinite expanse of space. It's hazardous to traverse without proper protection."
	icon_state = "0"

	temperature = TCMB
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = HEAT_CAPACITY_VACUUM

	plane = PLANE_SPACE
	layer = SPACE_LAYER
	light_power = 0.25
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	intact = FALSE
	rust_resistance = RUST_RESISTANCE_ABSOLUTE

	atmos_mode = ATMOS_MODE_SPACE

	rad_insulation_alpha = RAD_NO_INSULATION
	var/image/multiz_depth_overlay

/// Open shaft tile for visible multi-z openings. Its icon state can be supplied with the hole sprite.
/turf/space/open
	icon_state = "open"

/turf/space/Initialize(mapload)
	SHOULD_CALL_PARENT(FALSE)
	if(!istype(src, /turf/space/transit) && !istype(src, /turf/space/open))
		icon_state = SPACE_ICON_STATE
	vis_contents.Cut() //removes inherited overlays

	if(initialized)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	initialized = TRUE
	update_z_plane()
	update_multiz_render()

	if(length(smoothing_groups))
		sortTim(smoothing_groups) //In case it's not properly ordered, let's avoid duplicate entries with the same values.
		SET_BITFLAG_LIST(smoothing_groups)

	if(length(canSmoothWith))
		sortTim(canSmoothWith)
		if(canSmoothWith[length(canSmoothWith)] > MAX_S_TURF) //If the last element is higher than the maximum turf-only value, then it must scan turf contents for smoothing targets.
			smoothing_flags |= SMOOTH_OBJ
		SET_BITFLAG_LIST(canSmoothWith)

	var/area/A = loc
	if(!get_turf_below(src) && !IS_DYNAMIC_LIGHTING(src) && IS_DYNAMIC_LIGHTING(A))
		add_overlay(/obj/effect/fullbright)

	if(light_power && light_range)
		update_light()

	if(opacity)
		directional_opacity = ALL_CARDINALS

	return INITIALIZE_HINT_NORMAL

/turf/space/update_multiz_render()
	if(istype(src, /turf/space/transit))
		return
	var/turf/below_turf = get_turf_below(src)
	// A chain of open-space turfs between floors should behave like one shaft.
	// Render the first actual surface below it; nested vis_contents on consecutive
	// space turfs does not reliably composite on every client.
	var/turf/rendered_turf = below_turf
	while(isspaceturf(rendered_turf))
		var/turf/next_turf = get_turf_below(rendered_turf)
		if(!next_turf)
			break
		rendered_turf = next_turf
	// Space turfs do not need to recursively render one another. If the shaft
	// ends in space, keep this turf's own star field instead of compositing all
	// the lower levels' parallax backgrounds into it.
	if(isspaceturf(rendered_turf))
		rendered_turf = null
	var/turf/previously_rendered_turf = multiz_rendered_below
	update_multiz_contents(rendered_turf)
	if(previously_rendered_turf != multiz_rendered_below)
		update_multiz_lighting_sources(src)
	if(below_turf)
		SSair.multiz_air_openings |= src
	else
		SSair.multiz_air_openings -= src
	if(multiz_depth_overlay)
		overlays -= multiz_depth_overlay
		multiz_depth_overlay = null
	if(below_turf)
		// A subtle tint makes the opening read as a hole while keeping the
		// lower floor and its contents visible underneath it.
		multiz_depth_overlay = image('icons/effects/alphacolors.dmi', src, "white")
		multiz_depth_overlay.color = "#000000"
		multiz_depth_overlay.alpha = 60
		multiz_depth_overlay.plane = plane
		multiz_depth_overlay.layer = SPACE_LAYER + 0.1
		overlays += multiz_depth_overlay
	if(istype(src, /turf/space/open))
		icon_state = "open"
	else
		icon_state = rendered_turf ? "" : SPACE_ICON_STATE
	var/area/current_area = loc
	cut_overlay(/obj/effect/fullbright)
	if(!below_turf && !IS_DYNAMIC_LIGHTING(src) && IS_DYNAMIC_LIGHTING(current_area))
		add_overlay(/obj/effect/fullbright)

/turf/space/BeforeChange()
	..()

	if(light_sources) // Turn off starlight, if present
		set_light(0)
		GLOB.starlight -= src

/turf/space/proc/update_starlight()
	if(GLOB.configuration.general.starlight)
		for(var/t in RANGE_TURFS(1,src)) //RANGE_TURFS is in code\__HELPERS\game.dm
			if(isspaceturf(t))
				//let's NOT update this that much pls
				continue
			set_light(2)
			GLOB.starlight += src
			return
		set_light(0)

/datum/milla_safe/multiz_air_exchange

/datum/milla_safe/multiz_air_exchange/on_run(turf/space/upper_turf)
	if(!istype(upper_turf))
		return
	var/turf/lower_turf = get_turf_below(upper_turf)
	if(!lower_turf || upper_turf.blocks_air || lower_turf.blocks_air)
		return
	var/datum/gas_mixture/upper_air = get_turf_air(upper_turf)
	var/datum/gas_mixture/lower_air = get_turf_air(lower_turf)
	for(var/gas_id in list(GAS_O2, GAS_N2, GAS_CO2, GAS_PL, GAS_N2O, GAS_A_B, GAS_H2, GAS_H20))
		var/behavior = MULTIZ_GAS_NEUTRAL
		if(gas_id & MULTIZ_LIGHT_GAS_FLAGS)
			behavior = MULTIZ_GAS_LIGHT
		else if(gas_id & MULTIZ_HEAVY_GAS_FLAGS)
			behavior = MULTIZ_GAS_HEAVY
		var/upper_moles = upper_air.get_multiz_gas_moles(gas_id)
		var/lower_moles = lower_air.get_multiz_gas_moles(gas_id)
		var/source_to_destination = 0 // Positive means upper -> lower.
		if(behavior == MULTIZ_GAS_HEAVY)
			if(upper_moles > lower_moles)
				source_to_destination = 1
		else if(behavior == MULTIZ_GAS_LIGHT)
			if(lower_moles > upper_moles)
				source_to_destination = -1
		else if(upper_moles > lower_moles)
			source_to_destination = 1
		else if(lower_moles > upper_moles)
			source_to_destination = -1
		if(!source_to_destination)
			continue
		var/transfer_amount = abs(upper_moles - lower_moles) * 0.1
		if(source_to_destination > 0)
			transfer_amount = min(transfer_amount, upper_moles)
			upper_air.set_multiz_gas_moles(gas_id, upper_moles - transfer_amount)
			lower_air.set_multiz_gas_moles(gas_id, lower_moles + transfer_amount)
		else
			transfer_amount = min(transfer_amount, lower_moles)
			lower_air.set_multiz_gas_moles(gas_id, lower_moles - transfer_amount)
			upper_air.set_multiz_gas_moles(gas_id, upper_moles + transfer_amount)
	if(abs(upper_air.temperature() - lower_air.temperature()) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
		var/temperature_delta = (upper_air.temperature() - lower_air.temperature()) * 0.05
		upper_air.set_temperature(upper_air.temperature() - temperature_delta)
		lower_air.set_temperature(lower_air.temperature() + temperature_delta)

/datum/gas_mixture/proc/get_multiz_gas_moles(gas_id)
	switch(gas_id)
		if(GAS_O2)
			return oxygen()
		if(GAS_N2)
			return nitrogen()
		if(GAS_CO2)
			return carbon_dioxide()
		if(GAS_PL)
			return toxins()
		if(GAS_N2O)
			return sleeping_agent()
		if(GAS_A_B)
			return agent_b()
		if(GAS_H2)
			return hydrogen()
		if(GAS_H20)
			return water_vapor()
	return 0

/datum/gas_mixture/proc/set_multiz_gas_moles(gas_id, amount)
	switch(gas_id)
		if(GAS_O2)
			set_oxygen(amount)
		if(GAS_N2)
			set_nitrogen(amount)
		if(GAS_CO2)
			set_carbon_dioxide(amount)
		if(GAS_PL)
			set_toxins(amount)
		if(GAS_N2O)
			set_sleeping_agent(amount)
		if(GAS_A_B)
			set_agent_b(amount)
		if(GAS_H2)
			set_hydrogen(amount)
		if(GAS_H20)
			set_water_vapor(amount)

/turf/space/item_interaction(mob/living/user, obj/item/used, list/modifiers)
	if(istype(used, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = used
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		var/obj/structure/lattice/catwalk/W = locate(/obj/structure/lattice/catwalk, src)
		if(W)
			to_chat(user, SPAN_WARNING("There is already a catwalk here!"))
			return ITEM_INTERACT_COMPLETE
		if(L)
			if(R.use(1))
				to_chat(user, SPAN_NOTICE("You construct a catwalk."))
				playsound(src, 'sound/weapons/genhit.ogg', 50, 1)
				new/obj/structure/lattice/catwalk(src)
				return ITEM_INTERACT_COMPLETE
			else
				to_chat(user, SPAN_WARNING("You need two rods to build a catwalk!"))
				return ITEM_INTERACT_COMPLETE
		if(R.use(1))
			to_chat(user, SPAN_NOTICE("Constructing support lattice..."))
			playsound(src, 'sound/weapons/genhit.ogg', 50, 1)
			ReplaceWithLattice()
			return ITEM_INTERACT_COMPLETE
		else
			to_chat(user, SPAN_WARNING("You need one rod to build a lattice."))
			return ITEM_INTERACT_COMPLETE

	if(istype(used, /obj/item/stack/tile/plasteel))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/plasteel/S = used
			if(S.use(1))
				qdel(L)
				playsound(src, 'sound/weapons/genhit.ogg', 50, 1)
				to_chat(user, SPAN_NOTICE("You build a floor."))
				ChangeTurf(/turf/simulated/floor/plating)
				return ITEM_INTERACT_COMPLETE
			else
				to_chat(user, SPAN_WARNING("You need one floor tile to build a floor!"))
				return ITEM_INTERACT_COMPLETE
		else
			to_chat(user, SPAN_WARNING("The plating is going to need some support! Place metal rods first."))
			return ITEM_INTERACT_COMPLETE

	return ..()

/turf/space/Entered(atom/movable/A as mob|obj, atom/OL, ignoreRest = 0)
	..()
	if((!(A) || !(src in A.locs)))
		return
	var/turf/old_turf = get_turf(OL)
	// A deliberate vertical move into space is flight, not a fall back through
	// the opening it just traversed.
	if(old_turf && old_turf.z != z)
		return
	var/turf/lower_turf = get_turf_below(src)
	if(lower_turf && !A.anchored && A.simulated && (isliving(A) || isobj(A)))
		INVOKE_ASYNC(src, PROC_REF(drop_through_multiz), A, lower_turf)

/turf/space/proc/drop_through_multiz(atom/movable/A, turf/lower_turf)
	if(QDELETED(A) || !A || get_turf(A) != src || !lower_turf || QDELETED(lower_turf))
		return
	// A void below an opening should not pull things down by itself. Only let
	// atoms fall into lower-level space when pressurized air is actually venting
	// from the upper level through this opening.
	if(isspaceturf(lower_turf) && !has_downward_multiz_airflow(lower_turf))
		return
	A.visible_message(SPAN_WARNING("[A] falls through [src]!"))
	A.forceMove(lower_turf)
	if(isliving(A))
		var/mob/living/fallen_mob = A
		fallen_mob.Weaken(1 SECONDS)
		fallen_mob.adjustBruteLoss(10)
	lower_turf.handle_fall()

/turf/space/proc/has_downward_multiz_airflow(turf/lower_turf)
	return get_multiz_airflow_direction(lower_turf) == DOWN

/// Estimates pressure-driven airflow through this opening, positive z upwards.
/turf/space/proc/get_multiz_airflow_direction(turf/lower_turf)
	if(!lower_turf)
		return NONE
	var/upper_pressure = get_readonly_air().return_pressure()
	for(var/turf/upper_neighbor in GetAtmosAdjacentTurfs())
		if(upper_neighbor.z != z || upper_neighbor.blocks_air)
			continue
		upper_pressure = max(upper_pressure, upper_neighbor.get_readonly_air().return_pressure())
	var/lower_pressure = lower_turf.get_readonly_air().return_pressure()
	var/pressure_delta = upper_pressure - lower_pressure
	if(pressure_delta >= WARNING_LOW_PRESSURE)
		return DOWN
	if(pressure_delta <= -WARNING_LOW_PRESSURE)
		return UP
	return NONE

/turf/space/proc/Sandbox_Spacemove(atom/movable/A as mob|obj)
	var/cur_x
	var/cur_y
	var/next_x
	var/next_y
	var/target_z
	var/list/y_arr

	if(src.x <= 1)
		if(istype(A, /obj/effect/meteor)||istype(A, /obj/effect/space_dust))
			qdel(A)
			return

		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		next_x = (--cur_x||length(GLOB.global_map))
		y_arr = GLOB.global_map[next_x]
		target_z = y_arr[cur_y]
/*
		//debug
		to_chat(world, "Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]")
		to_chat(world, "Target Z = [target_z]")
		to_chat(world, "Next X = [next_x]")
		//debug
*/
		if(target_z)
			A.z = target_z
			A.x = world.maxx - 2
			spawn (0)
				if(A && A.loc)
					A.loc.Entered(A)
	else if(src.x >= world.maxx)
		if(istype(A, /obj/effect/meteor))
			qdel(A)
			return

		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		next_x = (++cur_x > length(GLOB.global_map) ? 1 : cur_x)
		y_arr = GLOB.global_map[next_x]
		target_z = y_arr[cur_y]
/*
		//debug
		to_chat(world, "Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]")
		to_chat(world, "Target Z = [target_z]")
		to_chat(world, "Next X = [next_x]")
		//debug
*/
		if(target_z)
			A.z = target_z
			A.x = 3
			spawn (0)
				if(A && A.loc)
					A.loc.Entered(A)
	else if(src.y <= 1)
		if(istype(A, /obj/effect/meteor))
			qdel(A)
			return
		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		y_arr = GLOB.global_map[cur_x]
		next_y = (--cur_y||length(y_arr))
		target_z = y_arr[next_y]
/*
		//debug
		to_chat(world, "Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]")
		to_chat(world, "Next Y = [next_y]")
		to_chat(world, "Target Z = [target_z]")
		//debug
*/
		if(target_z)
			A.z = target_z
			A.y = world.maxy - 2
			spawn (0)
				if(A && A.loc)
					A.loc.Entered(A)

	else if(src.y >= world.maxy)
		if(istype(A, /obj/effect/meteor)||istype(A, /obj/effect/space_dust))
			qdel(A)
			return
		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		y_arr = GLOB.global_map[cur_x]
		next_y = (++cur_y > length(y_arr) ? 1 : cur_y)
		target_z = y_arr[next_y]
/*
		//debug
		to_chat(world, "Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]")
		to_chat(world, "Next Y = [next_y]")
		to_chat(world, "Target Z = [target_z]")
		//debug
*/
		if(target_z)
			A.z = target_z
			A.y = 3
			spawn (0)
				if(A && A.loc)
					A.loc.Entered(A)
	return

/turf/space/singularity_act()
	return

/turf/space/can_have_cabling()
	if(locate(/obj/structure/lattice/catwalk, src))
		return 1
	return 0

/turf/space/acid_act(acidpwr, acid_volume)
	return 0

/turf/space/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.icon = 'icons/turf/space.dmi'
	underlay_appearance.icon_state = SPACE_ICON_STATE
	underlay_appearance.plane = PLANE_SPACE
	return TRUE
