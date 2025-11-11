#define SPAN_BOLDOOC(msg) "<span class='boldannounceooc'>[msg]</span>"

/proc/play_sound_to_admins(soundfile)
	for(var/client/admin as anything in GLOB.admins)
		SEND_SOUND(admin, sound(soundfile))

/client/proc/make_round_master()
	set name = "Make Round Master"
	set category = "Admin"
	set desc = "Назначить или снять звание мастера раунда."

	if(IsAdminAdvancedProcCall())
		to_chat(src, SPAN_BOLDOOC("Действие заблокировано: Advanced ProcCall."))
		message_admins("[key_name(src)] попытался вызвать make_round_master через advanced proc-call.")
		log_admin("[key_name(src)] попытался вызвать make_round_master через advanced proc-call.")
		return

	if(!holder)
		to_chat(src, SPAN_BOLDOOC("Только администраторы могут делать это."))
		message_admins("[key_name(src)] попытался стать мастером раунда без прав.")
		log_admin("[key_name(src)] попытался стать мастером раунда без прав.")
		return

	if(SSround_master.is_master(src))
		SSround_master.clear_master(src)
		return

	if(SSround_master.has_master() && SSround_master.current_master != src)
		var/choice = tgui_alert(src,
			"[key_name(SSround_master.current_master)] уже является мастером раунда. Перенять звание?",
			"Подтверждение",
			list("Да", "Нет"))

		if(choice == "Нет" || !choice)
			return

	SSround_master.set_master(src)
