/datum/controller/subsystem/security_level/Initialize()
	var/list/sorted_levels = list()
	for(var/security_level_type in subtypesof(/datum/security_level))
		var/datum/security_level/new_level = new security_level_type
		sorted_levels[list("number" = num2text(new_level.number_level, 1), "level" = new_level)] = null // this shit adds list to a list
	sorted_levels = sortByKey(sorted_levels, "number")

	SSsecurity_level.available_levels.Cut();
	for(var/security_level_entry in sorted_levels)
		var/datum/security_level/level = security_level_entry["level"]
		SSsecurity_level.available_levels[level.name] = level

	return ..()
