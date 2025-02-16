/datum/death_debuff/weakness
	name = "трасущиеся руки"
	reagent_list = list(/datum/reagent/medicine/salglu_solution,/datum/reagent/medicine/sanguine_reagent)
	affected_zone = "chest"
	scanned_zone = "тело"
	applied_text = "Вы чувствуете общую слабость в теле."
	removed_text = "Вы чувствуете, как ваша тело пришло в норму."

/datum/death_debuff/weakness/apply_debuff()
	var/obj/item/organ/organ = H.get_limb_by_name(affected_zone)
	if(!organ)
		return

	ADD_TRAIT(H, TRAIT_HANDS_WEAKNESS, "death_debuff")
	ADD_TRAIT(H, TRAIT_GOTTAGOSLOW, "death_debuff")

/datum/death_debuff/weakness/apply_debuff()
	REMOVE_TRAIT(H, TRAIT_HANDS_WEAKNESS, "death_debuff")
	REMOVE_TRAIT(H, TRAIT_GOTTAGOSLOW, "death_debuff")

