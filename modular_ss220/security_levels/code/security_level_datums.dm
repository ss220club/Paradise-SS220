/**
 * VIOLET
 *
 * Medical threat
 */
/datum/security_level/violet
	name = "violet"
	number_level = SEC_LEVEL_VIOLET
	elevating_to_sound = 'sound/misc/notice1.ogg'
	ai_announcement_sound = 'sound/AI/blue.ogg' // TODO: to update
	color = "darkviolet"
	lowering_to_announcement_title = "ВНИМАНИЕ! Уровень угрозы понижен до ФИОЛЕТОВОГО."
	lowering_to_announcement_text = "В настоящее время действуют процедуры Фиолетового кода. Медицинский персонал должен получить распоряжения от руководителя отдела. Немедицинский персонал обязан выполнять все соответствующие инструкции медицинского персонала."
	elevating_to_announcement_title = "Внимание! Уровень угрозы повышен до ФИОЛЕТОВОГО."
	elevating_to_announcement_text = "Возникла серьезная медицинская угроза экипажу станции. Медицинский персонал должен получить распоряжения от руководителя отдела. Немедицинский персонал обязан выполнять все соответствующие инструкции медицинского персонала."

/**
 * ORANGE
 *
 * Engineering emergency
 */
/datum/security_level/orange
	name = "orange"
	number_level = SEC_LEVEL_ORANGE
	elevating_to_sound = 'sound/misc/notice1.ogg'
	ai_announcement_sound = 'sound/AI/blue.ogg' // TODO: to update
	color = "gold"
	lowering_to_announcement_title = "ВНИМАНИЕ! Уровень угрозы понижен до ОРАНЖЕВОГО."
	lowering_to_announcement_text = "В настоящее время действуют процедуры Оранжевого кода. Инженерный персонал должен получить распоряжения от руководителя отдела. Неинженерный персонал обязан покинуть аварийные помещения и выполнять все соответствующие инструкции инженерного персонала."
	elevating_to_announcement_title = "Внимание! Уровень угрозы повышен до ОРАНЖЕВОГО."
	elevating_to_announcement_text = "Произошла серьезная техническая авария. Инженерный персонал должен получить распоряжения от руководителя отдела. Неинженерный персонал обязан покинуть аварийные помещения и выполнять все соответствующие инструкции инженерного персонала."

/datum/security_level/orange/pre_change()
	for(var/obj/machinery/door/airlock/D in GLOB.airlocks)
		if(is_station_level(D.z))
			D.emergency_handling = TRUE
