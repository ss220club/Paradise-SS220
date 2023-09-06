/datum/server_configuration/load_configuration()
	. = ..()
	gateway = new()

/datum/server_configuration/load_all_sections()
	. = ..()
	safe_load(gateway, "gateway_configuration")

/* Config holder for all gateway related things */
/datum/configuration_section/gateway_configuration
	/// Do we want to enable away missions or not
	var/enable_away_mission = TRUE
	/// Delay (in deciseconds) before the gateway is usable
	var/away_mission_delay = 0
	/// List of all available away missions
	var/list/enabled_away_missions = list()

/datum/configuration_section/gateway_configuration/load_data(list/data)
	// Use the load wrappers here. That way the default isnt made 'null' if you comment out the config line
	CONFIG_LOAD_BOOL(enable_away_mission, data["enable_away_mission"])
	CONFIG_LOAD_NUM(away_mission_delay, data["away_mission_delay"])
	CONFIG_LOAD_LIST(enabled_away_missions, data["enabled_away_missions"])

/datum/controller/subsystem/mapping/Initialize()
	. = ..()
	// Pick a random away mission.
	if(GLOB.configuration.gateway.enable_away_mission)
		load_away_mission()
	else
		log_startup_progress("Skipping away mission...")

/datum/controller/subsystem/mapping/proc/load_away_mission()
	if(length(GLOB.configuration.gateway.enabled_away_missions))
		var/watch = start_watch()
		log_startup_progress("Loading away mission...")

		var/map = pick(GLOB.configuration.gateway.enabled_away_missions)
		var/file = wrap_file(map)
		if(isfile(file))
			var/zlev = GLOB.space_manager.add_new_zlevel(AWAY_MISSION, linkage = UNAFFECTED, traits = list(AWAY_LEVEL,BLOCK_TELEPORT))
			GLOB.space_manager.add_dirt(zlev)
			GLOB.maploader.load_map(file, z_offset = zlev)
			late_setup_level(block(locate(1, 1, zlev), locate(world.maxx, world.maxy, zlev)))
			GLOB.space_manager.remove_dirt(zlev)
			log_world("Away mission loaded: [map]")

		log_startup_progress("Away mission loaded in [stop_watch(watch)]s.")

	else
		log_startup_progress("No away missions found.")
		return
