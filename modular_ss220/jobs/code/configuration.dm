/datum/configuration_section/job_configuration_restriction
	var/list/blacklist_species = list()
	var/enable_black_list = FALSE

/datum/server_configuration
	var/datum/configuration_section/job_configuration_restriction/jobs_restrict

/datum/configuration_section/job_configuration_restriction/load_data(list/data)
	CONFIG_LOAD_BOOL(enable_black_list, data["allow_to_ban_job_for_species"])
	CONFIG_LOAD_LIST(blacklist_species, data["job_species_blacklist"])

/datum/configuration_section/job_configuration_restriction/proc/sanitize_job_checks()
	if(!SSjobs)
		return

	var/list/name_list = list()
	for(var/job_info in blacklist_species)
		name_list += job_info["name"]

	var/list/all_jobs = SSjobs.name_occupations
	for(var/check_job in all_jobs)
		if(check_job in name_list)
			continue
		else
			CRASH("[check_job] job not found in config block job_configuration_restriction")

/datum/server_configuration/load_all_sections()
	. = ..()
	jobs_restrict = new()
	safe_load(jobs_restrict, "job_configuration_restriction")
