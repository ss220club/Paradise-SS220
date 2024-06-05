/datum/event/zombie_virus_outbreak
	name = "Zombie virus outbreak"
	var/successful_spawn = FALSE
	var/victims_amount = 5

/datum/event/zombie_virus_outbreak/setup()
	announceWhen = rand(300, 400)

/datum/event/zombie_virus_outbreak/announce(false_alarm)
	if(!successful_spawn && !false_alarm)
		return

	GLOB.major_announcement.Announce(
		"Зафиксированы признаки применения биологического оружия Т-типа, необходимо незамедлительно провести проверку сотрудников станции на наличие инфекции. Настоятельно рекомендуется введение карантина и избежание контактов с потенциально зараженными.",
		"ВНИМАНИЕ: БИОЛОГИЧЕСКАЯ УГРОЗА.",
		'sound/effects/siren-spooky.ogg')

	post_status(STATUS_DISPLAY_ALERT, "biohazard")

/datum/event/zombie_virus_outbreak/start()
	INVOKE_ASYNC(src, PROC_REF(infect_crew))

/datum/event/zombie_virus_outbreak/proc/infect_crew()
	var/list/potential_victims = get_potential_victims()
	if(!length(potential_victims))
		log_and_message_admins("Failed to start `/datum/event/zombie_virus_outbreak` event. Not enough victims.")
		return

	for(var/victim_index in 1 to victims_amount)
		if(!length(potential_victims))
			break

		var/mob/living/carbon/human/victim = pick_n_take(potential_victims)
		victim.AddDisease(new /datum/disease/zombie)
		notify_ghosts(
			message = "[victim] был заражен зомби вирусом",
			title = "Заражение зомби вирусом",
			source = victim,
			flashwindow = TRUE,
			action = NOTIFY_FOLLOW)

	successful_spawn = TRUE

/datum/event/zombie_virus_outbreak/proc/get_potential_victims()
	var/datum/disease/zombie/zombie_virus = new
	var/list/potential_victims = list()
	for(var/mob/living/carbon/human/potential_victim in GLOB.player_list)
		if(!is_station_level(potential_victim.z))
			continue

		if(HAS_TRAIT(potential_victim, TRAIT_I_WANT_BRAINS) || potential_victim.mind?.has_antag_datum(/datum/antagonist/zombie))
			continue

		if(!potential_victim.CanContractDisease(zombie_virus))
			continue

		potential_victims += potential_victim

	return potential_victims


/datum/event_container/major/New()
	. = ..()
	available_events |= new /datum/event_meta(EVENT_LEVEL_MAJOR, "Zombie Virus Outbreak", /datum/event/zombie_virus_outbreak, 20, list(ASSIGNMENT_MEDICAL = 2), TRUE)
