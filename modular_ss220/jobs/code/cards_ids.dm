// Для отрисовки ХУД'ов.
GLOBAL_LIST_INIT(Jobs_SS220, list("intern", "cadet", "trainee", "student"))
GLOBAL_LIST_INIT(Jobs_titles_SS220, Jobs_novice_titles_SS220)
GLOBAL_LIST_INIT(Jobs_novice_titles_SS220, list("Intern", "Security Cadet", "Trainee Engineer", "Student Scientist"))

/proc/get_all_medical_novice_titles()
	return list("Intern", "Medical Assistant", "Student Medical Doctor")

/proc/get_all_security_novice_titles()
	return list("Security Cadet", "Security Assistant", "Security Graduate")

/proc/get_all_engineering_novice_titles()
	return list("Trainee Engineer", "Engineer Assistant", "Technical Assistant", "Engineer Student", "Technical Student", "Technical Trainee")

/proc/get_all_science_novice_titles()
	return list("Student Scientist", "Scientist Assistant", "Scientist Pregraduate", "Scientist Graduate", "Scientist Postgraduate")

/proc/get_all_novice_titles()
	return get_all_medical_novice_titles() + get_all_security_novice_titles() + get_all_engineering_novice_titles() + get_all_science_novice_titles()

/mob/living/carbon/human/sec_hud_set_ID()
	var/image/holder = hud_list[ID_HUD]
	holder.icon = 'icons/mob/hud/sechud.dmi'
	if(wear_id && (wear_id.get_job_name() in GLOB.Jobs_SS220))
		holder.icon = 'modular_ss220/jobs/icons/hud.dmi'
	. = ..()

/obj/item/get_job_name() //Used in secHUD icon generation
	var/assignmentName = get_ID_assignment(if_no_id = "Unknown")
	var/rankName = get_ID_rank(if_no_id = "Unknown")

	var/novmed = get_all_medical_novice_titles()
	var/novsec = get_all_security_novice_titles()
	var/noveng = get_all_engineering_novice_titles()
	var/novrnd = get_all_science_novice_titles()

	if((assignmentName in novmed) || (rankName in novmed))
		return "intern"
	if((assignmentName in novsec) || (rankName in novsec))
		return "cadet"
	if((assignmentName in noveng) || (rankName in noveng))
		return "trainee"
	if((assignmentName in novrnd) || (rankName in novrnd))
		return "student"

	. = ..()

/obj/machinery/computer/card/ui_data(mob/user)
	var/list/data = ..()

	if(mode == IDCOMPUTER_SCREEN_TRANSFER) // JOB TRANSFER
		if(modify && scan && !target_dept)
			data["jobs_engineering"] |= "Trainee Engineer"
			data["jobs_medical"] |= "Intern"
			data["jobs_science"] |= "Student Scientist"
			data["jobs_security"] |= "Security Cadet"
			data["card_skins"] |= format_card_skins(GLOB.Jobs_SS220) // + format_card_skins(list("intern", "cadet", "trainee", "student"))

	return data

/obj/machinery/computer/card/ui_act(action, params)
	var/is_alt_title_rewrite = FALSE
	var/job_alt_tittle
	switch(action)
		if("assign") // transfer to a new job
			if(!modify)
				return

			job_alt_tittle = params["assign_target"]
			if(job_alt_tittle in GLOB.Jobs_novice_titles_SS220)
				//for fast find job without check all jobs (!!!for alt_titles job with icon like novice roles!!!)
				var/list/dictionary = list(
					"Intern" = /datum/job/doctor,
					"Security Cadet" = /datum/job/officer,
					"Trainee Engineer" = /datum/job/engineer,
					"Student Scientist" = /datum/job/scientist,
				)
				var/job_type = dictionary[job_alt_tittle]
				var/datum/job/job
				if(!job_type)	// gatto
					return
				job = new job_type

				if(job && length(job.alt_titles) && (job_alt_tittle in job.alt_titles))
					params["assign_target"] = job.title
					is_alt_title_rewrite = TRUE
					qdel(job)

	. = ..()

	if(is_alt_title_rewrite)
		modify.assignment = job_alt_tittle
		regenerate_id_name()

	switch(action)
		if("skin")
			if(!modify)
				return FALSE
			var/skin = params["skin_target"]
			if(!skin || !(skin in GLOB.Jobs_SS220))
				return FALSE

			modify.icon_state = skin
			return TRUE

/obj/item/card/id/medical/intern
	name = "Intern ID"
	registered_name = "Intern"
	icon = 'modular_ss220/aesthetics/better_ids/icons/better_ids.dmi'
	icon_state = "intern"
	item_state = "intern-id"
	rank = "Intern"

/obj/item/card/id/research/student
	name = "Student ID"
	registered_name = "Student"
	icon = 'modular_ss220/aesthetics/better_ids/icons/better_ids.dmi'
	icon_state = "student"
	item_state = "student-id"

/obj/item/card/id/engineering/trainee
	name = "Trainee ID"
	registered_name = "Trainee"
	icon = 'modular_ss220/aesthetics/better_ids/icons/better_ids.dmi'
	icon_state = "trainee"
	item_state = "trainee-id"

/obj/item/card/id/security/cadet
	name = "Cadet ID"
	registered_name = "Cadet"
	icon = 'modular_ss220/aesthetics/better_ids/icons/better_ids.dmi'
	icon_state = "cadet"
	item_state = "cadet-id"
