/obj/machinery/computer/arcade/recruiter/Initialize(mapload)
	. = ..()
	jobs |= GLOB.jobs_positions_ss220 + get_all_alt_titles_ss220()
	incorrect_jobs |= list(
		"Medical Sasistant", "Shitcurity Cadet", "Traneer Enginer", "Assistant Captain", "Engineer Cadet",
		"Traine Engener", "Intarn", "Entern", "Student Directar", "Head of Scientest", "Junior Codet"
		)

/obj/effect/mob_spawn/human/intern
	name = "Intern"
	mob_name = "Intern"
	id_job = "Intern"
	outfit = /datum/outfit/job/doctor/intern

/obj/effect/mob_spawn/human/trainee
	name = "Trainee Engineer"
	mob_name = "Trainee Engineer"
	id_job = "Trainee Engineer"
	outfit = /datum/outfit/job/engineer/trainee

/obj/effect/mob_spawn/human/student
	name = "Student Scientist"
	mob_name = "Student Scientist"
	id_job = "Student Scientist"
	outfit = /datum/outfit/job/scientist/student

/obj/effect/mob_spawn/human/cadet
	name = "Security Cadet"
	mob_name = "Security Cadet"
	id_job = "Security Cadet"
	outfit = /datum/outfit/job/officer/cadet

/datum/species/plasmaman/before_equip_job(datum/job/J, mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	var/current_job = J.title
	var/datum/outfit/plasmaman/O = new /datum/outfit/plasmaman
	switch(current_job)

		if("Security Cadet")
			O = new /datum/outfit/plasmaman/security

		if("Intern")
			O = new /datum/outfit/plasmaman/medical

		if("Student Scientist")
			O = new /datum/outfit/plasmaman/science

		if("Trainee Engineer")
			O = new /datum/outfit/plasmaman/engineering

	H.equipOutfit(O, visualsOnly)
	H.internal = H.r_hand
	H.update_action_buttons_icon()
	return FALSE
