// !!!!!!!! сделать автоустановку роли новичкам при загрузке

// /proc/get_novice_card_skins()
// 	return list("cadet", "intern", "student", "trainee")

// get_station_card_skins()
// 	var/test = "Test1: \n"
// 	for(var/i in ..())
// 		test += ", [i]"
// 	message_admins(test)

// 	test = "Test2: \n"
// 	for(var/i in get_novice_card_skins())
// 		test += ", [i]"
// 	message_admins(test)

// 	test = "Test3: \n"
// 	for(var/i in ..() + get_novice_card_skins())
// 		test += ", [i]"
// 	message_admins(test)

//	return ..() + get_novice_card_skins()

/proc/get_all_medical_novice_tittles()
	return list("Intern", "Medical Assistant", "Student Medical Doctor")

/proc/get_all_security_novice_tittles()
	return list("Cadet")

/proc/get_all_engineering_novice_tittles()
	return list("Trainee")

/proc/get_all_science_novice_tittles()
	return list("Student")

/proc/get_all_novice_tittles()
	return get_all_medical_novice_tittles() + get_all_security_novice_tittles() + get_all_engineering_novice_tittles() + get_all_science_novice_tittles()

// /proc/get_modular_ss220_hud_image(mob/living/carbon/human/H)
// 	var/image/I
// 	if(!H.wear_id)
// 		return
// 	if(H.wear_id.assignment == "Intern" || H.wear_id.get_ID_assignment() in get_all_novice_tittles())
// 		I = image('modular_ss220/jobs/icons/hud.dmi', src, "")
// 		I.appearance_flags = RESET_COLOR | RESET_TRANSFORM

// 	return I



	//var/image/holder = I


// /atom/prepare_huds()
// 	. = ..()
// 	var/hud = ID_HUD
// 	if(hud in hud_possible)	// копипаст наследуемого метода
// 		var/hint = hud_possible[hud]
// 		switch(hint)
// 			if(HUD_LIST_LIST)
// 				hud_list[hud] = list()
// 			else
// 				var/image/I = image('modular_ss220/jobs/icons/hud.dmi', src, "")
// 				I.appearance_flags = RESET_COLOR | RESET_TRANSFORM
// 				hud_list[ID_HUD] = I	//непральна


// /mob/living/carbon/human/sec_hud_set_ID()
// 	if(!wear_id)
// 		return ..()

// 	if()

// 	//.dmi с худама
// 	var/image/I = image('modular_ss220/jobs/icons/hud.dmi', src, "")
// 	I.appearance_flags = RESET_COLOR | RESET_TRANSFORM

// 	//Устанавливаем ХУДы с .dmi
// 	var/image/holder = I
// 	holder.icon_state = "hudunknown"
// 	holder.icon_state = "hud[ckey(wear_id.get_job_name())]"
// 	sec_hud_set_security_status()




/proc/get_all_novice_huds()
	return list("intern", "cadet", "trainee", "student")

/obj/item/get_job_name() //Used in secHUD icon generation
	var/assignmentName = get_ID_assignment(if_no_id = "Unknown")
	var/rankName = get_ID_rank(if_no_id = "Unknown")

	var/novmed = get_all_medical_novice_tittles()
	var/novsec = get_all_security_novice_tittles()
	var/noveng = get_all_engineering_novice_tittles()
	var/novrnd = get_all_science_novice_tittles()

	if((assignmentName in novmed) || (rankName in novmed))
		return "intern"
	if((assignmentName in novsec) || (rankName in novsec))
		return "cadet"
	if((assignmentName in noveng) || (rankName in noveng))
		return "trainee"
	if((assignmentName in novrnd) || (rankName in novrnd))
		return "student"

	. = ..()

// /atom/prepare_huds()
// 	. = ..()
// 	var/image/img = image('modular_ss220/jobs/icons/hud.dmi', src, "")
// 	img.appearance_flags = RESET_COLOR | RESET_TRANSFORM
// 	hud_list[ID_HUD] += img

/obj/item/card/id/medical/intern
	name = "Intern ID"
	registered_name = "Intern"
	icon = 'modular_ss220/jobs/icons/card.dmi'
	icon_state = "intern"
	item_state = "intern-id"
	rank = "Intern"

/obj/item/card/id/research/student
	name = "Student ID"
	registered_name = "Student"
	icon = 'modular_ss220/jobs/icons/card.dmi'
	icon_state = "student"
	item_state = "student-id"

/obj/item/card/id/engineering/trainee
	name = "Trainee ID"
	registered_name = "Trainee"
	icon = 'modular_ss220/jobs/icons/card.dmi'
	icon_state = "trainee"
	item_state = "trainee-id"

/obj/item/card/id/security/cadet
	name = "Cadet ID"
	registered_name = "Cadet"
	icon = 'modular_ss220/jobs/icons/card.dmi'
	icon_state = "cadet"
	item_state = "cadet-id"
