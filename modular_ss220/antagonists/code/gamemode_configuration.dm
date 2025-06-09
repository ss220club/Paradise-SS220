/datum/configuration_section/gamemode_configuration
	/// List of gamemodes that shouldn't be played for more than 1 round in a row.
	var/list/non_repeatable_gamemodes = list()

/datum/configuration_section/gamemode_configuration/load_data(list/data)
	..()
	CONFIG_LOAD_LIST(non_repeatable_gamemodes, data["non_repeatable_gamemodes"])
	validate()

/datum/configuration_section/gamemode_configuration/proc/validate()
	for(var/value in non_repeatable_gamemodes)
		if(!(value in gamemodes))
			stack_trace("Gamemode [value] is in [NAMEOF(src, non_repeatable_gamemodes)] but it doesn't exist!")
