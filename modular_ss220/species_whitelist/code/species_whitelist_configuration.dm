/datum/server_configuration
	/// Holder for the gateway configuration datum
	var/datum/configuration_section/species_whitelist_configuration/species_whitelist

/datum/server_configuration/load_all_sections()
	. = ..()
	species_whitelist = new()
	safe_load(species_whitelist, "species_whitelist_configuration")

/datum/configuration_section/species_whitelist_configuration
	var/species_whitelist_enabled = FALSE
	/// List of species that are banned by default for new players
	var/list/default_species_bans = list()

/datum/configuration_section/species_whitelist_configuration/load_data(list/data)
	CONFIG_LOAD_BOOL(species_whitelist_enabled, data["species_whitelist_enabled"])
	CONFIG_LOAD_LIST(default_species_bans, data["default_species_bans"])
