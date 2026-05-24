/datum/server_configuration
	/// Holder for the gateway configuration datum
	var/datum/configuration_section/species_ban_configuration/species_ban

/datum/server_configuration/load_all_sections()
	. = ..()
	species_ban = new()
	safe_load(species_ban, "species_ban_configuration")

/datum/configuration_section/species_ban_configuration
	var/species_bans_enabled = FALSE
	/// List of species that are banned by default for new players
	var/list/default_species_bans = list()

/datum/configuration_section/species_ban_configuration/load_data(list/data)
	CONFIG_LOAD_BOOL(species_bans_enabled, data["species_bans_enabled"])
	CONFIG_LOAD_LIST(default_species_bans, data["default_species_bans"])
