/datum/death_debuff/head/trauma
	name = "мозговая травма"
	reagent_list = list(/datum/chemical_reaction/mannitol,/datum/chemical_reaction/osseous_reagent)
	applied_text = "Вашу голову пронзила резкая, давящая боль."
	removed_text = "Боль в голове постепенно отступила."

/datum/death_debuff/head/trauma/dd_effect()
	. = ..()
	var/obj/item/organ/organ = H.get_limb_by_name(affected_zone)
	if(!organ)
		return

	//Накладывает эффект дееспособности на конечность (считается словно ампутированная)
	if(H.stat != DEAD)
		H.adjustBrainLoss(0.02)
