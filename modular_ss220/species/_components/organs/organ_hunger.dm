/*
Компонент на органы для работы с запасами химикатов
*/

/datum/component/hunger_organ
	var/obj/item/organ/internal/organ
	var/consuption_count = 0

/datum/component/hunger_organ/Initialize(reagent_id)
	organ = parent

/datum/component/hunger_organ/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ORGAN_ON_LIFE, PROC_REF(hunger_process))
	RegisterSignal(parent, COMSIG_ORGAN_CHANGE_CHEM_CONSUPTION, PROC_REF(hunger_change_consuption))

/datum/component/hunger_organ/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_ORGAN_ON_LIFE)
	UnregisterSignal(parent, COMSIG_ORGAN_CHANGE_CHEM_CONSUPTION)

/datum/component/hunger_organ/proc/hunger_process(holder)
	SIGNAL_HANDLER
	if(isnull(organ.owner))
		return TRUE
	//var/chemical_volume = organ.owner?.get_chemical_value(chemical_id)
	if(organ.owner.nutrition < consuption_count)
		//Если количества недостаточно - выключить режим
		organ.switch_mode(force_off = TRUE)
	else
		if(consuption_count)
			organ.owner.adjust_nutrition(consuption_count)

/datum/component/hunger_organ/proc/hunger_change_consuption(holder, new_consuption_count)
	SIGNAL_HANDLER
	consuption_count = new_consuption_count

//Переписываемый прок, который вызывается когда заканчивается запас химического препарата
/obj/item/organ/internal/proc/switch_mode(force_off = FALSE)
	return
