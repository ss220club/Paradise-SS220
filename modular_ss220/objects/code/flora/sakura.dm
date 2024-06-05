/// TIme before blossom starts
#define BLOSSOM_START_TIME (10 SECONDS)
/// Time before blossom ends
#define BLOSSOM_END_TIME (10 SECONDS)
/// Time before blossom leaves a pile
#define LEAVES_PILE_SPAWN_TIME (5 SECONDS)
/// Time before blossom transforms grass tile to Sakura's grass
#define TRANSFORM_TURF_TIME (5 SECONDS)

/* Sakura Tree */
/obj/structure/flora/tree/sakura
	name = "Sakura"
	desc = "It's a cherry blossom. Beautiful!"
	icon = 'modular_ss220/objects/icons/flora/sakura.dmi'
	icon_state = "cherry_blossom"
	pixel_y = 10
	var/obj/effect/blossom/blossom_effect
	var/timer_handle_start
	var/timer_handle_end

/obj/structure/flora/tree/sakura/Initialize(mapload)
	. = ..()
	RegisterSignal(SSticker, COMSIG_TICKER_ROUND_STARTING, PROC_REF(on_round_start))
	log_debug("Sakura object initialized.")

/obj/structure/flora/tree/sakura/New()
	. = ..()
	if(SSticker.IsRoundInProgress())
		log_debug("Initiating Blossom Cycle after round-start.")
		initiate_blossom_cycle()

/obj/structure/flora/tree/sakura/Destroy()
	if(timer_handle_start && timer_handle_end)
		deltimer(timer_handle_start)
		deltimer(timer_handle_end)
	if(blossom_effect)
		QDEL_NULL(blossom_effect)
	timer_handle_start = null
	timer_handle_end = null
	return ..()

/obj/structure/flora/tree/sakura/proc/on_round_start()
	initiate_blossom_cycle()
	SIGNAL_HANDLER
	UnregisterSignal(src, COMSIG_TICKER_ROUND_STARTING)
	log_debug("COMSIG_TICKER_ROUND_STARTING signal unregistered.")
	return

/// Initiates the blooming cycle, in which the countdown begins
/obj/structure/flora/tree/sakura/proc/initiate_blossom_cycle()
	log_debug("Blossom Cycle in-progress.")
	// Start the bloom cycle 30 minutes after the start of the round or creating new tree
	timer_handle_start = addtimer(CALLBACK(src, PROC_REF(start_blossom)), BLOSSOM_START_TIME, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_STOPPABLE)

/// Starts blooming itself as part of the cycle
/obj/structure/flora/tree/sakura/proc/start_blossom()
	var/turf/T = get_turf(src)
	if(!blossom_effect)
		// Spawns blossom effect
		blossom_effect = new(T)
		blossom_effect.parent_tree = src
		// Start the timer to remove the blossom effect after 15 minutes
		timer_handle_end = addtimer(CALLBACK(src, PROC_REF(end_blossom)), BLOSSOM_END_TIME, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_STOPPABLE)

/// Ends blooming, starts timer for a new one
/obj/structure/flora/tree/sakura/proc/end_blossom()
	if(blossom_effect)
		// Deletes blossom effect
		QDEL_NULL(blossom_effect)
		// Restart cycle
		initiate_blossom_cycle()

/* Effects */
/obj/effect/blossom
	name = "blossom"
	desc = "It's sakura fubuki."
	icon = 'modular_ss220/objects/icons/flora/sakura.dmi'
	icon_state = "blossom_less"
	layer = 12
	pixel_x = -16
	pixel_y = 10
	var/obj/structure/flora/tree/sakura/parent_tree

/obj/effect/blossom/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(make_sakura_leaves)), LEAVES_PILE_SPAWN_TIME, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_STOPPABLE)

/obj/effect/blossom/New(turf, obj/structure/flora/tree/sakura/Sakura)
	..()
	if(Sakura && istype(Sakura))
		parent_tree = Sakura

/obj/effect/blossom/Destroy()
	if(parent_tree == null)
		qdel(src)
	return ..()

/// Spawns pile of sakura leaves under sakura tree
/obj/effect/blossom/proc/make_sakura_leaves()
	var/turf/T = get_turf(src)
	if(locate(/obj/effect/decal/sakura_leaves, T))
		return
	if(!istype(T, /turf/simulated/floor/grass/sakura))
		if(parent_tree)
			new /obj/effect/decal/sakura_leaves(T, src)
			addtimer(CALLBACK(src, PROC_REF(transform_turf)), TRANSFORM_TURF_TIME, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_STOPPABLE)

/// Transforms grass tile to sakura grass under blossom effect
/obj/effect/blossom/proc/transform_turf()
	var/turf/T = get_turf(src)
	if(istype(T, /turf/simulated/floor/grass/sakura))
		return
	if(istype(T, /turf/simulated/floor/grass))
		T.ChangeTurf(/turf/simulated/floor/grass/sakura)
		// Delete sakura leaves pile
		for(var/obj/effect/decal/sakura_leaves/D in T)
			qdel(D)

/// Sakura Leaves
/obj/effect/decal/sakura_leaves
	name = "pile of sakura leaves"
	desc = "It's fallen sakura leaves."
	icon = 'modular_ss220/objects/icons/flora/sakura.dmi'
	icon_state = "leaves"
	pixel_y = 5
	max_integrity = 50
	resistance_flags = FLAMMABLE
	layer = 11
	plane = -1
	no_scoop = TRUE
	no_clear = TRUE
	// Is leaves on fire?
	var/on_fire = FALSE

/obj/effect/decal/sakura_leaves/New()
	. = ..()
	update_icon_state()

/obj/effect/decal/sakura_leaves/examine(mob/user)
	. = ..()
	if(on_fire)
		. += span_danger("[src] is on fire!")

/obj/effect/decal/sakura_leaves/update_icon_state()
	. = ..()
	var/turf/T = get_turf(src)
	for(var/obj/structure/flora/tree/sakura/sakura in T)
		if(sakura.icon_state == "cherry_blossom")
			pixel_x = -2
			dir = EAST
		if(sakura.icon_state == "cherry_blossom2")
			pixel_x = 2
			dir = EAST
		if(sakura.icon_state == "cherry_blossom3")
			pixel_x = -7

/obj/effect/decal/sakura_leaves/attackby(obj/item/I, mob/user)
	if(I.get_heat() && !on_fire)
		visible_message(span_danger("[src] bursts into flames!"))
		fire_act()
	if(istype(I, /obj/item/cultivator))
		var/obj/item/cultivator/C = I
		user.visible_message(span_notice("[user] is clearing [src] from the ground..."), span_notice("You begin clearing [src] from the ground..."), span_warning("You hear a sound of leaves rustling."))
		playsound(loc, 'sound/effects/shovel_dig.ogg', 50, 1)
		if(!do_after(user, 50 * C.toolspeed, target = src))
			return
		user.visible_message(span_notice("[user] clears [src] from the ground!"), span_notice("You clear [src] from the ground!"))
		qdel(src)
	else
		return ..()

/obj/effect/decal/sakura_leaves/fire_act()
	if(resistance_flags & FLAMMABLE)
		on_fire = TRUE
		add_overlay(custom_fire_overlay ? custom_fire_overlay : GLOB.fire_overlay)
		addtimer(CALLBACK(src, PROC_REF(delete_decal)), 5 SECONDS)

/obj/effect/decal/sakura_leaves/proc/delete_decal()
	cut_overlays()
	qdel(src)

/* Sakura Floor */
/// Sakura grass
/turf/simulated/floor/grass/sakura
	name = "sakura grass"
	icon = 'modular_ss220/objects/icons/flora/sakura_grass.dmi'
	icon_state = "grass"
	base_icon_state = "grass"
	smoothing_groups = list(SMOOTH_GROUP_TURF, SMOOTH_GROUP_GRASS, SMOOTH_GROUP_JUNGLE_GRASS)

/turf/simulated/floor/grass/sakura/no_creep
	smoothing_flags = null
	smoothing_groups = null
	canSmoothWith = null
	layer = GRASS_UNDER_LAYER
	transform = null

/turf/simulated/floor/grass/sakura/break_tile()
	. = ..()
	icon_state = "damaged"

/turf/simulated/floor/grass/sakura/burn_tile()
	. = ..()
	icon_state = "damaged"

#undef BLOSSOM_START_TIME
#undef BLOSSOM_END_TIME
#undef LEAVES_PILE_SPAWN_TIME
#undef TRANSFORM_TURF_TIME
