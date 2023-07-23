/mob/living/Life(seconds, times_fired)
	SEND_SIGNAL(src, COMSIG_LIVING_LIFE, seconds, times_fired)
	. = ..()

/mob/living/carbon/human/handle_critical_condition()
	if(status_flags & GODMODE)
		return FALSE
	SEND_SIGNAL(src, COMSIG_LIVING_HANDLE_CRITICAL_CONDITION)
	. = ..()
	if(owner.health <= HEALTH_THRESHOLD_CRIT)
		AddComponent(/datum/component/softcrit)

/mob/living/carbon/human/check_death_method()
	return FALSE

// No messages when in Crit

/mob/living/handle_message_mode(message_mode, list/message_pieces, verb, used_radios)
	if(SEND_SIGNAL(src, COMSIG_LIVING_HANDLE_MESSAGE_MODE) & COMPONENT_FORCE_WHISPER)
		whisper_say(message_pieces)
		return TRUE
	. = ..()

/mob/living/carbon/human/handle_message_mode(message_mode, list/message_pieces, verb, used_radios)
	if(SEND_SIGNAL(src, COMSIG_LIVING_HANDLE_MESSAGE_MODE) & COMPONENT_FORCE_WHISPER)
		whisper_say(message_pieces)
		return TRUE
	. = ..()
