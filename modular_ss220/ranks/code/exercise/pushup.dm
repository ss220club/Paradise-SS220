/*
Verbs related to getting fucking jacked, bro
Порт и небольшой рефактор с дополнениями отжиманий с CM + прикручивание зависимости от часов
*/

/mob/living/carbon/human/verb/emote_pushup()
	set name = "○ Отжимания"
	set category = "Эмоции"
	emote("pushup", intentional = TRUE)

/datum/keybinding/emote/pushup
	linked_emote = /datum/emote/pushup
	name = "Отжимания"

/datum/emote/pushup
	key = "pushup"
	key_third_person = "pushups"
	//message = "пытается отжаться!"
	hands_use_check = TRUE
	emote_type = EMOTE_VISIBLE | EMOTE_FORCE_NO_RUNECHAT  // don't need an emote to see that
	mob_type_allowed_typecache = list(/mob/living, /mob/dead/observer)
	mob_type_blacklist_typecache = list(/mob/living/brain, /mob/camera, /mob/living/silicon/ai)
	mob_type_ignore_stat_typecache = list(/mob/dead/observer)
	var/stamina_border_max = 100
	var/oxy_border_max = 100
	var/staminaloss_per_pushup = 5
	var/physical_job_mod = 5


/datum/emote/pushup/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return FALSE

	if(isobserver(user))
		execute_pushups(user)
		return

	if(!can_do_pushup(user))
		return


	//user.set_face_dir(WEST)
	var/mob/living/L
	if(isliving(user))
		L = user
		//if(L.dir == EAST)
		// if(LYING_DOWN LEFT)
		// if(L.)
		// set_lying_angle(270)
		// lying_angle

		// In BYOND-angles 0 is NORTH, 90 is EAST, 180 is SOUTH and 270 is WEST.
		if(L.lying_prev == 90)
			L.forced_look = EAST
		else
			L.forced_look = WEST
	user.visible_message(span_notice("[user] принял упор лежа."), span_notice("Вы приняли упор лежа."), span_notice("Вы слышите шорох."))

	var/choice = tgui_input_list(user, "Отжимание с каким упором?", "Отжимания", list("На ноги и руки", "На колени", "На одной руке"), 60 SECONDS)
	switch(choice)
		if("На ноги и руки")
			user.visible_message(span_notice("[user] перенес свой вес на руки и ноги."), span_notice("Вы переносите свой вес на руки и ноги"), span_notice("Вы слышите шорох."))
			execute_pushups(user, on_knees = FALSE)
		if("На колени")
			user.visible_message(span_notice("[user] переносит свой вес на колени. Жалкое зрелище."), span_notice("Вы сместили вес на колени. СЛАБАК!"), span_notice("Вы слышите шорох."))
			execute_pushups(user, on_knees = TRUE)
		if("На одной руке")
			user.visible_message(span_boldnotice("[user] перенес свой вес на ОДНУ РУКУ! Мощно!"), span_boldnotice("Вы переносите свой вес на одну руку. Сильно!"), span_notice("Вы слышите шорох."))
			execute_pushups(user, on_knees = FALSE, one_arm = TRUE)
		else
			if(L)
				L.clear_forced_look(quiet = TRUE)
			return
	if(L)
		L.clear_forced_look(quiet = TRUE)

/datum/emote/pushup/proc/execute_pushups(mob/user, on_knees = FALSE, one_arm = FALSE)
	if(!can_do_pushup(user))
		return

	user.PrepareForPushupAnimation()

	if(isobserver(user))	// госты тоже хотят отжиматься!
		user.PushupAnimation()
		return

	var/mob/living/L = user

	var/pushups_in_a_row
	var/pushup_value
	var/currentloss = L.getStaminaLoss() + L.getOxyLoss()
	var/borderloss = stamina_border_max + oxy_border_max
	while(currentloss < borderloss)
		if(!can_do_pushup(user))
			return
		pushup_value = calculate_valueloss_per_pushup(user, on_knees, one_arm)
		if(!user.PushupAnimation())
			user.visible_message(span_notice("[user] прекратил отжиматься."), span_notice("Вы прекратили отжиматься."), span_notice("Вы слишите шорох."))
			return
		pushups_in_a_row++
		var/message_oxy = L.getOxyLoss() >= 0 ? " с тяжелой отдышкой" : ""
		user.visible_message(span_boldnotice("[user] отжимается[message_oxy] - [pushups_in_a_row] раз!"), span_boldnotice("Вы отжимаетесь[message_oxy] - [pushups_in_a_row] раз!"), span_notice("Вы слышите отдышку и шорох."))
		L.adjustStaminaLoss(pushup_value)
		if(L.getStaminaLoss() >= stamina_border_max)
			L.adjustOxyLoss(pushup_value)
			if(currentloss >= borderloss)
				to_chat(user, span_warning("Вы обессиленные падаете на пол..."))
				return

/atom/proc/PrepareForPushupAnimation()
	var/matrix/matrix = matrix() //all this to make their face actually face the floor... sigh... I hate resting code
	switch(dir)
		if(WEST)
			matrix.Turn(270)
		if(EAST)
			matrix.Turn(90)
		else
			if(prob(50))
				dir = EAST
				matrix.Turn(90)
			else
				dir = WEST
				matrix.Turn(270)

/atom/proc/PushupAnimation()
	var/target_y = -5
	var/delay = 0.6 SECONDS
	var/time_low = 0.2 SECONDS
	var/time_hight = 0.8 SECONDS
	animate(src, pixel_y = target_y, time = time_hight, easing = QUAD_EASING) //down to the floor
	if(!do_after(src, delay, TRUE))
		animate(src, pixel_y = 0, time = time_low, easing = QUAD_EASING)
		return FALSE
	animate(src, pixel_y = 0, time = time_hight, easing = QUAD_EASING) //back up
	if(!do_after(src, delay, TRUE))
		animate(src, pixel_y = 0, time = time_low, easing = QUAD_EASING)
		return FALSE
	return TRUE

/datum/emote/pushup/proc/can_do_pushup(mob/user)
	if(isobserver(user))
		return TRUE

	var/mob/living/L = user

	if(L.incapacitated())
		return FALSE

	if(!L.resting || L.buckled)
		to_chat(user, span_warning("Вы не в том положении для отжиманий! Лягте на пол!"))
		return FALSE

	if(L.getStaminaLoss() >= stamina_border_max)
		to_chat(user, span_warning("Вы чувствуете слабость!"))
		return FALSE

	if(!isturf(user.loc))
		to_chat(user, span_warning("Не на что опереться!"))
		return FALSE

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/list/extremities = list(
			BODY_ZONE_L_ARM,
			BODY_ZONE_R_ARM,
			BODY_ZONE_L_LEG,
			BODY_ZONE_R_LEG,
			BODY_ZONE_PRECISE_L_HAND,
			BODY_ZONE_PRECISE_R_HAND,
			BODY_ZONE_PRECISE_L_FOOT,
			BODY_ZONE_PRECISE_R_FOOT,
			)
		for(var/zone in extremities)
			if(!H.get_limb_by_name(zone))
				extremities.Remove(zone)
		if(length(extremities) < 8)
			to_chat(user, span_warning("У вас недостаток конечностей! Как вы собрались отжиматься?!"))
			return FALSE

	return TRUE


/datum/emote/pushup/proc/calculate_valueloss_per_pushup(mob/living/user, on_knees = FALSE, one_arm = FALSE)
	//humans have 120 stamina
	//default loss per pushup = 5 stamina
	if(ismachineperson(user) || isskeleton(user))
		return 0

	var/valueloss = staminaloss_per_pushup

	if(user.getBruteLoss() >= 20)
		valueloss += user.getBruteLoss() / 10
	if(user.nutrition <= NUTRITION_LEVEL_STARVING)
		valueloss += 2
	if(user.health <= ((user.maxHealth / 10) * 9))
		valueloss += 2
	if(on_knees)
		valueloss -= 2
	if(one_arm)
		valueloss += 4
	if(valueloss <= 0)
		valueloss = 1

	if(!ishuman(user))
		return valueloss

	var/mob/living/carbon/human/H = user

	valueloss += 0.5 * H.age/10
	if(H.wear_suit)
		valueloss += 0.5
	if(H.back)
		valueloss += 0.5

	var/list/physical_job_exp_types = list(EXP_TYPE_SECURITY, EXP_TYPE_SUPPLY, EXP_TYPE_ENGINEERING)
	var/is_physical_job = FALSE
	var/list/exp_types = is_physical_job ? physical_job_exp_types : list(EXP_TYPE_CREW)

	var/datum/job/job = SSjobs.GetJob(H.job)
	for(var/exp_type in exp_types)
		if(exp_type in physical_job_exp_types)
			is_physical_job = TRUE
			break
	var/list/play_records = params2list(H.client.prefs.exp)
	var/exp_sum = 0
	if(!job)
		exp_sum = play_records[EXP_TYPE_LIVING]
	else
		for(var/exp_type in job.exp_map)
			if(!(exp_type in exp_types))
				exp_sum += text2num(play_records[exp_type])
	if(is_physical_job)
		exp_sum *= physical_job_mod

	var/list/extremities = list(
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG,
		)
	for(var/zone in extremities)
		if(H.get_limb_by_name(zone).is_robotic())
			valueloss -= 1

	switch(exp_sum)
		if(0 to 50)
			valueloss += 5
		if(51 to 100)
			valueloss += 3
		if(101 to 150)
			valueloss += 1
		if(151 to 300)
			valueloss -= 1
		if(301 to 600)
			valueloss -= 2
		if(601 to 1000)
			valueloss -= 3
		if(1001 to 2000)
			valueloss -= 4
		else
			valueloss -= 5

	if(on_knees)
		valueloss /= 1.5
	if(one_arm)
		valueloss *= 1.5

	if(isgrey(user) || istajaran(user))
		valueloss *= 2
	if(isvulpkanin(user) || iswolpin(user))
		valueloss /= 2
	if(iskidan(user) || isunathi(user))
		valueloss /= 3
	if(isdiona(user))
		valueloss /= 5

	return max(0.5, valueloss)
