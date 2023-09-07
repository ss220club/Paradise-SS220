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
	..()
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
		var/list/menu_list = list() //text items in the menu
		menu_list.Add(usr.real_name) //the real name of the character, even if it is hidden
		if(usr.real_name != usr.name || usr.name != "unknown") //if the player is masked or the name is different a new answer option is added
			menu_list.Add("[usr.name]")
		menu_list.Add(usr.job, //current job
			num_text, //account number
			pin_text, //pin code number
			sign_text, //signature
			time_text, //time
			date_text, //date
			station_text, // station name
			usr.gender, //current gender
			usr.dna.species //current species
		)
		var/input_element = input("Select the text you want to add:", "Select item") as null|anything in menu_list
		switch(input_element) //format selected menu items in pencode and internal data
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
	if(href_list["write"] )
		var/id = href_list["write"]
		var/input_element = input("Enter what you want to write:", "Write", null, null) as message
		topic_href_write(id, input_element)
