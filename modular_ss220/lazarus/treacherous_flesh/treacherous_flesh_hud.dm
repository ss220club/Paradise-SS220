// Why not /datum/atom_hud/antag?
// We need to save antag hud unchanged in case if treacherous flesh will spawn in round of cult, for example.

/datum/atom_hud/treacherous_flesh
	hud_icons = list(TREACHEOUS_FLESH_HUD)

/mob/living/carbon/human/Initialize(mapload, datum/species/new_species)
	hud_possible.Add(TREACHEOUS_FLESH_HUD)
	. = ..()
