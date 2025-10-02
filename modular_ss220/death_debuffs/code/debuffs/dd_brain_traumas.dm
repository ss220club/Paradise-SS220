/datum/death_debuff/brain/hallucination
	name = "посттравматическое стрессовое расстройство"
	reagent_list = list(/datum/reagent/medicine/mannitol,/datum/reagent/medicine/sterilizine)
	applied_text = "Вы начинаете видеть необычные вещи."
	removed_text = "Похоже призраки прошлого решили оставить вас."

/datum/death_debuff/brain/hallucination/dd_effect()
	. = ..()
	var/obj/item/organ/organ = H.get_organ_slot(affected_zone)
	if(!organ)
		return

	//Вызывает эффект галлюцинаций
	H.AdjustHallucinate(2 SECONDS)

/datum/death_debuff/brain/confusion
	name = "сильное сотрясение мозга"
	reagent_list = list(/datum/reagent/medicine/mannitol,/datum/reagent/medicine/omnizine)
	applied_text = "Либо вы, либо весь мир решил кружиться в вальсе."
	removed_text = "Вы снова нормально видите этот мир."

/datum/death_debuff/brain/confusion/dd_effect()
	. = ..()
	var/obj/item/organ/organ = H.get_organ_slot(affected_zone)
	if(!organ)
		return

	//Вызывает эффект пошатывания
	H.SetConfused(2 SECONDS)
