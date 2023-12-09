/client/verb/webmap()
	set name = "Карта"
	set hidden = TRUE

	if(!SSmapping.map_datum.webmap_url)
		to_chat(usr, "<span class='warning'>Текущей карты нет в вебкартах.</span>")
		return

	if(alert(usr, "Хотите открыть карту станции в бразуере?", "Карта", "Да", "Нет") != "Да")
		return

	usr << link(SSmapping.map_datum.webmap_url)
