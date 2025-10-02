/datum/death_debuff/spazms
	name = "спазм"
	reagent_list = list(/datum/reagent/medicine/diphenhydramine,/datum/reagent/medicine/sal_acid)
	affected_zone = "head"
	applied_text = "Вашу голову пронзает резкая, пульсирующая боль."
	removed_text = "Пульсирующая боль в вашей голове отступила."

/datum/death_debuff/spazms/r_arm
	affected_zone = "l_arm"
	applied_text = "Вашу левую руку пронзает резкая, пульсирующая боль."
	removed_text = "Пульсирующая боль в вашей левой руке отступила."

/datum/death_debuff/spazms/r_arm
	affected_zone = "r_arm"
	applied_text = "Вашу правую руку пронзает резкая, пульсирующая боль."
	removed_text = "Пульсирующая боль в вашей правой руке отступила."

/datum/death_debuff/spazms/r_leg
	affected_zone = "r_leg"
	applied_text = "Вашу левую ногу пронзает резкая, пульсирующая боль."
	removed_text = "Пульсирующая боль в вашей левой ноге отступила."

/datum/death_debuff/spazms/l_leg
	affected_zone = "l_leg"
	applied_text = "Вашу правую ногу пронзает резкая, пульсирующая боль."
	removed_text = "Пульсирующая боль в вашей правой ноге отступила."

/datum/death_debuff/spazms/dd_effect()
	. = ..()
	var/obj/item/organ/organ = H.get_limb_by_name(affected_zone)
	if(!organ)
		return

	//Накладывает эффект спазма на конечность
	if(prob(state))
		if(affected_zone == "r_arm" || affected_zone == "l_arm")
			if(prob(15))
				var/arm_slot = (affected_zone == "r_arm" ? SLOT_HUD_RIGHT_HAND : SLOT_HUD_LEFT_HAND)
				var/obj/item/arm_item = organ.owner.get_item_by_slot(arm_slot)
				organ.owner.unEquip(arm_item)
		else if(affected_zone == "r_leg" || affected_zone == "l_leg")
			if(prob(10))
				H.KnockDown(0.5 SECONDS)
		else
			if(prob(33))
				H.Weaken(10 SECONDS)
