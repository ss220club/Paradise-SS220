/datum/death_debuff/liver/failure
	name = "отказ печени"
	reagent_list = list(/datum/reagent/medicine/potass_iodide)
	applied_text = "Ваше тело пронзает резкая боль в районе печени."
	removed_text = "Боль в районе печени отступила."

/datum/death_debuff/liver/failure/dd_effect()
	. = ..()
	var/obj/item/organ/organ = H.get_organ_slot(affected_zone)
	if(!organ)
		return

	//Печень отмирает и начинает выбрасывать по 2 токсина в тело
	organ.status |= ORGAN_DEAD
	if(prob(33) && H.stat != DEAD)
		H.adjustToxLoss(0.25)

/datum/death_debuff/liver/mailfunction
	name = "нарушение обмена веществ"
	reagent_list = list(/datum/reagent/medicine/charcoal)
	applied_text = "Вы внезапно испытываете дикий, почти непреодолимый голод."
	removed_text = "Похоже, ваше чувство насыщения вернулось."

/datum/death_debuff/liver/mailfunction/dd_effect()
	. = ..()
	var/obj/item/organ/organ = H.get_organ_slot(affected_zone)
	if(!organ)
		return

	//Печень сбоит и повышает уровень голода жертвы
	organ.owner.physiology.hunger_mod = state * 0.1 * initial(organ.owner.physiology.hunger_mod)

/datum/death_debuff/liver/mailfunction/remove_debuff()
	var/obj/item/organ/organ = H.get_organ_slot(affected_zone)
	if(!organ)
		organ.owner.physiology.hunger_mod = initial(organ.owner.physiology.hunger_mod)
	. = ..()
