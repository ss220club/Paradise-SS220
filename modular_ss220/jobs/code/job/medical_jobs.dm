/datum/job/doctor/New()
	. = ..()
	alt_titles |= list("Intern", "Medical Assistant", "Student Medical Doctor")

/datum/station_department/medical/New()
	. = ..()
	department_roles |= list("Intern", "Medical Assistant", "Student Medical Doctor")

/datum/nttc_configuration/New()
	. = ..()
	all_jobs |= list(
		"Intern" = "medradio",
		"Medical Assistant" = "medradio",
		"Student Medical Doctor" = "medradio",
		)

/datum/outfit/job/doctor/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(H.mind && H.mind.role_alt_title)
		var/is_novice = FALSE

		switch(H.mind.role_alt_title)
			if("Intern")
				is_novice = TRUE
				uniform = /obj/item/clothing/under/rank/medical/intern
				if(H.gender == FEMALE)
					uniform = /obj/item/clothing/under/rank/medical/intern/skirt
			if("Student Medical Doctor")
				is_novice = TRUE
				//head = /obj/item/clothing/head/surgery/lightgreen
				//uniform = /obj/item/clothing/under/rank/medical/lightgreen
			if("Medical Assistant")
				is_novice = TRUE
				uniform = /obj/item/clothing/under/rank/medical/intern/assistant
				if(H.gender == FEMALE)
					uniform = /obj/item/clothing/under/rank/medical/intern/assistant/skirt

		if(is_novice)
			id = /obj/item/card/id/medical/intern
			//l_pocket = /obj/item/paper/deltainfo
			l_hand = /obj/item/storage/firstaid/o2
			mask = /obj/item/clothing/mask/surgical
			gloves = /obj/item/clothing/gloves/color/latex
			glasses = /obj/item/clothing/glasses/hud/security/sunglasses // !!!! ДЛЯ ТЕСТА


	// "student scientist" = "Учёный-практикант",
	// "Scientist Assistant" = "Научный Ассистент",
	// "Scientist Pregraduate" = "Учёный-бакалавр",
	// "Scientist Graduate" = "Научный выпускник",
	// "Scientist Postgraduate" = "Учёный-аспирант",
