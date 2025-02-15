#define DD_BASIC_PROGRESS_FACTOR 0.2
#define DD_BASIC_CHEMICAL_FACTOR 0.3
#define DD_BASIC_HEALING_CHEM_FACTOR 0.3
#define DD_BASIC_HEALING_MED_FACTOR 0.2
#define DD_BASIC_HEALING_CARE_FACTOR 0.2
#define DD_BASIC_HEALING_SLEEP_FACTOR 0.1
#define DD_BASIC_STATE 100
#define COMSIG_BRAIN_UNDEBUFFED  "brain_undebuffed"

/datum/death_debuff
	var/name = "basic death debuff"
	var/state = DD_BASIC_STATE
	var/list/datum/reagent/reagent_list = list(/datum/reagent/msg)
	var/affected_zone = "brain"
	var/scanned_zone = "мозг"
	var/mob/living/carbon/human/H
	var/applied_text = ""
	var/removed_text = ""
	var/healing_chemical_factor = DD_BASIC_HEALING_CHEM_FACTOR
	var/healing_medical_factor = DD_BASIC_HEALING_MED_FACTOR
	var/healing_care_factor = DD_BASIC_HEALING_CARE_FACTOR
	var/healing_sleep_factor = DD_BASIC_HEALING_SLEEP_FACTOR
	var/progress_speed = DD_BASIC_PROGRESS_FACTOR

/datum/death_debuff/process()
	dd_effect()

/datum/death_debuff/proc/dd_effect()
	if(!H)
		remove_debuff()
		return

	threatment()
	state = clamp(state, 0, initial(state))
	if(state == 0)
		remove_debuff()
		return

/datum/death_debuff/proc/threatment()
	var/healing_factor = threatment_chemical() ? healing_chemical_factor : 0
	healing_factor += threatment_medical() ? healing_medical_factor : 0
	healing_factor += threatment_rest() ? healing_sleep_factor : 0
	//Добавить механизм нарастания эффекта, если игрок движется вне медицинского блока ходит
	if(danger_condition())
		state += progress_speed
	else
		state -= healing_factor

/datum/death_debuff/proc/danger_condition()
	var/area/area = get_area(H)
	if(istype(area, /area/station/medical))
		return FALSE

	var/result = (world.time - H.last_movement < 10)
	return result

/datum/death_debuff/proc/threatment_chemical()
	var/reagent_count = 0
	for(var/datum/reagent/R in H.reagents.reagent_list)
		if(R in reagent_list)
			reagent_count++

	return (length(reagent_list) == reagent_count)

/datum/death_debuff/proc/threatment_medical()
	var/obj/buckled_object = H.buckled
	if(buckled_object)
		var/area/area = get_area(buckled_object)
		if(istype(area, /area/station/medical))
			return TRUE

	return FALSE

/datum/death_debuff/proc/threatment_care(nurse_person)
	if(threatment_medical())
		state -= healing_care_factor
		to_chat(H, span_notice("[nurse_person] ухаживает за вами, и Вы начинаете чувствовать себя чуть лучше"))

/datum/death_debuff/proc/threatment_rest()
	var/resting_in_med = threatment_medical() && threatment_chemical() && H.IsSleeping()
	return resting_in_med

/datum/death_debuff/proc/apply_debuff(mob/living/carbon/human/victim, income_state = 100)
	H = victim
	state = income_state
	to_chat(H, span_notice(applied_text))
	H.throw_alert("death_debuff", /atom/movable/screen/alert/death_debuff)
	START_PROCESSING(SSfastprocess, src)

/datum/death_debuff/proc/remove_debuff()
	state = 0
	var/obj/item/organ/internal/brain/brain_item = H.get_int_organ_tag("brain")
	to_chat(H, span_notice(removed_text))
	H.clear_alert("death_debuff")
	H = null
	SEND_SIGNAL(brain_item, COMSIG_BRAIN_UNDEBUFFED, src)
	STOP_PROCESSING(SSfastprocess, src)
	qdel(src)

/datum/death_debuff/proc/get_adv_analyzer_info()
	var/description = "Внимание! Обнаружено: [name]! Зона поражения: "
	switch(affected_zone)
		if("l_arm")
			description += "левая рука"
		if("r_arm")
			description += "правая рука"
		if("l_leg")
			description += "левая нога"
		if("r_leg")
			description += "правая нога"
		else
			description += scanned_zone

	description += "\n Лечение: "

	var/reagents_string
	for(var/type in reagent_list)
		var/datum/reagent/temp_reagent = new type
		if(reagents_string)
			reagents_string += ", "
		reagents_string += temp_reagent.name
		qdel(temp_reagent)
	description += reagents_string

	var/progress = ((initial(state) - state)/initial(state)) * 100
	description += "\n Прогресс лечения: [progress]%"
	return description

#undef DD_BASIC_HEALING_CHEM_FACTOR
#undef DD_BASIC_HEALING_MED_FACTOR
#undef DD_BASIC_HEALING_CARE_FACTOR
#undef DD_BASIC_HEALING_SLEEP_FACTOR
#undef DD_BASIC_PROGRESS_FACTOR
#undef DD_BASIC_STATE

/atom/movable/screen/alert/death_debuff
	icon = 'icons/mob/screen_alert.dmi'
	name = "Слабость в теле."
	desc = "Вы чувствуете слабость в теле."
	icon_state = "weaken"

/atom/movable/screen/alert/death_debuff/Click()
	if(isliving(usr) && ..())
		to_chat(usr, span_notice("Вы чувствуете сильную слабость в своем теле. Возможно стоит обратиться за медицинской помощью."))
