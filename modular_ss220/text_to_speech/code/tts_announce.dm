/datum/announcement_configuration
	var/tts_seed

/datum/announcement_configuration/requests_console
	tts_seed = /datum/tts_seed/silero/glados

/datum/announcement_configuration/comms_console
	tts_seed = /datum/tts_seed/silero/glados

/datum/announcement_configuration/ai
	tts_seed = /datum/tts_seed/silero/glados

/datum/announcer/Message(message, garbled_message, receivers, garbled_receivers)
	if(!config.tts_seed)
		return ..()
	var/message_tts = message
	var/garbled_message_tts = garbled_message
	message = replace_characters(message, list("+"))
	garbled_message = replace_characters(garbled_message, list("+"))
	. = ..()

	//TODO: Change tts_seed when AI changes their tts_seed
	for(var/mob/living/silicon/ai/ai in GLOB.ai_list)
		if(ai.name == author)
			config.tts_seed = ai.get_tts_seed()
			break

	for(var/mob/M in receivers)
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(tts_cast), null, M, message_tts, config.tts_seed, FALSE, SOUND_EFFECT_NONE, TTS_TRAIT_RATE_MEDIUM)
	for(var/mob/M in garbled_receivers)
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(tts_cast), null, M, garbled_message_tts, config.tts_seed, FALSE, SOUND_EFFECT_NONE, TTS_TRAIT_RATE_MEDIUM)
