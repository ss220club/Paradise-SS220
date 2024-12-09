/datum/configuration_section/job_configuration
	var/list/blacklist_species = list()
	var/enable_black_list = FALSE

/datum/configuration_section/job_configuration/load_data(list/data)
	. = .. ()
	CONFIG_LOAD_BOOL(enable_black_list, data["allow_to_ban_job_for_species"])
	CONFIG_LOAD_LIST(blacklist_species, data["job_species_blacklist"])
