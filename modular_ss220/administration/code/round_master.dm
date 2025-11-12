/proc/play_sound_to_admins(soundfile)
	for(var/client/admin as anything in GLOB.admins)
		SEND_SOUND(admin, sound(soundfile))

/client/proc/make_round_master()
	set name = "Make Round Master"
	set category = "Admin"
	set desc = "Назначить или снять звание мастера раунда."

	var/adv_proc = "попытался вызвать make_round_master через advanced proc-call."
	var/no_adm = "попытался стать мастером раунда без прав."

	if(IsAdminAdvancedProcCall())
		to_chat(src, SPAN_BOLDOOC("Действие заблокировано: Advanced ProcCall."))
		message_admins("[key_name(src)] " + adv_proc)
		log_admin("[key_name(src)] " + adv_proc)
		return

	if(!holder)
		to_chat(src, SPAN_BOLDOOC("Только администраторы могут делать это."))
		message_admins("[key_name(src)] " + no_adm)
		log_admin("[key_name(src)] " + no_adm)
		return

	if(SSround_master.is_master(src))
		SSround_master.clear_master(src)
		return

	if(SSround_master.current_master && SSround_master.current_master != src)
		var/choice = tgui_alert(src,
			"[key_name(SSround_master.current_master)] уже является мастером раунда. Перенять звание?",
			"Подтверждение",
			list("Да", "Нет"))

		if(choice != "Да")
			return

	SSround_master.set_master(src)
