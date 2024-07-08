#define DATA_HUD_TREACHEOUS_FLESH 24

/datum/modpack/lazarus
	name = "Эвент «Проект Лазарь»"
	desc = "Глобально изменяет геймплей, превращая игру в мультиплеерный survival-horror"
	author = "ThaumicNik"

/datum/modpack/lazarus/initialize()
	GLOB.huds += new /datum/atom_hud/treacherous_flesh()
