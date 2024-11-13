/datum/death_debuff/kidneys/failure
	name = "отказ почек"
	reagent_list = list(/datum/reagent/medicine/pen_acid)
	applied_text = "Вы чувствуете резь в районе чуть ниже спины."
	removed_text = "Боль чуть ниже спины отступает."

/datum/death_debuff/kidneys/failure/dd_effect()
	. = ..()
	var/obj/item/organ/organ = H.get_organ_slot(affected_zone)
	if(!organ)
		return

	//Почки начинают выбрасывать в организм токсины, в зависимости от силы дебаффа
	organ.status |= ORGAN_DEAD
	if(prob(50) && H.stat != DEAD)
		H.adjustToxLoss(state * 0.001)

/datum/death_debuff/kidneys/mailfunction
	name = "почечная недостаточность"
	reagent_list = list(/datum/reagent/medicine/calomel)
	applied_text = "Вы чувствуете легкий дискомфорт где-то в нижней части спины."
	removed_text = "Ощущения в нижней части спины пришли в норму, и больше не приносят дискомфорт."

/datum/death_debuff/kidneys/mailfunction/dd_effect()
	. = ..()
	var/obj/item/organ/organ = H.get_organ_slot(affected_zone)
	if(!organ)
		return

	//При употреблении пищи, почки вырабаьывают гистамин
	for(var/datum/reagent/consumable/chemical in H.reagents.reagent_list)
		if(!isnull(chemical))
			H.reagents.add_reagent("histamine", state * 0.01 * chemical.nutriment_factor)
