/proc/play_sound_to_admins(soundfile)
	for(var/client/admin as anything in GLOB.admins)
		SEND_SOUND(admin, sound(soundfile))

/client/proc/make_round_master()
	set name = "Make Round Master"
	set category = "Admin"
	set desc = "Назначить или снять звание мастера раунда."

	if(IsAdminAdvancedProcCall())
		to_chat(src, span_boldannounceooc("Действие заблокировано: Advanced ProcCall."))
		message_admins("[key_name(src)] попытался вызвать make_round_master через advanced proc-call.")
		log_admin("[key_name(src)] попытался вызвать make_round_master через advanced proc-call.")
		return

	if(!holder)
		to_chat(src, "<span class='boldannounceooc'>Только администраторы могут делать это.</span>")
		message_admins("[key_name(src)] попытался стать мастером раунда без прав.")
		log_admin("[key_name(src)] попытался стать мастером раунда без прав.")
		return

	if(SSround_master.is_master(src))
		SSround_master.clear_master(src)
		return

	if(SSround_master.has_master() && SSround_master.current_master != src)
		if(alert(src, "[key_name(SSround_master.current_master)] уже является мастером раунда. Перенять звание?", "Подтверждение", "Да", "Нет") == "Нет")
			return

	SSround_master.set_master(src)
