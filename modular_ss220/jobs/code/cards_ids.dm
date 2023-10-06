/proc/get_novice_card_skins()
	return list("cadet", "intern", "student", "trainee")

get_station_card_skins()
	var/test = "Test1: \n"
	for(var/i in ..())
		test += ", [i]"
	message_admins(test)

	test = "Test2: \n"
	for(var/i in get_novice_card_skins())
		test += ", [i]"
	message_admins(test)

	test = "Test3: \n"
	for(var/i in ..() + get_novice_card_skins())
		test += ", [i]"
	message_admins(test)

	return ..() + get_novice_card_skins()

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
