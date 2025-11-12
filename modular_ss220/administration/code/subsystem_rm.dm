SUBSYSTEM_DEF(round_master)
	name = "Round Master"
	priority = FIRE_PRIORITY_DEFAULT
	runlevels = RUNLEVEL_GAME
	flags = SS_NO_FIRE
	var/current_master
	var/sound/admin_notify_sound = 'sound/effects/adminhelp.ogg'

	var/took = "стал мастером раунда."
	var/seized_you = "перенял у тебя роль мастера раунда."
	var/seized_it = "перенял роль мастера раунда у"
	var/quit_self = "больше не мастер раунда."
	var/quit_himself = "снял с себя звание мастера раунда."

//datum/controller/subsystem/round_master/has_master()
//	return !!current_master

/datum/controller/subsystem/round_master/proc/is_master(client/to_check)
	if(current_master)
		return current_master == to_check

/datum/controller/subsystem/round_master/proc/set_master(client/set_m)
	if(!current_master)
		current_master = set_m
		play_sound_to_admins(admin_notify_sound)
		message_admins("[key_name_admin(current_master)] " + took)
		log_admin("[key_name_admin(current_master)] " + took)
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Make Round Master")
		return

	if(current_master && current_master != set_m)
		to_chat(src, SPAN_BOLDOOC("[key_name(set_m)] " + seized_you))
		log_admin("[key_name(set_m)] " + seized_it + " [key_name(current_master)].")
		message_admins("[key_name_admin(set_m)] " + seized_it + " [key_name_admin(current_master)].")
		play_sound_to_admins(admin_notify_sound)

	current_master = set_m
	play_sound_to_admins(admin_notify_sound)
	message_admins("[key_name_admin(current_master)] " + took)
	log_admin("[key_name_admin(current_master)] " + took)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Make Round Master")

/datum/controller/subsystem/round_master/proc/clear_master(client/clear_m)
	if(!current_master)
		return
	if(current_master == clear_m)
		play_sound_to_admins(admin_notify_sound)
		message_admins("[key_name_admin(current_master)] " + quit_self)
		log_admin("[key_name(current_master)] " + quit_himself)
		current_master = null
		return
	else
		to_chat(src, SPAN_BOLDOOC("Ты не являешься мастером раунда."))
		return

/datum/controller/subsystem/round_master/Initialize()
	current_master = null
	SSblackbox.record_feedback("system", "round_master_init", 1, "Round Master subsystem initialized.")
	return
