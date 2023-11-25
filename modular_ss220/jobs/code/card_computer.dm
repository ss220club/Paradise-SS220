/obj/machinery/computer/card/ui_data(mob/user)
	var/list/data = ..()

	if(mode == IDCOMPUTER_SCREEN_TRANSFER) // JOB TRANSFER
		if(modify && scan && !target_dept)
			data["card_skins"] |= format_card_skins(GLOB.jobs_positions_ss220)

	return data

/obj/machinery/computer/card/ui_act(action, params)
	. = ..()
	switch(action)
		if("skin")
			if(!modify)
				return FALSE
			var/skin = params["skin_target"]
			if(!skin || !(skin in GLOB.jobs_positions_ss220))
				return FALSE

			modify.icon_state = get_card_skin_ss220(skin)
			return TRUE

/obj/machinery/computer/card/proc/get_card_skin_ss220(skin)
	. = ..()
	switch(skin)
		if("Intern")
			return "intern"
		if("Student Scientist")
			return "student"
		if("Trainee Engineer")
			return "trainee"
		if("Security Cadet")
			return "cadet"
		else
			return ckey(skin)
