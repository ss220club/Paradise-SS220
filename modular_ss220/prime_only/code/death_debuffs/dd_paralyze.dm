/datum/death_debuff/paralyze
	name = "паралич конечности"
	reagent_list = list(/datum/reagent/medicine/mannitol,/datum/reagent/medicine/mitocholide)
	affected_zone = "l_arm"
	applied_text = "Вы понимаете, что с вашей левой рукой что-то не так и она почти безжизненно болтается."
	removed_text = "Похоже, ваша левая рука снова в норме."

/datum/death_debuff/paralyze/r_arm
	affected_zone = "r_arm"
	applied_text = "Вы понимаете, что с вашей правой рукой что-то не так и она почти безжизненно болтается."
	removed_text = "Похоже, ваша правая рука снова в норме."

/datum/death_debuff/paralyze/r_leg
	affected_zone = "r_leg"
	applied_text = "Вы понимаете, что с вашей левой ногой что-то не так и она почти безжизненно болтается."
	removed_text = "Похоже, ваша левая нога снова в норме."

/datum/death_debuff/paralyze/l_leg
	affected_zone = "l_leg"
	applied_text = "Вы понимаете, что с вашей правой ногой что-то не так и она почти безжизненно болтается."
	removed_text = "Похоже, ваша правая нога снова в норме."

/datum/death_debuff/paralyze/dd_effect()
	. = ..()
	var/obj/item/organ/external/organ = H.get_limb_by_name(affected_zone)
	if(!organ)
		return

	//Накладывает эффект дееспособности на конечность (считается словно ампутированная)
	organ.paralyzed = TRUE
	organ.children[1].paralyzed = TRUE

/datum/death_debuff/paralyze/remove_debuff()
	var/obj/item/organ/external/organ = H.get_limb_by_name(affected_zone)
	if(organ)
		organ.paralyzed = FALSE
		organ.children[1].paralyzed = FALSE
	. = ..()


/obj/item/organ/external
	var/paralyzed = FALSE

/obj/item/organ/external/is_malfunctioning()
	if(paralyzed)
		return TRUE
	. = ..()
