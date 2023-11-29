/datum/job/donor
	title = "Почетный Донор" // он тут быть не должен. Но если педали вдруг выдадут, то пускай хотя бы так
	flag = JOB_DONOR
	department_flag = JOBCAT_SUPPORT
	total_positions = 0
	spawn_positions = 0
	job_department_flags = DEP_FLAG_SERVICE
	supervisors = "the head of personnel"
	department_head = list("Head of Personnel")
	selection_color = "#fbd5ff"
	access = list( ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_MAINT_TUNNELS)
	alt_titles = null
	outfit = /datum/outfit/job/donor

/datum/outfit/job/donor
	name = "Почетный Донор"
	jobtype = /datum/job/donor


	uniform = /obj/item/clothing/under/color/random
	shoes = /obj/item/clothing/shoes/black
	id = /obj/item/card/id/assistant

	// uniform = /obj/item/clothing/under/rank/civilian/janitor
	// shoes = /obj/item/clothing/shoes/black
	// l_ear = /obj/item/radio/headset/headset_service
	// id = /obj/item/card/id/janitor
	// pda = /obj/item/pda/janitor
	// r_pocket = /obj/item/door_remote/janikeyring
