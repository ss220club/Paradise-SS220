/datum/species/moth/spec_Process_Spacemove(mob/living/carbon/human/H)
	. = ..()
	if(has_gravity(H))
		return FALSE
