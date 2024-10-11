/*
Компонент на органы для работы с запасами химикатов
*/

#define COMSIG_ORGAN_CHEM_CALL "chems_process"

/datum/component/chemistry_organ
	var/obj/item/organ/internal/organ
	var/chemical_id = ""

/datum/component/chemistry_organ/Initialize(var/reagent_id)
	..()
	organ = parent
	chemical_id = reagent_id

/datum/component/chemistry_organ/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ORGAN_CHEM_CALL, PROC_REF(chems_process))

/datum/component/chemistry_organ/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_ORGAN_CHEM_CALL)

/datum/component/chemistry_organ/proc/chems_process(var/holder, var/consuption_count)
	if(isnull(organ.owner))
		return TRUE
	var/chemical_volume = organ.owner.get_chemical_value(chemical_id)
	var/datum/reagent/chemical = organ.owner.get_chemical_path(chemical_id)
	if(chemical_volume < consuption_count || chemical_volume == 0)
		//Если количества недостаточно - выключить режим
		organ.switch_mode(force_off = TRUE)
	else
		if(!isnull(chemical) && consuption_count > 0)
			chemical.holder.remove_reagent(chemical_id, consuption_count)

//Переписываемый прок, который вызывается когда заканчивается запас химического препарата
/obj/item/organ/internal/proc/switch_mode(var/force_off = FALSE)
	return

//Пара помощников - получить количество и путь химиката по его ID
/mob/living/carbon/human/proc/get_chemical_value(var/id)
	for(var/datum/reagent/R in src.reagents.reagent_list)
		if(R.id == id)
			return R.volume
	return 0

/mob/living/carbon/human/proc/get_chemical_path(var/id)
	for(var/datum/reagent/R in src.reagents.reagent_list)
		if(R.id == id)
			return R
	return null
