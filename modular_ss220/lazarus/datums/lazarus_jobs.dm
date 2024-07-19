#define JOB_HERMIT			(1<<15)
#define JOB_CRUSADER		(1<<16)
#define JOB_ABADONED_MINER	(1<<17)
#define JOB_CANNIBAL		(1<<18)
#define JOB_SECTARIAN		(1<<19)
#define JOB_SYNDI_AGENT		(1<<20)

/datum/job
	var/true_title

/datum/job/assistant
	hidden_from_job_prefs = FALSE
	selection_color = "#566f77"

/datum/job/doctor
	hidden_from_job_prefs = FALSE
	total_positions = 8
	spawn_positions = 8
	selection_color = "#566f77"

/datum/job/doctor/intern
	hidden_from_job_prefs = TRUE

/datum/job/chemist
	hidden_from_job_prefs = FALSE
	total_positions = 1
	spawn_positions = 1
	selection_color = "#566f77"

/datum/job/engineer
	hidden_from_job_prefs = FALSE
	total_positions = 8
	spawn_positions = 8
	selection_color = "#566f77"

/datum/job/engineer/trainee
	hidden_from_job_prefs = TRUE

/datum/job/hydro
	hidden_from_job_prefs = FALSE
	total_positions = 3
	spawn_positions = 3
	selection_color = "#566f77"

/datum/job/mining
	hidden_from_job_prefs = FALSE
	total_positions = 20
	spawn_positions = 20
	selection_color = "#566f77"

/datum/job/officer
	hidden_from_job_prefs = FALSE
	total_positions = 10
	spawn_positions = 10
	selection_color = "#566f77"

/datum/job/officer/cadet
	hidden_from_job_prefs = TRUE
	selection_color = "#566f77"

/datum/job/chef
	hidden_from_job_prefs = FALSE
	total_positions = 2
	spawn_positions = 2
	selection_color = "#566f77"

/datum/job/hermit
	title = "Hermit"
	total_positions = 6
	spawn_positions = 6
	flag = JOB_HERMIT
	department_flag = JOBCAT_SUPPORT
	supervisors = "собственная совесть"
	department_head = list("Собственная совесть")
	selection_color = "#8fa088"
	access = list()
	outfit = /datum/outfit/job/assistant
	hidden_from_job_prefs = FALSE

/datum/job/crusader
	title = "Crusader"
	total_positions = 1
	spawn_positions = 1
	flag = JOB_CRUSADER
	department_flag = JOBCAT_SUPPORT
	supervisors = "всевышний"
	department_head = list("Всевышний")
	selection_color = "#8fa088"
	access = list()
	outfit = /datum/outfit/job/assistant
	hidden_from_job_prefs = FALSE

/datum/job/abadoned_miner
	title = "Abadoned Miner"
	total_positions = 1
	spawn_positions = 1
	flag = JOB_ABADONED_MINER
	department_flag = JOBCAT_SUPPORT
	supervisors = "руководство комплекса"
	department_head = list("Руководство Комплекса")
	selection_color = "#8fa088"
	access = list()
	outfit = /datum/outfit/job/assistant
	hidden_from_job_prefs = FALSE

/datum/job/cannibal
	title = "Cannibal"
	true_title = "Cannibal"
	total_positions = 2
	spawn_positions = 2
	flag = JOB_CANNIBAL
	department_flag = JOBCAT_SUPPORT
	supervisors = "голос плоти"
	department_head = list("Великая Плоть")
	selection_color = "#8d7171"
	access = list()
	outfit = /datum/outfit/job/cannibal
	hidden_from_job_prefs = FALSE

/datum/outfit/job/cannibal
	name = "Cannibal"
	jobtype = /datum/job/cannibal
	uniform = /obj/item/clothing/under/color/white
	suit = /obj/item/clothing/suit/hooded/wintercoat
	gloves = /obj/item/clothing/gloves/color/white
	shoes = /obj/item/clothing/shoes/winterboots
	l_ear = /obj/item/radio/headset
	backpack_contents = list(
		/obj/item/restraints/handcuffs = 1,
		/obj/item/kitchen/knife/butcher = 1
	)
	mask = /obj/item/clothing/mask/pig
	belt = /obj/item/storage/belt/chef

/datum/job/sectarian
	title = "Sectarian"
	true_title = "Sectarian"
	total_positions = 2
	spawn_positions = 2
	flag = JOB_SECTARIAN
	department_flag = JOBCAT_SUPPORT
	supervisors = "Бог-Во-Плоти"
	department_head = list("Бог-Во-Плоти")
	selection_color = "#8d7171"
	access = list()
	outfit = /datum/outfit/job/sectarian
	hidden_from_job_prefs = FALSE

/datum/outfit/job/sectarian
	name = "Sectarian"
	jobtype = /datum/job/sectarian
	uniform = /obj/item/clothing/under/color/black
	suit = /obj/item/clothing/suit/hooded/cultrobes
	gloves = /obj/item/clothing/gloves/color/black
	shoes = /obj/item/clothing/shoes/jackboots
	l_ear = /obj/item/radio/headset
	backpack_contents = list(
		/obj/item/kitchen/knife/ritual = 1
	)
	mask = /obj/item/clothing/mask/face/raven

/datum/job/syndicate_agent
	title = "Syndicate Agent"
	total_positions = 1
	spawn_positions = 1
	flag = JOB_SYNDI_AGENT
	department_flag = JOBCAT_SUPPORT
	supervisors = "синдикат"
	department_head = list("Синдикат")
	selection_color = "#8d7171"
	access = list()
	outfit = /datum/outfit/job/syndi_agent
	hidden_from_job_prefs = FALSE

/datum/outfit/job/syndi_agent
	name = "Syndicate Agent"
	jobtype = /datum/job/syndicate_agent
	uniform = /obj/item/clothing/under/syndicate
	gloves = /obj/item/clothing/gloves/combat
	shoes = /obj/item/clothing/shoes/jackboots
	l_ear = /obj/item/radio/headset
	belt = /obj/item/storage/belt/military
