/*
Расширение на органы для работы с запасами химикатов
*/

/obj/item/organ/internal
	var/chemical_consuption = 0
	var/can_chem_process = FALSE
	var/chemical_id = ""

/obj/item/organ/internal/process()
	. = ..()
	if (can_chem_process)
		chems_process()

/obj/item/organ/internal/proc/chems_process()
	if(isnull(owner))
		return TRUE
	var/chemical_volume = owner.get_chemical_value(chemical_id)
	var/datum/reagent/chemical = owner.get_chemical_path(chemical_id)
	if (chemical_volume < chemical_consuption)
		//Если количества недостаточно - выключить режим
		switch_mode(force_off = TRUE)
	else
		if(!isnull(chemical) && chemical_consuption > 0)
			chemical.holder.remove_reagent(chemical_id, chemical_consuption)

//Переписываемый прок, который вызывается когда заканчивается запас химического препарата
/obj/item/organ/internal/proc/switch_mode(var/force_off = FALSE)
	return

//Пара помощников - получить количество и путь химиката по его ID
/mob/living/carbon/human/proc/get_chemical_value(var/id)
	for(var/datum/reagent/R in src.reagents.reagent_list)
		if (R.id == id)
			return R.volume
	return 0

/mob/living/carbon/human/proc/get_chemical_path(var/id)
	for(var/datum/reagent/R in src.reagents.reagent_list)
		if (R.id == id)
			return R
	return null
