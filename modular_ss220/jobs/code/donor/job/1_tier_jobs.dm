/datum/job/donor/prisoner
	title = "Prisoner"
	ru_title = "Заключенный"
	relate_job = "Security Officer"
	outfit = /datum/outfit/job/donor/prisoner

/datum/outfit/job/donor/prisoner
	name = "Заключенный"
	jobtype = /datum/job/donor/prisoner

	uniform = /obj/item/clothing/under/color/orange/prison
	shoes = /obj/item/clothing/shoes/orange

/datum/outfit/job/donor/prisoner/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(prob(20))
		uniform = /obj/item/clothing/under/misc/pj/red
		if(prob(30))
			uniform = /obj/item/clothing/under/misc/pj/blue

/datum/outfit/job/donor/prisoner/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	// SSjobs.notify_dept_head(modify.rank, "[scan.registered_name] ([scan.assignment]) has demoted \"[modify.registered_name]\" ([jobnamedata]) for \"[reason]\".")
	// сюда же форс перемещение на лендмарк


