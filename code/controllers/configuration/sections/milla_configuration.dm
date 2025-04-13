/datum/configuration_section/milla_configuration
	/// # List of CPU cores to use for atmos ticks. Consider empty list to use all cores.
	var/list/cpu_cores = list()

	var/error_message = null

/datum/configuration_section/milla_configuration/load_data(list/data)
	CONFIG_LOAD_LIST(cpu_cores, data["cpu_cores"])

/datum/configuration_section/milla_configuration/vv_edit_var(var_name, var_value)
	if(var_name == "cpu_cores")
		return FALSE
	. = ..()

/datum/configuration_section/milla_configuration/proc/validate_cpu_cores()
	if(!length(cpu_cores))
		return

	var/list/available_cores = list()
	get_available_cpu_cores(available_cores)
	if(!length(available_cores))
		error_message = "MILLA could not retrieve the list of available CPU cores"
		return

	var/list/invalid_cores = list()
	for(var/core in cpu_cores)
		if(!(core in available_cores))
			invalid_cores += core

	if(length(invalid_cores))
		error_message = "MILLA could not find [english_list(invalid_cores)] among the available CPU cores ([english_list(available_cores)])"
