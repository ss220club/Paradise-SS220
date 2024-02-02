/datum/component/tts_component
	var/tts_seed

/datum/component/tts_component/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_CHANGE_TTS_SEED, PROC_REF(change_tts_seed))

/datum/component/tts_component/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_ATOM_CHANGE_TTS_SEED)

/datum/component/tts_component/Initialize(new_tts_seed)
	. = ..()
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	tts_seed = new_tts_seed

/datum/component/tts_component/proc/select_tts_seed(mob/chooser, silent_target = FALSE, override = FALSE, fancy_voice_input_tgui = FALSE)
	if(!chooser)
		if(ismob(parent))
			chooser = parent
		else
			return null

	var/atom/being_changed = parent
	var/static/tts_test_str = "Так звучит мой голос."
	var/new_tts_seed

	if(chooser == being_changed)
		var/datum/character_save/active_character = chooser.client?.prefs.active_character
		if(being_changed.gender == active_character.gender)
			if(alert(chooser, "Оставляем голос вашего персонажа [active_character.real_name] - [active_character.tts_seed]?", "Выбор голоса", "Нет", "Да") ==  "Да")
				new_tts_seed = active_character.tts_seed
				INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(tts_cast), null, chooser, tts_test_str, new_tts_seed, FALSE)
				return new_tts_seed

	var/tts_seeds
	var/tts_gender = get_converted_tts_seed_gender(being_changed.gender)
	var/list/tts_seeds_by_gender = SStts220.tts_seeds_by_gender[tts_gender]
	if(check_rights(R_ADMIN, FALSE, chooser) || override || !ismob(being_changed))
		tts_seeds = tts_seeds_by_gender
	else
		tts_seeds = tts_seeds_by_gender && SStts220.get_available_seeds(being_changed) // && for lists means intersection

	if(fancy_voice_input_tgui)
		new_tts_seed = tgui_input_list(chooser, "Выберите голос персонажа", "Преобразуем голос", tts_seeds)
	else
		new_tts_seed = input(chooser, "Выберите голос персонажа", "Преобразуем голос") as null|anything in tts_seeds

	if(!new_tts_seed)
		to_chat(chooser, span_warning("Что-то пошло не так с выбором голоса. Текущий голос - [tts_seed]"))
		return null

	if(!silent_target && being_changed != chooser && ismob(being_changed))
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(tts_cast), null, being_changed, tts_test_str, new_tts_seed, FALSE)

	if(chooser)
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(tts_cast), null, chooser, tts_test_str, new_tts_seed, FALSE)

	return new_tts_seed

/datum/component/tts_component/proc/change_tts_seed(mob/chooser, override = FALSE, fancy_voice_input_tgui = FALSE)
	SIGNAL_HANDLER
	//set waitfor = FALSE
	var/new_tts_seed = select_tts_seed(chooser = chooser, override = override, fancy_voice_input_tgui = fancy_voice_input_tgui)
	if(!new_tts_seed)
		return null
	return update_tts_seed(new_tts_seed)

/datum/component/tts_component/proc/update_tts_seed(new_tts_seed)
	tts_seed = new_tts_seed
	return new_tts_seed

/datum/component/tts_component/proc/get_converted_tts_seed_gender(gender_to_convert = gender)
	switch(gender_to_convert)
		if(MALE)
			return TTS_GENDER_MALE
		if(FEMALE)
			return TTS_GENDER_FEMALE
		else
			return TTS_GENDER_ANY

/atom/proc/change_tts_seed(mob/chooser, override, fancy_voice_input_tgui)
	SEND_SIGNAL(src, COMSIG_ATOM_CHANGE_TTS_SEED, chooser, override, fancy_voice_input_tgui)

/datum/component/tts_component/proc/pick_tts_seed_gender()
	var/tts_gender = get_converted_tts_seed_gender()
	return pick(SStts220.tts_seeds_by_gender[tts_gender])

/datum/component/tts_component/proc/get_random_tts_seed_gender()
	var/tts_choice = pick_tts_seed_gender(gender)
	var/datum/tts_seed/seed = SStts220.tts_seeds[tts_choice]
	if(!seed)
		return null
	return seed.name

/atom/proc/pick_tts_seed_gender()
	var/tts_gender = get_converted_tts_seed_gender()
	return pick(SStts220.tts_seeds_by_gender[tts_gender])

/atom/proc/get_random_tts_seed_gender()
	var/tts_choice = pick_tts_seed_gender(gender)
	var/datum/tts_seed/seed = SStts220.tts_seeds[tts_choice]
	if(!seed)
		return null
	return seed.name

/client/create_response_team_part_1(new_gender, new_species, role, turf/spawn_location)
	. = ..()
	var/mob/living/ert_member = .
	ert_member.change_tts_seed(src.mob)

/mob/living/silicon/verb/synth_change_voice()
	set name = "Смена голоса"
	set desc = "Express yourself!"
	set category = "Подсистемы"
	change_tts_seed(src, fancy_voice_input_tgui = TRUE)
