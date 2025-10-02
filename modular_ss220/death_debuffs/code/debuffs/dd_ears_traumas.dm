/datum/death_debuff/ears/destruction
	name = "разрушение нервного узла"
	reagent_list = list(/datum/reagent/medicine/oculine,/datum/reagent/medicine/mannitol)
	applied_text = "Вы осознаете, что полностью потеряли слух."
	removed_text = "До вас начинают доносится какие-то звуки."

/datum/death_debuff/ears/destruction/dd_effect()
	. = ..()
	var/obj/item/organ/organ = H.get_organ_slot(affected_zone)
	if(!organ)
		return

	//Накладывает эффект глухоты
	organ.status |= ORGAN_DEAD

/datum/death_debuff/ears/mailfuction
	name = "кровоизлияние барабанной перепонки"
	reagent_list = list(/datum/reagent/medicine/oculine,/datum/reagent/medicine/heal_on_apply/styptic_powder)
	applied_text = "Вам становится чуть теплее в районе уха и его пронзает острая боль."
	removed_text = "Боль в районе уха отступила."

/datum/death_debuff/ears/mailfuction/dd_effect()
	. = ..()
	var/obj/item/organ/organ = H.get_organ_slot(affected_zone)
	if(!organ)
		return

	//Накладывает эффект глухоты
	if(prob(10))
		H.Deaf(state*0.1 SECONDS)
		H.KnockDown(state*0.05 SECONDS)

