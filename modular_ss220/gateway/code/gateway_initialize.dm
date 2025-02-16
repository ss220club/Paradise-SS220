/datum/controller/subsystem/mapping/Initialize()
	. = ..()
	// Pick a random away mission.
	if(GLOB.configuration.gateway.enable_away_mission)
		load_away_mission()
	else
		log_startup_progress("Skipping away mission...")

/datum/controller/subsystem/mapping/proc/load_away_mission()
	if(!length(GLOB.configuration.gateway.enabled_away_missions))
		log_startup_progress("No away missions found.")
		return

	var/watch = start_watch()
	log_startup_progress("Loading away mission...")

	var/map = pick(GLOB.configuration.gateway.enabled_away_missions)
	var/file = wrap_file(map)
	if(!isfile(file))
		log_startup_progress("Picked away mission doesnt exist.")
		return

	var/zlev = GLOB.space_manager.add_new_zlevel(AWAY_MISSION, linkage = UNAFFECTED, traits = list(AWAY_LEVEL, BLOCK_TELEPORT))
	GLOB.space_manager.add_dirt(zlev)
	GLOB.maploader.load_map(file, z_offset = zlev)
	var/datum/milla_safe_must_sleep/late_setup_level/milla = new()
	milla.invoke_async(block(locate(1, 1, zlev), locate(world.maxx, world.maxy, zlev)))
	GLOB.space_manager.remove_dirt(zlev)
	log_world("Away mission loaded: [map]")

	log_startup_progress("Away mission loaded in [stop_watch(watch)]s.")
	seed_away_mission_salvage(levels_by_trait(AWAY_LEVEL))

/datum/controller/subsystem/mapping/proc/seed_away_mission_salvage(away_mission)
	log_startup_progress("Seeding gateway salvage...")
	var/gateway_salvage_timer = start_watch()
	var/seeded_salvage_surfaces = list()
	var/seeded_salvage_closets = list()

	var/list/small_salvage_items = list(
		/obj/item/salvage/ruin/brick,
		/obj/item/salvage/ruin/nanotrasen,
		/obj/item/salvage/ruin/carp,
		/obj/item/salvage/ruin/tablet,
		/obj/item/salvage/ruin/pirate,
		/obj/item/salvage/ruin/soviet
	)

	for(var/z_level in away_mission)
		var/list/turf/z_level_turfs = block(1, 1, z_level, world.maxx, world.maxy, z_level)
		for(var/z_level_turf in z_level_turfs)
			var/turf/T = z_level_turf
			var/area/A = get_area(T)
			if(istype(A, /area/awaymission))
				var/list/closet_blacklist = list(/obj/structure/closet/cardboard, /obj/structure/closet/fireaxecabinet, /obj/structure/closet/walllocker/emerglocker, /obj/structure/closet/crate/can, /obj/structure/closet/body_bag, /obj/structure/closet/coffin)
				for(var/obj/structure/closet/closet in T)
					if(is_type_in_list(closet, closet_blacklist))
						continue

					seeded_salvage_closets |= closet
				for(var/obj/structure/table/table in T)
					if(locate(/obj/machinery) in T)
						continue // Machinery on tables tend to take up all the visible space
					if(table.flipped)
						continue // Looks very silly
					seeded_salvage_surfaces |= table
				for(var/obj/structure/rack/rack in T)
					seeded_salvage_surfaces |= rack

	var/max_salvage_attempts = rand(20, 30)
	while(max_salvage_attempts > 0 && length(seeded_salvage_closets) > 0)
		var/obj/structure/closet/C = pick_n_take(seeded_salvage_closets)
		var/salvage_item_type = pick(small_salvage_items)
		var/obj/salvage_item = new salvage_item_type(C)
		salvage_item.scatter_atom()
		max_salvage_attempts -= 1

	max_salvage_attempts = rand(20, 30)
	while(max_salvage_attempts > 0 && length(seeded_salvage_surfaces) > 0)
		var/obj/T = pick_n_take(seeded_salvage_surfaces)
		var/salvage_item_type = pick(small_salvage_items)
		var/obj/salvage_item = new salvage_item_type(T.loc)
		salvage_item.scatter_atom()
		max_salvage_attempts -= 1

	log_startup_progress("Successfully seeded gateway salvage in [stop_watch(gateway_salvage_timer)]s.")
