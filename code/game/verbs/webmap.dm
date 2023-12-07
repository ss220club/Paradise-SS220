/client/verb/webmap()
	set name = "Карта"
	set hidden = TRUE

	if(!SSmapping.map_datum.webmap_url)
		to_chat(usr, "<span class='warning'>The current map has no defined webmap. Please file an issue report.</span>")
		return

	if(alert(usr, "Хотите открыть карту станции в бразуере?", "Webmap", "Да", "Нет") != "Да")
		return

	usr << link(SSmapping.map_datum.webmap_url)
