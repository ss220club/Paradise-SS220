/datum/preferences
	var/discord_id

// IF you have linked your account, this will trigger a verify of the user
/client/verb/link_discord_account()
	set name = "Привязка Discord"
	set category = "Special Verbs"
	set desc = "Привязать аккаунт Discord для удобного просмотра игровой статистики на нашем Discord-сервере."

	if(!GLOB.configuration.url.discord_url)
		return
	if(IsGuestKey(key))
		to_chat(usr, "Гостевой аккаунт не может быть связан.")
		return
	if(prefs)
		prefs.load_preferences(usr)
	if(prefs && prefs.discord_id)
		to_chat(usr, "<span class='darkmblue'>Аккаунт Discord уже привязан! Чтобы отвязать используйте команду <span class='boldannounce'>/отвязать</span> в канале <b>#дом-бота</b> в Discord-сообществе!</span>")
		return
	var/token = md5("[world.time+rand(1000,1000000)]")
	if(SSdbcore.IsConnected())
		var/datum/db_query/query_update_token = SSdbcore.NewQuery("UPDATE discord_links SET one_time_token=:token WHERE ckey =:ckey", list("token" = token, "ckey" = ckey))
		if(!query_update_token.warn_execute())
			to_chat(usr, "<span class='warning'>Ошибка записи токена в БД! Обратитесь к администрации.</span>")
			log_debug("link_discord_account: failed db update discord_id for ckey [ckey]")
			qdel(query_update_token)
			return
		qdel(query_update_token)
		to_chat(usr, "<span class='darkmblue'>Для завершения используйте команду <span class='boldannounce'>/привязать</span> и токен \"[token]\" в канале <b>#дом-бота</b> в Discord-сообществе!</span>")
		if(prefs)
			prefs.load_preferences(usr)

/mob/new_player/Topic(href, href_list[])
	if(src != usr)
		return

	if(!client)
		return

	if(href_list["observe"] || href_list["toggle_ready"] || href_list["late_join"])
		if (GLOB.configuration.database.enabled && !client.prefs.discord_id)
			to_chat(usr, "<span class='danger'>Вам необходимо привязать дискорд-профиль к аккаунту!</span>")
			to_chat(usr, "<span class='warning'>Нажмите 'Привязка Discord' во вкладке 'Special Verbs' для получения инструкций.</span>")
			return FALSE

	. = ..()
