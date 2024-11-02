/atom/proc/add_tts_component()
	return

/atom/Initialize(mapload, ...)
	. = ..()
	add_tts_component()

/atom/proc/cast_tts(mob/listener, message, atom/location, is_local = TRUE, effect = SOUND_EFFECT_NONE, traits = TTS_TRAIT_RATE_FASTER, preSFX, postSFX)
	SHOULD_CALL_PARENT(TRUE)
	if(SEND_SIGNAL(src, COMSIG_ATOM_PRE_TTS_CAST, listener, message, location, is_local, effect, traits, preSFX, postSFX) & COMPONENT_TTS_INTERRUPT)
		return
	SEND_SIGNAL(src, COMSIG_ATOM_TTS_CAST, listener, message, location, is_local, effect, traits, preSFX, postSFX)

// TODO: Do it better?
/atom/proc/get_tts_seed()
	var/datum/component/tts_component/tts_component = GetComponent(/datum/component/tts_component)
	if(tts_component)
		return tts_component.tts_seed

/atom/proc/change_tts_seed(mob/chooser, override, fancy_voice_input_tgui = FALSE, list/new_traits = null)
	if(!get_tts_seed())
		if(alert(chooser, "Отсутствует TTS компонент. Создать?", "Изменение TTS", "Да", "Нет") == "Нет")
			return
		AddComponent(/datum/component/tts_component, /datum/tts_seed/silero/angel)
	SEND_SIGNAL(src, COMSIG_ATOM_TTS_SEED_CHANGE, chooser, override, fancy_voice_input_tgui, new_traits)

/atom/proc/tts_trait_add(trait)
	SEND_SIGNAL(src, COMSIG_ATOM_TTS_TRAIT_ADD, trait)

/atom/proc/tts_trait_remove(trait)
	SEND_SIGNAL(src, COMSIG_ATOM_TTS_TRAIT_REMOVE, trait)

/mob/add_language(language, force)
	. = ..()
	if(language == "Nabberian")
		var/atom/A = src
		RegisterSignal(A, COMSIG_ATOM_PRE_TTS_CAST, PROC_REF(atom_pre_tts_cast_mob))

/mob/remove_language(rem_language, force)
	. = ..()
	if(rem_language == "Nabberian")
		var/atom/A = src
		UnregisterSignal(A, COMSIG_ATOM_PRE_TTS_CAST)

/mob/proc/atom_pre_tts_cast_mob(atom, listener, message, location, is_local, effect, traits, preSFX, postSFX)
	SIGNAL_HANDLER
	var/processed = FALSE
	for(var/datum/multilingual_say_piece/phrase in message)
		if(istype(phrase.speaking,/datum/language/serpentid))
			processed = TRUE
	return processed ? COMPONENT_TTS_INTERRUPT : processed
