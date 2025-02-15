/datum/death_debuff/heart/failure
	name = "прогрессирующий инфаркт"
	reagent_list = list(/datum/reagent/medicine/mitocholide,/datum/reagent/medicine/epinephrine)
	applied_text = "Ваше сердце пронзает резкая боль, и кажется, она становится только сильнее."
	removed_text = "Боль в сердце отступила."

/datum/death_debuff/heart/failure/dd_effect()
	. = ..()
	var/obj/item/organ/organ = H.get_organ_slot(affected_zone)
	if(!organ)
		return

	//Сердце бьется неровно и вот-вот будет инфаркт
	var/datum/disease/critical/heart_failure/CA
	if(!(H.HasDisease(/datum/disease/critical/heart_failure)) && H.stat != DEAD)
		CA = new /datum/disease/critical/heart_failure
		H.ForceContractDisease(CA)

/datum/death_debuff/heart/mailfunction
	name = "брадикардия"
	reagent_list = list(/datum/reagent/medicine/mitocholide,/datum/reagent/medicine/ephedrine)
	applied_text = "Ваше сердце издает медленное, успокаивающее биение, и силы покидают вас."
	removed_text = "Вы снова чувствуете прилив сил."

/datum/death_debuff/heart/mailfunction/dd_effect()
	. = ..()
	var/obj/item/organ/organ = H.get_organ_slot(affected_zone)
	if(!organ)
		return

	//Сердце медленно бьется и пациент испытывает слабость
	if(H.stat != DEAD)
		H.adjustStaminaLoss(state * 0.5)
