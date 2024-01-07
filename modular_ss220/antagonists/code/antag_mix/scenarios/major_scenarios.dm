/datum/antag_scenario/team/vox_raiders
	name = "Vox Raider"
	config_tag = "vox_raiders"
	abstract = FALSE
	antag_role = ROLE_VOX_RAIDER
	antag_special_role = SPECIAL_ROLE_VOX_RAIDER
	antag_datum = /datum/antagonist/vox_raider
	antag_team = /datum/team/vox_raiders_team
	required_players = 30
	cost = 30
	weight = 0.25
	antag_cap = 6
	candidates_required = 2
	team_size = 6

	is_crew_antag = FALSE
	landmark_type = /obj/effect/landmark/spawner/vox_raider
	possible_species = list("Vox")
	recommended_species_active_pref = list("Vox")
	recommended_species_mod = 3

/datum/antag_scenario/team/vox_raiders/equip_character(datum/mind/mind)
	mind.current.equipOutfit(/datum/outfit/vox)
	mind.current.faction = list("Vox")
	mind.offstation_role = TRUE




// !!!!!!!!! ВРЕМЯНКА ДЛЯ ТЕСТА
/datum/antag_scenario/team/vox_raiders/New()
	. = ..()
	required_players = 0

