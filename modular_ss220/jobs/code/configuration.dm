/datum/configuration_section/job_configuration
	var/list/blacklist_species = list()

/datum/configuration_section/job_configuration/load_data(list/data)
	. = .. ()
	if(data["allow_to_ban_job_for_species"])
		CONFIG_LOAD_LIST(blacklist_species, data["job_species_blacklist"])
