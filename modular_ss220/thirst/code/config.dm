/datum/configuration_section/ss220_misc_configuration
	var/hydration_enabled = FALSE

/datum/configuration_section/ss220_misc_configuration/load_data(list/data)
	. = ..()
	CONFIG_LOAD_BOOL(hydration_enabled, data["hydration_enabled"])
