
GLOBAL_LIST_INIT(donor_tier_1_jobs, list(
	"Prisoner",
	"Test",
	"Security Clown",
))

// // Словарь для спавнов на лендмарках по названиям
// GLOBAL_LIST_INIT(jobs_relate_dict, list(
// 	"Prisoner" = "Security Officer",
// 	"Test" = "Assistant",
// 	"Security Clown" = "Security Officer",
// ))

/*
Схематика.

Доступные джобки:
Выбор ТИР 1-5 с альт_должностями

Недоступные скрытые джобки:
Все джобки в donor/
Они являются определяющими и после выбора альт_должности в доступных джобках оно начинает отсылаться к этим.
*/

// All donor jobs
GLOBAL_LIST_INIT(all_donor_jobs, donor_tier_1_jobs)

// Security Jobs, cant be antags
GLOBAL_LIST_INIT(security_donor_jobs, list(
	"Security Clown"
))

// Service Jobs, can be antags
GLOBAL_LIST_INIT(service_donor_jobs, all_donor_jobs - security_donor_jobs)

// Jobs, cant be antags
GLOBAL_LIST_INIT(no_antag_donor_jobs, security_donor_jobs + list(
	"Test"
))







// /datum/outfit/job/donor/proc/update_rank_id(mob/living/carbon/human/H)
// 	if(!id || !H.mind.role_alt_title)
// 		return
// 	var/obj/item/card/id/current_id = H.wear_id
// 	var/alt_title = H.mind.role_alt_title
// 	var/jobs_list = GLOB.jobs_relate_dict

// 	current_id.assignment = alt_title
// 	current_id.rank = jobs_list[alt_title]


// накладываем для красивости и создания "иллюзии" что это обычная профессия
// /datum/outfit/job/donor/imprint_idcard(mob/living/carbon/human/H)
// 	. = ..()
// 	var/new_rank = jobs_list[alt_title]
// 	if(new_rank)
// 		current_id.rank = new_rank
// 	//current_id.assignment = alt_title


// Прок переопределяющий нашу профессию перед спавном
// /datum/job/proc/before_spawn(mob/living/carbon/human/H, joined_late)
// 	if(!H)
// 		return null

// 	// для связывания спавнов лендмарков в EquipRank()
// 	if(!joined_late)
// 		var/alt_title = H.mind.role_alt_title
// 		var/jobs_relate_dict = GLOB.jobs_relate_dict
// 		if(alt_title && (alt_title in jobs_relate_dict))
// 			relate_job = jobs_relate_dict[alt_title]

// /datum/job/donor/after_spawn(mob/living/carbon/human/H)
// 	. = ..()



// Делаем "обходку" для профессий выбранных через job.alt_titles (например DONOR)
/datum/controller/subsystem/jobs/EquipRank(mob/living/carbon/human/H, rank, joined_late = 0) // Equip and put them in an area
	if(!H)
		return null

	if(H.mind.role_alt_title in GLOB.all_donor_jobs)
		rank = H.mind.role_alt_title

	. = ..(H, rank, joined_late)

/datum/job/donor/tier_1
	title = "Т1 роль"
	flag = JOB_DONOR_TIER_1
	hidden_from_job_prefs = FALSE
	outfit = /datum/outfit/job/donor/tier_1
/datum/outfit/job/donor/tier_1
	name = "Т1 роль"
	jobtype = /datum/job/donor/tier_1

/datum/job/donor/tier_1/New()
	. = ..()
	alt_titles = GLOB.donor_tier_1_jobs







// /datum/outfit/job/donor/tier_1/pre_equip(mob/living/carbon/human/H, visualsOnly)
// 	. = ..()

// 	if(!H.mind)
// 		return

// 	if(!H.mind.role_alt_title || H.mind.role_alt_title == name)
// 		H.mind.role_alt_title = pick(GLOB.jobs_relate_dict)

// 	switch(H.mind.role_alt_title)
// 		if("Заключенный")
// 			uniform = /obj/item/clothing/under/color/orange/prison
// 		if("Тест")
// 			//jobtype.relate_job = "Security Officer"	// relate spawn point
// 			uniform = /obj/item/clothing/under/color/red










// ТЕСТ

/datum/job/donor/prisoner
	title = "Prisoner"
	relate_job = "Security Officer"
	outfit = /datum/outfit/job/donor/prisoner
/datum/outfit/job/donor/prisoner
	name = "Prisoner"
	jobtype = /datum/job/donor/prisoner
	uniform = /obj/item/clothing/under/color/orange/prison

/datum/job/donor/test
	title = "Test"
	relate_job = "Security Officer"
	outfit = /datum/outfit/job/donor/test
/datum/outfit/job/donor/test
	name = "Test"
	jobtype = /datum/job/donor/test
	uniform = /obj/item/clothing/under/color/red




/datum/job/donor/seclown
	title = "Security Clown"		// + клоун детектив, + клоун-варден
	relate_job = "Security Officer"
	outfit = /datum/outfit/job/donor/seclown
/datum/outfit/job/donor/seclown
	name = "Security Clown"
	jobtype = /datum/job/donor/seclown

	uniform = /obj/item/clothing/under/rank/civilian/clown
	suit = /obj/item/clothing/suit/armor/vest/warden/alt
	shoes = /obj/item/clothing/shoes/clown_shoes
	head = /obj/item/clothing/head/warden
	mask = /obj/item/clothing/mask/gas/clown_hat
	l_pocket = /obj/item/bikehorn
	suit_store = /obj/item/gun/energy/clown
	l_ear = /obj/item/radio/headset/headset_service
	r_ear = /obj/item/radio/headset/headset_sec/alt
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	id = /obj/item/card/id/clown
	pda = /obj/item/pda/clown
	backpack_contents = list(
		/obj/item/reagent_containers/food/snacks/grown/banana = 1,
		/obj/item/stamp/clown = 1,
		/obj/item/toy/crayon/rainbow = 1,
		/obj/item/storage/fancy/crayons = 1,
		/obj/item/reagent_containers/spray/waterflower = 1,
		/obj/item/reagent_containers/food/drinks/bottle/bottleofbanana = 1,
		/obj/item/instrument/bikehorn = 1,
		/obj/item/flash = 1,
		/obj/item/restraints/handcuffs/twimsts = 1,
	)

	implants = list(/obj/item/implant/sad_trombone, /obj/item/implant/mindshield)

	backpack = /obj/item/storage/backpack/clown
	satchel = /obj/item/storage/backpack/clown
	dufflebag = /obj/item/storage/backpack/duffel/clown









// /datum/job/donor/
// 	title = "Заключенный"
// 	flag = JOB_PRISON
// 	outfit = /datum/outfit/job/donor/

// /datum/outfit/job/donor/
// 	name = "Заключенный"
// 	jobtype = /datum/job/donor/
