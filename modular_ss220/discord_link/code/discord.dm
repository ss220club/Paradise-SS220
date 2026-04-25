/mob/new_player/Topic(href, href_list)
	if(src != usr)
		return

	if(!client)
		return

	if(href_list["observe"] || href_list["ready"] || href_list["late_join"])
		if(GLOB.configuration.central.api_url && GLOB.configuration.central.force_discord_verification)
			if(!SScentral.is_player_discord_linked(client))
				to_chat(usr, chat_box_red(SPAN_DANGER("Вам необходимо привязать дискорд-профиль к аккаунту!<br>") + SPAN_WARNING("<br>Перейдите во вкладку '<b>Special Verbs</b>', она справа сверху, и нажмите '<b>Привязка Discord</b>' для получения инструкций.<br>") + SPAN_NOTICE("Если вы уверены, что ваш аккаунт уже привязан, подождите синхронизации и попробуйте снова.")))
				return FALSE

	. = ..()
