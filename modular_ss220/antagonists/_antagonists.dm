/datum/modpack/antagonists
	name = "Антагонисты и режимы"
	desc = "Добавляет новые режимы и антагонистов."
	author = "Gaxeer, dj-34, PhantomRU"

/datum/modpack/antagonists/initialize()
	GLOB.huds += new/datum/atom_hud/antag/hidden()
	GLOB.special_roles |= ROLE_BLOOD_BROTHER
	GLOB.special_roles |= ROLE_VOX_RAIDER
