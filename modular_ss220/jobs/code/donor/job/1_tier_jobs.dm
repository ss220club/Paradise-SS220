

/datum/job/donor/tier_1
	title = "Случайная Т1 роль"
	outfit = /datum/outfit/job/donor/tier_1
	alt_titles = list("Заключенный")

/datum/outfit/job/donor/tier_1
	name = "Случайная Т1 роль"
	jobtype = /datum/job/donor/tier_1

/datum/outfit/job/donor/tier_1/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()

	if(H.mind && H.mind.role_alt_title)
		if(H.mind.role_alt_title in get_all_engineering_novice_tittles())
			uniform = /obj/item/clothing/under/rank/engineer/trainee
			if(H.gender == FEMALE)
				uniform = /obj/item/clothing/under/rank/engineer/trainee/skirt
			id = /obj/item/card/id/engineering/trainee
			gloves = /obj/item/clothing/gloves/color/orange

	else
		return FALSE

	if(H.mind.role_alt_title == name)
		H.mind.role_alt_title = pick(alt_titles)
		// H.mind.assigned_role = rank
		// alt_title = H.mind.role_alt_title

	switch(H.mind.role_alt_title)
		if("Заключенный")
			uniform = /obj/item/clothing/under/color/orange/prison
			//if(H.gender == FEMALE)
			//	uniform = /obj/item/clothing/under/rank/engineer/trainee/assistant/skirt
























/datum/job/donor/
	title = "Заключенный"
	flag = JOB_PRISON
	outfit = /datum/outfit/job/donor/

/datum/outfit/job/donor/
	name = "Заключенный"
	jobtype = /datum/job/donor/
