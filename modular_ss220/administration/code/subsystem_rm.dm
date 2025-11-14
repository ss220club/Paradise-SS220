GLOBAL_DATUM_INIT(round_master, /datum/round_master, new)

/datum/round_master
	/// Stores ref to current round master's client
	var/client/current_master
	/// Notify admins with this sound when master is updated
	var/sound/admin_notify_sound = 'sound/effects/adminhelp.ogg'

/datum/round_master/proc/is_master(client/to_check)
	return current_master == to_check

/datum/round_master/proc/set_master(client/new_master)
	if(!current_master)
		play_sound_to_admins(admin_notify_sound)
		message_admins("[key_name_admin(current_master)] стал мастером раунда.")
		log_admin("[key_name_admin(current_master)] стал мастером раунда.")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Make Round Master")

	if(current_master && !is_master(new_master))
		to_chat(src, span_boldannounceooc("[key_name(new_master)] перенял у тебя роль мастера раунда."))
		log_admin("[key_name(new_master)] перенял у тебя роль мастера раунда [key_name(current_master)].")
		message_admins("[key_name_admin(new_master)] перенял у тебя роль мастера раунда [key_name_admin(current_master)].")
		play_sound_to_admins(admin_notify_sound)

	current_master = new_master
	play_sound_to_admins(admin_notify_sound)
	message_admins("[key_name_admin(current_master)] стал мастером раунда.")
	log_admin("[key_name_admin(current_master)] стал мастером раунда.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Make Round Master")

/datum/round_master/proc/clear_master(client/clear_master)
	if(!current_master)
		return

	if(current_master != clear_master)
		to_chat(src, span_boldannounceooc("Ты не являешься мастером раунда."))
		return
	play_sound_to_admins(admin_notify_sound)
	message_admins("[key_name_admin(current_master)] больше не мастер раунда.")
	log_admin("[key_name(current_master)] снял с себя звание мастера раунда.")
	current_master = null
