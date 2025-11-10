/proc/play_sound_to_admins(soundfile)
	for(var/client/C in GLOB.admins)
		if(C)
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

	if(SSround_master.is_master(src))
		SSround_master.clear_master()
		world << "<b>[key_name(src)]</b> больше не мастер раунда."
		play_sound_to_admins('sound/effects/adminhelp.ogg')
		message_admins("[key_name_admin(src)] больше не мастер раунда.")
		log_admin("[key_name(src)] снял с себя звание мастера раунда.")
		return

	if(SSround_master.has_master() && SSround_master.current_master != src)
		if(alert(src, "[key_name(SSround_master.current_master)] уже является мастером раунда. Перенять звание?", "Подтверждение", "Да", "Нет") == "Нет")
			return

		to_chat(SSround_master.current_master, "<span class='boldannounceooc'>[key_name(src)] перенял у тебя роль мастера раунда.</span>")
		log_admin("[key_name(src)] перенял роль мастера раунда у [key_name(SSround_master.current_master)].")
		message_admins("[key_name_admin(src)] перенял роль мастера раунда у [key_name_admin(SSround_master.current_master)].")
		play_sound_to_admins('sound/effects/adminhelp.ogg')

	SSround_master.set_master(src)

	world << "<b>[key_name(src)]</b> теперь мастер этого раунда!"
	play_sound_to_admins('sound/effects/adminhelp.ogg')
	message_admins("[key_name_admin(src)] стал мастером раунда.")
	log_admin("[key_name(src)] стал мастером раунда.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Make Round Master")
