/datum/spell/inspectors_gaze
	name = "Inspector's Gaze"
	desc = "Дайте экипажу узнать, что за ними наблюдают и контролируют."
	base_cooldown = 6 SECONDS
	clothes_req = FALSE
	selection_activated_message		= SPAN_NOTICE("Вы ищете члена экипажа для проверки. <b>Щелкните левой кнопкой мыши, чтобы направить свой взор на цель.</b>")
	selection_deactivated_message	= SPAN_NOTICE("Вы отводите свой взгляд... на время.")
	action_icon_state = "genetic_view"

/datum/spell/inspectors_gaze/create_new_targeting()
	var/datum/spell_targeting/clicked_atom/external/C = new()
	C.range = 10
	return C

/datum/spell/inspectors_gaze/cast(list/targets, mob/living/user = usr)
	var/mob/target = targets[1] // There is only ever one target for your gaze
	if(!istype(target))
		to_chat(user, SPAN_WARNING("Вы не думаете, что [target.declent_ru(NOMINATIVE)] может нарушить СРП."))
		return FALSE
	to_chat(target, SPAN_WARNING("Вы чувствуете, что кто-то пристально смотрит за вами..."))
	to_chat(user, SPAN_NOTICE("Вы смотрите на [target.declent_ru(ACCUSATIVE)] с намерением найти нарушения СРП."))

	return TRUE
