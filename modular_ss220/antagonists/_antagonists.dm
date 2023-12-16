/datum/modpack/antagonists
	name = "Антагонисты и режимы"
	desc = "Добавляет новые режимы и антагонистов."
	author = "Gaxeer, dj-34"

/datum/modpack/antagonists/initialize()
	GLOB.special_roles |= ROLE_BLOOD_BROTHER
	GLOB.huds += new/datum/atom_hud/antag/hidden()
	//GLOB.special_roles |= ROLE_VOX_RAIDERS
	
	
// #define ANTAG_HUD_RAIDER 22
// #define SPECIAL_ROLE_RAIDER "Vox Raider"
// #define ROLE_RAIDER "vox raider"