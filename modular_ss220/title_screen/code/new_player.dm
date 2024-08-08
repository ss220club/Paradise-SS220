/mob/new_player/Login()
	. = ..()
	SStitle.show_title_screen_to(client)

/mob/new_player/new_player_panel_proc()
	return

/mob/new_player/Topic(href, href_list[])
	. = ..()
	var/mob/new_player/user = usr
	var/client/client = user.client

	if(href_list["ready"])
		client << output(ready, "title_browser:ready")

	if(href_list["skip_antag"])
		client << output(client.skip_antag, "title_browser:skip_antag")

	if(href_list["game_preferences"])
		client.setup_character()

	if(href_list["swap_server"])
		swap_server()

	if(href_list["wiki"])
		if(tgui_alert(usr, "Хотите открыть нашу вики?", "Вики", list("Да", "Нет")) != "Да")
			return
		client << link("https://wiki.ss220.club")

	if(href_list["discord"])
		if(tgui_alert(usr, "Хотите перейти в наш дискорд сервер?", "Дискорд", list("Да", "Нет")) != "Да")
			return
		client << link("https://discord.gg/ss220")

	if(href_list["changelog"])
		SSchangelog.OpenChangelog(client)

/mob/new_player/proc/swap_server()
	var/list/servers =  GLOB.configuration.ss220_misc.cross_server_list
	if(LAZYLEN(servers) < 1)
		return

	var/server_name
	var/server_ip
	if(LAZYLEN(servers) > 1)
		server_name = tgui_input_list(src, "Пожалуйста, выберите сервер куда собираетесь отправиться...", "Смена сервера!", servers)
		if(!server_name)
			return
		server_ip = servers[server_name]

	if(LAZYLEN(servers) == 1)
		server_name = servers[1]
		server_ip = servers[server_name]

	var/confirm = tgui_alert(src, "Вы уверены что хотите перейти на [server_name] ([server_ip])?", "Смена сервера!", list("Поехали", "Побуду тут..."))
	if(confirm != "Поехали")
		return

	to_chat_immediate(src, "Удачной охоты, сталкер.")
	src.client << link(server_ip)

/datum/preferences/process_link(mob/user, list/href_list)
	. = ..()
	if(href_list["task"] == "random" && href_list["preference"] == "name")
		user.client << output(active_character.real_name, "title_browser:update_current_character")
		return TRUE

	if(href_list["task"] == "input" && href_list["preference"] == "name")
		user.client << output(active_character.real_name, "title_browser:update_current_character")
		return TRUE
