/client/proc/cmd_admin_offer_control(mob/M as mob in GLOB.mob_list)
	set name = "\[Admin\] Offer Control To Ghosts"
	set category = null

	if(!check_rights(R_ADMIN))
		return

	if(!mob)
		return
	if(!istype(M))
		alert("This can only be used on instances of type /mob")
		return
	offer_control(M)

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
		to_chat(src, span_boldannounceooc("Только администраторы могут делать это."))
		message_admins("[key_name(src)] попытался стать мастером раунда без прав.")
		log_admin("[key_name(src)] попытался стать мастером раунда без прав.")
		return

	if(GLOB.round_master.is_master(src))
		GLOB.round_master.clear_master(src)
		return

	if(GLOB.round_master.current_master && GLOB.round_master.current_master != src)
		var/choice = tgui_alert(src,
			"[key_name(GLOB.round_master.current_master)] уже является мастером раунда. Перенять звание?",
			"Подтверждение",
			list("Да", "Нет"))

		if(choice != "Да")
			return

	GLOB.round_master.set_master(src)
