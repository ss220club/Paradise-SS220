/*
	Respawn
	May be returned in the future by offs (because it's commented in code\modules\mob)
*/
/datum/configuration_section/ss220_misc_configuration
	/// Respawn delay in minutes before one may respawn as a crew member
	var/respawn_delay = 20

/datum/configuration_section/ss220_misc_configuration/load_data(list/data)
	. = ..()
	CONFIG_LOAD_NUM(respawn_delay, data["respawn_delay"])

/// Respawn verb
/mob/verb/abandon_mob()
	set name = "Respawn"
	set category = "OOC"

	if(!GLOB.configuration.general.respawn_enabled && !check_rights(R_ADMIN))
		to_chat(usr, span_warning("Respawning is disabled."))
		return

	if(stat != DEAD || !SSticker)
		to_chat(usr, span_boldnotice("You must be dead to use this!"))
		return

	var/deathtime = world.time - timeofdeath
	if(isobserver(src))
		var/mob/dead/observer/G = src
		if(!HAS_TRAIT(G, TRAIT_RESPAWNABLE) && !check_rights(R_ADMIN))
			to_chat(usr, span_warning("You currently do not have respawnability!"))
			return

	var/deathtimeminutes = round(deathtime / 600)
	var/pluralcheck = "minute"
	if(deathtimeminutes == 0)
		pluralcheck = ""
	else if(deathtimeminutes == 1)
		pluralcheck = "[deathtimeminutes] minute and"
	else if(deathtimeminutes > 1)
		pluralcheck = "[deathtimeminutes] minutes and"
	var/deathtimeseconds = round((deathtime - deathtimeminutes * 600) / 10,1)

	if(deathtimeminutes < GLOB.configuration.ss220_misc.respawn_delay && !check_rights(R_ADMIN))
		to_chat(usr, span_notice("You have been dead for[pluralcheck] [deathtimeseconds] second\s."))
		to_chat(usr, span_warning("You must wait [GLOB.configuration.ss220_misc.respawn_delay] minutes to respawn!"))
		return

	if(alert("Are you sure you want to respawn?", "Respawn", "Yes", "No") != "Yes")
		return

	log_game("[key_name(usr)] has respawned.")

	to_chat(usr, span_boldnotice("Make sure to play a different character, and please roleplay correctly!"))

	if(!client)
		log_game("[key_name(usr)] respawn failed due to disconnect.")
		return
	client.screen.Cut()
	client.screen += client.void

	if(!client)
		log_game("[key_name(usr)] respawn failed due to disconnect.")
		return

	var/mob/new_player/M = new /mob/new_player()
	if(!client)
		log_game("[key_name(usr)] respawn failed due to disconnect.")
		qdel(M)
		return

	M.key = key
	return

/// Pick darkness list
/mob/dead/observer/pick_darkness()
	set name = "Pick Darkness"
	set desc = "Choose how much darkness you want to see."
	set category = "Ghost"

	if(!client)
		return

	var/darkness_level = tgui_input_list(usr, "Choose your darkness", "Pick Darkness", list("Darkness", "Twilight", "Brightness", "Custom"))
	if(!darkness_level)
		return

	var/new_darkness
	switch(darkness_level)
		if("Darkness")
			new_darkness = 255
		if("Twilight")
			new_darkness = 210
		if("Brightness")
			new_darkness = 0
		if("Custom")
			new_darkness = input(usr, "Введите новое значение (0 - 255). Больше - темнее.", "Pick Darkness") as null|num

	if(isnull(new_darkness))
		return

	client.prefs.ghost_darkness_level = new_darkness
	client.prefs.save_preferences(src)
	lighting_alpha = client.prefs.ghost_darkness_level
	update_sight()

/mob/dead/observer/dead_tele()
	set category = "Ghost"
	set name = "Teleport"
	set desc= "Teleport to a location"

	if(!isobserver(usr))
		to_chat(usr, "Ты ещё не мёртв!")
		return

	var/target = tgui_input_list(usr, "Куда телепортируемся?", "Телепортация", SSmapping.ghostteleportlocs)
	teleport(SSmapping.ghostteleportlocs[target])
