/datum/modpack/lazarus
	name = "Глобальный эвент «Комплекс Лазарь»"
	desc = "Глобально изменяет геймплей, превращая игру в мультиплеерный survival-horror"
	author = "ThaumicNik"

/datum/modpack/antagonists/initialize()
	GLOB.special_roles |= ROLE_BLOOD_BROTHER
	GLOB.huds += new/datum/atom_hud/antag/hidden()
