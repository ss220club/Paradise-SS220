/proc/play_sound_to_admins(soundfile)
	for(var/client/C in GLOB.clients)
		if(C && C.holder)
			SEND_SOUND(C, sound(soundfile))


/client/proc/make_round_master()
	set name = "Make Round Master"
	set category = "Admin"
	set desc = "Назначить или снять звание мастера раунда."

	if(IsAdminAdvancedProcCall())
		to_chat(src, "<span class='boldannounceooc'>Действие заблокировано: Advanced ProcCall.</span>")
		message_admins("[key_name(src)] попытался вызвать make_round_master через advanced proc-call.")
		log_admin("[key_name(src)] попытался вызвать make_round_master через advanced proc-call.")
		return

	if(!holder)
		to_chat(src, "<span class='boldannounceooc'>Только администраторы могут делать это.</span>")
		message_admins("[key_name(src)] попытался стать мастером раунда без прав.")
		log_admin("[key_name(src)] попытался стать мастером раунда без прав.")
		return

	var/client/current_master = null
	for(var/client/C in GLOB.clients)
		if(C.master_of_round)
			current_master = C
			break

	if(src.master_of_round)
		src.master_of_round = FALSE
		world << "<b>[key_name(src)]</b> больше не мастер раунда."
		play_sound_to_admins('sound/effects/adminhelp.ogg')
		log_admin("[key_name(src)] снял с себя звание мастера раунда.")
		message_admins("[key_name_admin(src)] больше не мастер раунда.")
		return

	if(current_master && current_master != src)
		if(alert(src, "[key_name(current_master)] уже является мастером раунда. Перенять звание?", "Подтверждение", "Да", "Нет") == "Нет")
			return

		current_master.master_of_round = FALSE
		to_chat(current_master, "<span class='boldannounceooc'>[key_name(src)] перенял у тебя роль мастера раунда.</span>")
		play_sound_to_admins('sound/effects/adminhelp.ogg')
		message_admins("[key_name_admin(src)] перенял роль мастера раунда у [key_name_admin(current_master)].")
		log_admin("[key_name(src)] перенял роль мастера раунда у [key_name(current_master)].")

	src.master_of_round = TRUE
	world << "<b>[key_name(src)]</b> теперь мастер этого раунда!"
	play_sound_to_admins('sound/effects/adminhelp.ogg')
	message_admins("[key_name_admin(src)] стал мастером раунда.")
	log_admin("[key_name(src)] стал мастером раунда.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Make Round Master")
