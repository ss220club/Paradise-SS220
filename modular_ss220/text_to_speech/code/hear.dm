GLOBAL_DATUM_INIT(default_announcer, /datum/tts_seed, new /datum/tts_seed/silero/glados)

/mob/combine_message(list/message_pieces, verb, mob/speaker, always_stars)
	. = ..()
	return replace_characters(., list("+"))

/mob/hear_say(list/message_pieces, verb, italics, mob/speaker, sound/speech_sound, sound_vol, sound_frequency, use_voice)
	. = ..()
	speaker.cast_tts(src, message_pieces)

/mob/hear_radio(list/message_pieces, verb, part_a, part_b, mob/speaker, hard_to_hear = 0, vname, atom/follow_target, check_name_against)
	. = ..()
	if(hard_to_hear)
		return
	speaker.cast_tts(src, message_pieces, src, FALSE, SOUND_EFFECT_RADIO, postSFX = 'modular_ss220/text_to_speech/code/sound/radio_chatter.ogg')

/mob/hear_holopad_talk(list/message_pieces, verb, mob/speaker, obj/effect/overlay/holo_pad_hologram/H)
	. = ..()
	speaker.cast_tts(src, message_pieces, H, TRUE, SOUND_EFFECT_RADIO)

/datum/announcer/Message(message, garbled_message, receivers, garbled_receivers)
	var/datum/tts_seed/tts_seed = SStts220.tts_seeds[GLOB.default_announcer.name]
	if(GLOB.ai_list.len)
		var/mob/living/silicon/ai/AI = pick(GLOB.ai_list)
		tts_seed = AI.get_tts_seed()
	var/message_tts = message
	var/garbled_message_tts = garbled_message
	message = replace_characters(message, list("+"))
	garbled_message = replace_characters(garbled_message, list("+"))
	. = ..()
	for(var/mob/M in receivers)
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(tts_cast), null, M, message_tts, tts_seed, FALSE, SOUND_EFFECT_NONE, TTS_TRAIT_RATE_MEDIUM)
	for(var/mob/M in garbled_receivers)
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(tts_cast), null, M, garbled_message_tts, tts_seed, FALSE, SOUND_EFFECT_NONE, TTS_TRAIT_RATE_MEDIUM)

/atom/atom_say(message)
	. = ..()
	if(!message)
		return
	for(var/mob/M in get_mobs_in_view(7, src))
		cast_tts(M, message)
