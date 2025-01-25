/datum/security_level
	/// Tells if every crew member will be allowed to talk on the common frequency.
	var/grants_common_channel_access = FALSE

/datum/security_level/gamma
	grants_common_channel_access = TRUE

/datum/security_level/epsilon
	grants_common_channel_access = TRUE

/datum/security_level/delta
	grants_common_channel_access = TRUE

/datum/controller/subsystem/security_level/announce_security_level(datum/security_level/selected_level)
	var/message
	var/title
	var/sound
	var/sound2 = selected_level.ai_announcement_sound

	if(selected_level.number_level > current_security_level.number_level)
		message = selected_level.elevating_to_announcement_text
		title =	selected_level.elevating_to_announcement_title
		sound =	selected_level.elevating_to_sound
	else
		message = selected_level.lowering_to_announcement_text
		title =	selected_level.lowering_to_announcement_title
		sound =	selected_level.lowering_to_sound
	
	if(selected_level.grants_common_channel_access && !current_security_level.grants_common_channel_access)
		message += " Ограничения на пользование общим каналом связи сняты."
	else if(!selected_level.grants_common_channel_access && current_security_level.grants_common_channel_access)
		message += " Ограничения на пользование общим каналом связи восстановлены."

	GLOB.security_announcement.Announce(message, title, new_sound = sound, new_sound2 = sound2)
