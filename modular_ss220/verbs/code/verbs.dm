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
