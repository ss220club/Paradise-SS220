/datum/configuration_section/job_configuration
    var/list/blacklist_species = list()

/datum/configuration_section/job_configuration/load_data(list/data)
    . = .. ()
    CONFIG_LOAD_LIST(blacklist_species, data["job_spieces_blacklist"])
