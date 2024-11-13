/datum/death_debuff/eyes/destruction
	name = "повреждение затылочной доли"
	reagent_list = list(/datum/reagent/medicine/oculine,/datum/reagent/medicine/salglu_solution)
	applied_text = "Вы осознаете, что полностью потеряли зрение."
	removed_text = "Пелена на глазах отступает."

/datum/death_debuff/eyes/destruction/dd_effect()
	. = ..()
	var/obj/item/organ/organ = H.get_organ_slot(affected_zone)
	if(!organ)
		return

	//Накладывает эффект полной слепоты
	organ.status |= ORGAN_DEAD

/datum/death_debuff/eyes/mailfuction
	name = "травма зрительного нерва"
	reagent_list = list(/datum/reagent/medicine/oculine,/datum/reagent/medicine/heal_on_apply/silver_sulfadiazine)
	applied_text = "Глаза пронзает резкая боль, все кажется слишком ярким."
	removed_text = "Похоже что резь в глазах от яркого света отступила."

/datum/death_debuff/eyes/mailfuction/dd_effect()
	. = ..()
	var/obj/item/organ/internal/eyes/organ = H.get_organ_slot(affected_zone)
	if(!organ)
		return

	//Накладывает кратковременный эффект слепоты и размытия, повышает чувствительной глаз
	organ.flash_protect = FLASH_PROTECTION_VERYVUNERABLE
	if(prob(10))
		H.SetEyeBlurry(state*0.1 SECONDS)
		H.SetEyeBlind(state*0.01 SECONDS)

/datum/death_debuff/eyes/mailfuction/remove_debuff()
	var/obj/item/organ/internal/eyes/organ = H.get_organ_slot(affected_zone)
	if(!organ)
		organ.flash_protect = initial(organ.flash_protect)
	. = ..()
