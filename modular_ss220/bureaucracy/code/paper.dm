/obj/item/paper
	var/paper_width_big = 600
	var/paper_height_big = 700
	var/small_paper_cap = 1024
	var/force_big = FALSE

/obj/item/paper/updateinfolinks()
	. = ..()
	if(length(info) > small_paper_cap)
		become_big()
	else
		reset_size()

/obj/item/paper/proc/become_big()
	paper_width = paper_width_big
	paper_height = paper_height_big

/obj/item/paper/proc/reset_size()
	paper_width = initial(paper_width)
	paper_height = initial(paper_height)

/obj/item/paper/Topic(href, href_list)
	if(!usr || (usr.stat || usr.restrained()))
		return

	if(href_list["auto_write"])
		var/id = href_list["auto_write"]
		var/const/sign_text = "\[Подпись\]"
		var/const/time_text = "\[Текущее время\]"
		var/const/date_text = "\[Текущая Дата\]"
		var/const/num_text = "\[Номер аккаунта\]"
		var/const/pin_text = "\[ПИН\]"
		var/const/station_text = "\[Название станции\]"
		var/list/menu_list = list()
		menu_list.Add(usr.real_name)
		if(usr.real_name != usr.name || usr.name != "unknown")
			menu_list.Add("[usr.name]")
		menu_list.Add(usr.job, // Сurrent job
			num_text, // Account number
			pin_text, // Pin code number
			sign_text, // Signature
			time_text, // Time
			date_text, // Date
			station_text, // Station name
			usr.gender, // Current gender
			usr.dna.species // Current species
		)
		var/input_element = input("Select the text you want to add:", "Select item") as null|anything in menu_list
		switch(input_element) // Format selected menu items in pencode and internal data
			if(sign_text)
				input_element = "\[sign\]"
			if(time_text)
				input_element = "\[time\]"
			if(date_text)
				input_element = "\[date\]"
			if(station_text)
				input_element = "\[station\]"
			if(num_text)
				input_element = usr.mind.initial_account.account_number
			if(pin_text)
				input_element = usr.mind.initial_account.account_pin
		topic_href_write(id, input_element)

	..()
