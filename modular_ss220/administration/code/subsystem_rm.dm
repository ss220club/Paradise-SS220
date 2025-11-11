SUBSYSTEM_DEF(round_master)
	name = "Round Master"
	wait = 1
	priority = FIRE_PRIORITY_DEFAULT
	runlevels = RUNLEVEL_GAME
	flags = SS_NO_FIRE

	var/current_master = null

/datum/controller/subsystem/round_master/proc/has_master()
	return !!current_master

/datum/controller/subsystem/round_master/proc/is_master(client/C)
	if(!C) return FALSE
	return current_master == C

/datum/controller/subsystem/round_master/proc/set_master(client/C)
	if(!C) return FALSE

	if(current_master && current_master != C)
		to_chat(current_master, "<span class='boldannounceooc'>[key_name(C)] перенял у тебя роль мастера раунда.</span>")
		log_admin("[key_name(C)] перенял роль мастера раунда у [key_name(current_master)].")
		message_admins("[key_name_admin(C)] перенял роль мастера раунда у [key_name_admin(current_master)].")
		play_sound_to_admins('sound/effects/adminhelp.ogg')

	current_master = C
	world << "<b>[key_name(C)]</b> теперь мастер этого раунда!"
	play_sound_to_admins('sound/effects/adminhelp.ogg')
	message_admins("[key_name_admin(C)] стал мастером раунда.")
	log_admin("[key_name(C)] стал мастером раунда.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Make Round Master")

/datum/controller/subsystem/round_master/proc/clear_master(client/C)
	if(!C)
		return
	if(current_master == C)
		world << "<b>[key_name(C)]</b> больше не мастер раунда."
		play_sound_to_admins('sound/effects/adminhelp.ogg')
		message_admins("[key_name_admin(C)] больше не мастер раунда.")
		log_admin("[key_name(C)] снял с себя звание мастера раунда.")
		current_master = null
		return TRUE
	else
		to_chat(C, "<span class='boldannounceooc'>Ты не являешься мастером раунда.</span>")
		return FALSE

/datum/controller/subsystem/round_master/Initialize()
	current_master = null
	SSblackbox.record_feedback("system", "round_master_init", 1, "Round Master subsystem initialized.")
	world << "Round Master subsystem initialized."
	return TRUE

SUBSYSTEM_DEF(round_master)
