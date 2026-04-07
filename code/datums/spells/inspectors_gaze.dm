/datum/spell/inspectors_gaze
	name = "Inspector's Gaze"
	desc = "Дайте экипажу узнать, что за ними наблюдают и контролируют."
	base_cooldown = 6 SECONDS
	clothes_req = FALSE
	selection_activated_message		= "<span class='notice'>Вы ищете члена экипажа для проверки! <b> Щелкните левой кнопкой мыши, чтобы посмотреть на цель.</b></span>"
	selection_deactivated_message	= "<span class='notice'>Ты отводишь свой взгляд... на время.</span>"
	action_icon_state = "genetic_view"

/datum/spell/inspectors_gaze/create_new_targeting()
	var/datum/spell_targeting/clicked_atom/external/C = new()
	C.range = 10
	return C

/datum/spell/inspectors_gaze/cast(list/targets, mob/living/user = usr)
	var/mob/target = targets[1] // There is only ever one target for your gaze
	if(!istype(target))
		to_chat(user, "<span class='warning'>Вы не думаете, что [target.declent_ru(GENITIVE)] может нарушить СРП.</span>")
		return FALSE
	to_chat(target, "<span class='warning'>Вы чувствуете, что кто-то пристально смотрит за вами...</span>")
	to_chat(user, "<span class='notice'>Вы смотрите на [target.declent_ru(GENITIVE)] с намерением найти нарушения СРП.</span>")

	return TRUE
