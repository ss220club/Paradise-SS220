/datum/death_debuff/lungs/failure
	name = "повреждение альвеол"
	reagent_list = list(/datum/reagent/medicine/perfluorodecalin,/datum/reagent/medicine/salglu_solution)
	applied_text = "Вам трудно дышать, вы жадно хватаете ртом воздух."
	removed_text = "Ваше дыхание приходит в норму."

/datum/death_debuff/lungs/failure/dd_effect()
	. = ..()
	var/obj/item/organ/organ = H.get_organ_slot(affected_zone)
	if(!organ)
		return

	//Легкие плохо работают и в итоге персонаж испытывает удушье
	if(prob(50) && H.stat != DEAD)
		H.adjustOxyLoss(state * 0.1)

/datum/death_debuff/lungs/mailfunction
	name = "переохлаждение легких"
	reagent_list = list(/datum/reagent/medicine/teporone,/datum/reagent/medicine/heal_on_apply/silver_sulfadiazine)
	applied_text = "Вы чувствуете холод в своих легких, который неприятно распротраняется по всему телу."
	removed_text = "Похоже, озноб отступил."

/datum/death_debuff/lungs/mailfunction/dd_effect()
	. = ..()
	var/obj/item/organ/organ = H.get_organ_slot(affected_zone)
	if(!organ)
		return

	//Легкие переохлаждены и снижают температуру тела владельца
	organ.owner.bodytemperature -= 0.05 * state
