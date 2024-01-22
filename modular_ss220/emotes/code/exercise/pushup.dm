/*
Verbs related to getting fucking jacked, bro
Порт и небольшой рефактор с дополнениями отжиманий с CM + прикручивание зависимости от часов
*/

/datum/emote/pushup
	key = "pushup"
	key_third_person = "pushups"
	//message = "пытается отжаться!"
	hands_use_check = TRUE
	emote_type = EMOTE_VISIBLE | EMOTE_FORCE_NO_RUNECHAT // Don't need an emote to see that
	mob_type_allowed_typecache = list(/mob/living, /mob/dead/observer)
	mob_type_blacklist_typecache = list(/mob/living/brain, /mob/camera, /mob/living/silicon/ai)
	mob_type_ignore_stat_typecache = list(/mob/dead/observer)
	cooldown = 3 SECONDS

/datum/emote/pushup/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return FALSE
	. = TRUE

	if(!isliving(user))
		return
	var/mob/living/L = user
	if(L.getStaminaLoss() > 0)
		to_chat(user, span_warning("Вы уставший! Передохните."))
		return
	if(L.incapacitated())
		return
	if(!L.resting || L.buckled)
		to_chat(user, span_warning("Вы не в том положении для отжиманий! Лягте на пол!"))
		return
	if(!isturf(user.loc))
		to_chat(user, span_warning("Не на что опереться!"))
		return

	user.visible_message(span_notice("[user] принял упор лежа."), span_notice("Вы приняли упор лежа."), span_notice("Вы слышите шорох."))

	var/list/choice_dict = list()
	var/list/pushup_list = subtypesof(/datum/pushup)
	for(var/i in pushup_list)
		var/datum/pushup/pushup = i
		if(!ishuman(user) && !initial(pushup.can_non_humans_do))
			continue
		choice_dict.Add(list("[initial(pushup.name)]" = pushup))

	var/choice = tgui_input_list(user, "Отжимание с каким упором?", "Отжимания", choice_dict, 60 SECONDS)

	if(choice)
		var/pushup_type = choice_dict[choice]
		var/datum/pushup/pushup = new pushup_type(src, user)
		var/temp_message = pushup.is_bold_message ? span_boldnotice("[pushup.message]") : span_notice("[pushup.message]")
		var/temp_self_message = pushup.is_bold_message ? span_boldnotice("[pushup.self_message]") : span_notice("[pushup.self_message]")
		var/temp_blind_message = "[pushup.blind_message]"
		user.visible_message(temp_message, temp_self_message, temp_blind_message)
		pushup.volume = get_volume(user)
		pushup.intentional = intentional
		pushup.try_execute()

