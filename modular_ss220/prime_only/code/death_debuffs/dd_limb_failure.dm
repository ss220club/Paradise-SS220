/datum/death_debuff/shaking_hands
	name = "трасущиеся руки"
	reagent_list = list(/datum/reagent/medicine/salglu_solution,/datum/reagent/medicine/sanguine_reagent)
	affected_zone = "l_arm"
	applied_text = "Ваша левая рука едва-заметно трясется"
	removed_text = "Вы чувствуете, как ваша левая рука пришла в норму."

/datum/death_debuff/shaking_hands/r_arm
	affected_zone = "r_arm"
	applied_text = "Ваша правая рука едва-заметно трясется"
	removed_text = "Вы чувствуете, как ваша правая рука пришла в норму."

/datum/death_debuff/shaking_hands/dd_effect()
	. = ..()
	var/obj/item/organ/organ = H.get_limb_by_name(affected_zone)
	if(!organ)
		return

	//Накладывает эффект дееспособности на конечность (считается словно ампутированная)
	var/chance_drop = clamp(state,30,100)
	if(prob(chance_drop))
		var/arm_slot = (affected_zone == "r_arm" ? SLOT_HUD_RIGHT_HAND : SLOT_HUD_LEFT_HAND)
		var/obj/item/arm_item = organ.owner.get_item_by_slot(arm_slot)
		organ.owner.unEquip(arm_item)

/datum/death_debuff/muscular_weakness
	name = "мышечная слабость"
	reagent_list = list(/datum/reagent/medicine/salglu_solution,/datum/reagent/medicine/osseous_reagent)
	affected_zone = "l_leg"
	applied_text = "Ваша левая нога испытывает слабость и едва вас держит."
	removed_text = "Вы чувствуете, как ваша левая нога пришла в норму."

/datum/death_debuff/muscular_weakness/r_leg
	affected_zone = "r_leg"
	applied_text = "Ваша правая нога испытывает слабость и едва вас держит."
	removed_text = "Вы чувствуете, как ваша правая нога пришла в норму."

/datum/death_debuff/muscular_weakness/dd_effect()
	. = ..()
	var/obj/item/organ/organ = H.get_limb_by_name(affected_zone)
	if(!organ)
		return

	//Накладывает эффект дееспособности на конечность (считается словно ампутированная)
	var/chance_drop = clamp(state*2,15,50)
	if(prob(chance_drop))
		H.KnockDown(2 SECONDS)
