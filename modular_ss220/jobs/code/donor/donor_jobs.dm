/datum/job/donor
	title = "Donor" // он тут быть не должен. Но если педали вдруг выдадут, то пускай хотя бы так
	flag = 0
	total_positions = -1
	spawn_positions = -1
	department_flag = JOBCAT_SUPPORT
	job_department_flags = DEP_FLAG_SERVICE
	supervisors = "the head of personnel"
	department_head = list("Head of Personnel")
	selection_color = "#fbd5ff"
	access = list( ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_MAINT_TUNNELS)
	alt_titles = null
	outfit = /datum/outfit/job/donor
	hidden_from_job_prefs = TRUE
	var/ru_title
	var/donator_tier = 999 // I'm unreachable!

/datum/outfit/job/donor
	name = "Donor"
	jobtype = /datum/job/donor

	uniform = /obj/item/clothing/under/color/random
	shoes = /obj/item/clothing/shoes/black
	pda = /obj/item/pda
	id = /obj/item/card/id/assistant

// ====================================
// Пустышки для выбора роли
/datum/job/donor/tier_1
	title = "Т1 должность"
	flag = JOB_DONOR_TIER_1
	hidden_from_job_prefs = FALSE
	total_positions = 5
	spawn_positions = 5
	donator_tier = 1

/datum/job/donor/tier_1/New()
	. = ..()
	alt_titles = GLOB.donor_tier_1_jobs


/datum/job/donor/tier_2
	title = "Т2 должность"
	flag = JOB_DONOR_TIER_2
	hidden_from_job_prefs = FALSE
	total_positions = 8
	spawn_positions = 5
	donator_tier = 2

/datum/job/donor/tier_2/New()
	. = ..()
	alt_titles = GLOB.donor_tier_2_jobs


/datum/job/donor/tier_3
	title = "Т3 должность"
	flag = JOB_DONOR_TIER_3
	hidden_from_job_prefs = FALSE
	total_positions = 8
	spawn_positions = 5
	donator_tier = 3

/datum/job/donor/tier_3/New()
	. = ..()
	alt_titles = GLOB.donor_tier_3_jobs


/datum/job/donor/tier_4
	title = "Т4 должность"
	flag = JOB_DONOR_TIER_4
	hidden_from_job_prefs = FALSE
	total_positions = 4
	spawn_positions = 4
	donator_tier = 4

/datum/job/donor/tier_4/New()
	. = ..()
	alt_titles = GLOB.donor_tier_4_jobs


/datum/job/donor/tier_5
	title = "Т5 должность"
	flag = JOB_DONOR_TIER_5
	hidden_from_job_prefs = FALSE
	total_positions = 3
	spawn_positions = 3
	donator_tier = 5

/datum/job/donor/tier_5/New()
	. = ..()
	alt_titles = GLOB.donor_tier_5_jobs


// ====================================
// Переводим должность и предлагаем взять альтернативную должность
/datum/job/donor/after_spawn(mob/living/carbon/human/H)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(after_donor_spawn), H)

/datum/job/donor/proc/after_donor_spawn(mob/living/carbon/human/H)
	choose_id_assignment(H)
	for(var/datum/data/record/R in GLOB.data_core.general)
		if(R && H.real_name == R.fields["name"])
			R.fields["real_rank"] = H.mind.role_alt_title
			R.fields["rank"] = H.wear_id.get_ID_assignment()
			break

/datum/job/donor/proc/choose_id_assignment(mob/living/carbon/human/H)
	var/obj/item/card/id/id = H.wear_id

	if(ru_title && !length(alt_titles) && id)
		id.assignment = ru_title
		id.UpdateName()
		after_assignment_equip(H, id.assignment)
		return

	var/list/all_alt_titles = get_all_titles()
	if(!all_alt_titles)
		return

	var/time_minutes = 5
	var/alt_title = tgui_input_list(H, "Выберите название вашей должности. Если вы не выберете в течении [time_minutes] минут, то будет установлена стандартная должность.", "Специальная должность", all_alt_titles, time_minutes MINUTES)
	if(alt_title && id)
		id.assignment = alt_title
		id.UpdateName()
		after_assignment_equip(H, id.assignment)

/// Одеваем после выбора роли. Временное решение пока как положено не сделаю модульные джобки при выборе в преференсах
/datum/job/donor/proc/after_assignment_equip(mob/living/carbon/human/H, assignment)
	return

/datum/job/donor/proc/get_all_titles()
	var/list/all_alt_titles = list()
	if(alt_titles)
		all_alt_titles.Add(title)
		if(ru_title)
			all_alt_titles.Add(ru_title)
		all_alt_titles |= alt_titles
	return all_alt_titles

// Проверка после начала раунда
/mob/new_player/IsJobAvailable(rank)
	if(rank in get_donor_ranks_for_choose())
		var/datum/job/job = SSjobs.GetJob(rank)
		if(!job)
			return FALSE
		if(!job.is_donor_allowed(client))
			return FALSE
	. = ..()

/datum/job/proc/is_donor_allowed(client/C)
	return TRUE

/datum/job/donor/is_donor_allowed(client/C)
	if(!C)
		return FALSE // No client
	return C.is_donor_allowed(donator_tier)
