GLOBAL_DATUM_INIT(default_announcer, /datum/tts_seed, new /datum/tts_seed/silero/glados)

/mob/proc/combine_message_tts(list/message_pieces, mob/speaker, always_stars = FALSE)
	var/iteration_count = 0
	var/msg = ""
	for(var/datum/multilingual_say_piece/say_piece in message_pieces)
		iteration_count++
		var/piece = say_piece.message
		if(piece == "")
			continue

		if(say_piece.speaking?.flags & INNATE) // TTS should not read emotes like "laughts"
			return ""

		if(always_stars)
			continue

		if(iteration_count == 1)
			piece = capitalize(piece)

		if(!say_understands(speaker, say_piece.speaking))
			if(isanimal(speaker))
				var/mob/living/simple_animal/S = speaker
				if(!LAZYLEN(S.speak))
					continue
				piece = pick(S.speak)
			else if(say_piece.speaking)
				piece = say_piece.speaking.scramble(piece)
			else
				continue
		msg += (piece + " ")
	return trim(msg)

/mob/combine_message(list/message_pieces, verb, mob/speaker, always_stars)
	. = ..()
	return replace_characters(., list("+"))

/mob/hear_say(list/message_pieces, verb, italics, mob/speaker, sound/speech_sound, sound_vol, sound_frequency, use_voice)
	. = ..()
	if(!client)
		return
	if(!can_hear())
		return

	var/message_tts = combine_message_tts(message_pieces, speaker)
	SEND_SIGNAL(speaker, COMSIG_ATOM_TTS_CAST, src, message_tts, speaker, TRUE)

/mob/hear_radio(list/message_pieces, verb = "says", part_a, part_b, mob/speaker = null, hard_to_hear = 0, vname = "", atom/follow_target, check_name_against)
	. = ..()
	if(!client)
		return
	if(!can_hear())
		return

	if(src != speaker || isrobot(src) || isAI(src))
		var/message_tts = combine_message_tts(message_pieces, speaker, always_stars = hard_to_hear)
		var/postSFX = 'modular_ss220/text_to_speech/code/sound/radio_chatter.ogg'
		SEND_SIGNAL(speaker, COMSIG_ATOM_TTS_CAST, src, message_tts, src, FALSE, SOUND_EFFECT_RADIO, null, null, postSFX)

/mob/hear_holopad_talk(list/message_pieces, verb, mob/speaker, obj/effect/overlay/holo_pad_hologram/H)
	. = ..()
	if(!client)
		return
	if(!can_hear())
		return
	var/message_tts = combine_message_tts(message_pieces, speaker)
	SEND_SIGNAL(speaker, COMSIG_ATOM_TTS_CAST, src, message_tts, H, TRUE, SOUND_EFFECT_RADIO)

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
		if(!M.client)
			continue
		SEND_SIGNAL(src, COMSIG_ATOM_TTS_CAST, M, message, src)
