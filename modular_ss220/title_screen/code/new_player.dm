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

	if(href_list["wiki"])
		if(!tgui_alert(usr, "Вики", "Хотите открыть нашу вики?", list("Да", "Нет")) != "Да")
			return
		client << link("https://wiki.ss220.club")

	if(href_list["discord"])
		if(!tgui_alert(usr, "Дискорд", "Хотите перейти в наш дискорд сервер?", list("Да", "Нет")) != "Да")
			return
		client << link("https://discord.gg/ss220")

	if(href_list["changelog"])
		SSchangelog.OpenChangelog(client)

/datum/preferences/process_link(mob/user, list/href_list)
	. = ..()
	if(href_list["task"] == "random" && href_list["preference"] == "name")
		user.client << output(active_character.real_name, "title_browser:update_current_character")
		return TRUE

	if(href_list["task"] == "input" && href_list["preference"] == "name")
		user.client << output(active_character.real_name, "title_browser:update_current_character")
		return TRUE
