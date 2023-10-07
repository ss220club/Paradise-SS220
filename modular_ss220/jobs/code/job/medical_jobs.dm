/datum/job/doctor/New()
	. = ..()
	alt_titles |= get_all_medical_novice_tittles()

/datum/station_department/medical/New()
	. = ..()
	department_roles |= get_all_medical_novice_tittles()

/datum/nttc_configuration/New()
	. = ..()
	var/list/job_radio_dict = list()

	for(var/i in get_all_medical_novice_tittles())
		job_radio_dict.Add(list("[i]" = "medradio"))
	for(var/i in get_all_security_novice_tittles())
		job_radio_dict.Add(list("[i]" = "secradio"))
	for(var/i in get_all_engineering_novice_tittles())
		job_radio_dict.Add(list("[i]" = "engradio"))
	for(var/i in get_all_science_novice_tittles())
		job_radio_dict.Add(list("[i]" = "scirradio"))

	all_jobs |= job_radio_dict

/datum/outfit/job/doctor/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(H.mind && H.mind.role_alt_title)
		if(H.mind.role_alt_title in get_all_medical_novice_tittles())
			uniform = /obj/item/clothing/under/rank/medical/intern
			if(H.gender == FEMALE)
				uniform = /obj/item/clothing/under/rank/medical/intern/skirt
			id = /obj/item/card/id/medical/intern
			//l_pocket = /obj/item/paper/deltainfo
			l_hand = /obj/item/storage/firstaid/o2
			mask = /obj/item/clothing/mask/surgical
			gloves = /obj/item/clothing/gloves/color/latex
			glasses = /obj/item/clothing/glasses/hud/security/sunglasses // !!!! ДЛЯ ТЕСТА

		switch(H.mind.role_alt_title)
			if("Intern")
				uniform = /obj/item/clothing/under/rank/medical/intern
				if(H.gender == FEMALE)
					uniform = /obj/item/clothing/under/rank/medical/intern/skirt
			if("Student Medical Doctor")
				head = /obj/item/clothing/head/surgery/green/light
				uniform = /obj/item/clothing/under/rank/medical/scrubs/green/light
			if("Medical Assistant")
				uniform = /obj/item/clothing/under/rank/medical/intern/assistant
				if(H.gender == FEMALE)
					uniform = /obj/item/clothing/under/rank/medical/intern/assistant/skirt



	// "student scientist" = "Учёный-практикант",
	// "Scientist Assistant" = "Научный Ассистент",
	// "Scientist Pregraduate" = "Учёный-бакалавр",
	// "Scientist Graduate" = "Научный выпускник",
	// "Scientist Postgraduate" = "Учёный-аспирант",
