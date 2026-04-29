USER_VERB(admin_change_title_screen, R_EVENT, "Title Screen: Change", "Upload a new titlescreen image.", VERB_CATEGORY_EVENT)
	var/input = tgui_alert(client, "Что делаем с изображением в лобби?", "Лобби", list("Меняем", "Сбрасываем", "Ничего"))

	log_admin("[key_name(client)] is changing the title screen.")
	message_admins("[key_name_admin(client)] is changing the title screen.")

	switch(input)
		if("Меняем")
			var/file = input(client) as icon|null
			if(!file)
				return

			SStitle.set_title_image(file)
		if("Сбрасываем")
			SStitle.set_title_image()
		if("Ничего")
			return


USER_VERB(change_title_screen_notice, R_EVENT, "Title Screen: Set Notice", "Sets a titlescreen notice, a big red text on the main screen", VERB_CATEGORY_EVENT)
	var/new_notice = tgui_input_text(client, "Введи то что должно отображаться в лобби:", "Уведомление в лобби")

	log_admin("[key_name(client)] is setting the title screen notice.")
	message_admins("[key_name_admin(client)] is setting the title screen notice.")

	if(isnull(new_notice))
		return

	SStitle.set_notice(new_notice)
	for(var/mob/new_player/new_player in GLOB.player_list)
		to_chat(new_player, SPAN_BOLDANNOUNCE("УВЕДОМЛЕНИЕ В ЛОББИ ОБНОВЛЕНО: [new_notice]"))
		SEND_SOUND(new_player,  sound('sound/items/bikehorn.ogg'))


USER_VERB(fix_title_screen, R_NONE, "Fix Lobby Screen", "Lobbyscreen broke? Press this.", VERB_CATEGORY_SPECIAL)
	if(istype(client, /mob/new_player))
		SStitle.show_title_screen_to(client)
	else
		SStitle.hide_title_screen_from(client)


USER_VERB(change_title_screen_htm, R_DEBUG, "Title Screen: Set HTML", "Debug command that enables you to change the HTML on the go", VERB_CATEGORY_EVENT)
	log_admin("[key_name(client)] is setting the title screen HTML.")
	message_admins("[key_name_admin(client)] is setting the title screen HTML.")

	var/new_html = tgui_input_text(client, "Введи нужный HTML (ВНИМАНИЕ: ТЫ СКОРЕЕ ВСЕГО ЧТО-ТО СЛОМАЕШЬ!!!)", "РИСКОВАННО: ИЗМЕНЕНИЕ HTML ЛОББИ", max_length = 99999, multiline = TRUE, encode = FALSE)
	if(isnull(new_html))
		return

	if(tgui_alert(client, "Всё ли верно? Нигде не ошибся? Возврата нет!", "Ты подумай...", list("Рискнём", "Пожалуй нет...")) != "Рискнём")
		return

	SStitle.set_title_html(new_html)
	message_admins("[key_name_admin(client)] has changed the title screen HTML.")
