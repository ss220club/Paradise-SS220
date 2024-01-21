/*
Verbs related to getting fucking jacked, bro
Порт и небольшой рефактор с дополнениями отжиманий с CM + прикручивание зависимости от часов
*/

/datum/emote/pushup
	key = "pushup"
	key_third_person = "pushups"
	//message = "пытается отжаться!"
	hands_use_check = TRUE
	emote_type = EMOTE_VISIBLE | EMOTE_FORCE_NO_RUNECHAT  // Don't need an emote to see that
	mob_type_allowed_typecache = list(/mob/living, /mob/dead/observer)
	mob_type_blacklist_typecache = list(/mob/living/brain, /mob/camera, /mob/living/silicon/ai)
	mob_type_ignore_stat_typecache = list(/mob/dead/observer)

	var/staminaloss_per_pushup = 5 // дефолтное значение без модификаторов

	var/stamina_border_max = 95 // 100 - стаминакрит сбрасывающий анимацию
	var/oxy_border_max = 130
	var/brute_border = 50 // С какого кол-ва отжиманий начнет наносить урон

	var/list/physical_job_exp_types = list(EXP_TYPE_SECURITY, EXP_TYPE_SUPPLY, EXP_TYPE_ENGINEERING)
	var/physical_job_mod = 5 // Модификатор за опыт на профу физической направленности

	var/pushap_div = 3 // Деление чтобы игроки могли в общем счете сделать больше АЧЖУМАНИЙ
	var/pushap_difficulty_level = 30 // Каждые N отжиманий усложняем

/datum/emote/pushup/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return FALSE

	if(isobserver(user))
		execute_pushups(user)
		return

	if(!can_do_pushup(user))
		return

	var/mob/living/L
	if(isliving(user))
		L = user
		// In BYOND-angles 0 is NORTH, 90 is EAST, 180 is SOUTH and 270 is WEST.
		if(L.lying_prev == 90)
			L.forced_look = EAST
		else
			L.forced_look = WEST
	user.visible_message(span_notice("[user] принял упор лежа."), span_notice("Вы приняли упор лежа."), span_notice("Вы слышите шорох."))

	var/choise_list = list(
		"На ноги и руки",
		"На колени",
		"На одной руке",
		"На ноги и руки с хлопком",
		"На одной руке с хлопком",
		"На ноги и руки, медленный",
		"На ноги и руки, очень медленный")
	var/choice = tgui_input_list(user, "Отжимание с каким упором?", "Отжимания", choise_list, 60 SECONDS)
	switch(choice)
		if("На ноги и руки")
			user.visible_message(span_notice("[user] перенес свой вес на руки и ноги."), span_notice("Вы переносите свой вес на руки и ноги."), span_notice("Вы слышите шорох."))
			execute_pushups(user, intentional)
		if("На колени")
			user.visible_message(span_notice("[user] переносит свой вес на колени. Жалкое зрелище."), span_notice("Вы сместили вес на колени. СЛАБАК!"), span_notice("Вы слышите шорох."))
			execute_pushups(user, intentional, on_knees = TRUE)
		if("На одной руке")
			user.visible_message(span_boldnotice("[user] перенес свой вес на ОДНУ РУКУ! Мощно!"), span_boldnotice("Вы переносите свой вес на одну руку. Сильно!"), span_notice("Вы слышите шорох."))
			execute_pushups(user, intentional, one_arm = TRUE)
		if("На ноги и руки с хлопком")
			user.visible_message(span_boldnotice("[user] перенес свой вес на руки и ноги и приготовился для хлопков! Стильно!"), span_boldnotice("Вы переносите свой вес на руки и ноги и приготовились для хлопков. Стильно!"), span_notice("Вы слышите шорох."))
			execute_pushups(user, intentional, clap = TRUE)
		if("На одной руке с хлопком")
			user.visible_message(span_boldnotice("[user] перенес свой вес на ОДНУ РУКУ и приготовил вторую для ХЛОПКА! НЕВЕРОЯТНО!"), span_boldnotice("Вы переносите свой вес на одну руку, а вторую приготовили для хлопка. Невероятно!"), span_notice("Вы слышите шорох."))
			execute_pushups(user, intentional, clap = TRUE, one_arm = TRUE)
		if("На ноги и руки, медленный")
			user.visible_message(span_boldnotice("[user] перенес свой вес на ОДНУ РУКУ и приготовил вторую для ХЛОПКА! НЕВЕРОЯТНО!"), span_boldnotice("Вы переносите свой вес на одну руку, а вторую приготовили для хлопка. Невероятно!"), span_notice("Вы слышите шорох."))
			execute_pushups(user, intentional, time_div = 2)
		if("На ноги и руки, очень медленный")
			user.visible_message(span_boldnotice("[user] перенес свой вес на ОДНУ РУКУ и приготовил вторую для ХЛОПКА! НЕВЕРОЯТНО!"), span_boldnotice("Вы переносите свой вес на одну руку, а вторую приготовили для хлопка. Невероятно!"), span_notice("Вы слышите шорох."))
			execute_pushups(user, intentional, time_div = 4)
		else
			if(L)
				L.clear_forced_look(quiet = TRUE)
			return
	if(L)
		L.clear_forced_look(quiet = TRUE)

/datum/emote/pushup/proc/execute_pushups(mob/user, intentional, time_div = 1, on_knees = FALSE, one_arm = FALSE, clap = FALSE)
	if(!can_do_pushup(user))
		return

	user.PrepareForPushupAnimation()

	if(isobserver(user))	// Госты тоже хотят отжиматься!
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
		currentloss = L.getStaminaLoss() + L.getOxyLoss()
		pushup_value = calculate_valueloss_per_pushup(user, pushups_in_a_row, on_knees, one_arm, clap) / time_div
		var/temp_time_div = (1 - round(L.getOxyLoss()  / 300, 0.05)) / time_div
		if(!user.PushupAnimation(temp_time_div))
			user.visible_message(span_notice("[user] прекратил отжиматься."), span_notice("Вы прекратили отжиматься."), span_notice("Вы слишите шорох."))
			return
		pushups_in_a_row++

		var/pushup_text = get_pushup_message_addition(L, on_knees, one_arm, clap)
		user.visible_message(span_boldnotice("[user] отжимается[pushup_text] - [pushups_in_a_row] раз!"), span_boldnotice("Вы отжимаетесь[pushup_text] - [pushups_in_a_row] раз!"), span_notice("Вы слышите отдышку и шорох."))

		if(clap)
			clap_pushup(L, intentional)

		if((L.getStaminaLoss() + pushup_value) < stamina_border_max)
			L.adjustStaminaLoss(pushup_value)
			continue

		L.setStaminaLoss(stamina_border_max)
		L.adjustOxyLoss(pushup_value)
		if(pushups_in_a_row >= brute_border)
			L.adjustBruteLoss(min(1, pushup_value))
		if(currentloss >= borderloss)
			to_chat(user, span_warning("Вы обессиленные падаете на пол..."))
			return

/atom/proc/PrepareForPushupAnimation()
	var/matrix/matrix = matrix() // All this to make their face actually face the floor... sigh... I hate resting code
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

/atom/proc/PushupAnimation(time_div = 1)
	var/target_y = -5
	var/delay = 0.6 SECONDS / time_div
	var/time_low = 0.2 SECONDS / time_div
	var/time_hight = 0.8 SECONDS / time_div
	animate(src, pixel_y = target_y, time = time_hight, easing = QUAD_EASING) // Down to the floor
	if(!do_after(src, delay, TRUE))
		animate(src, pixel_y = 0, time = time_low, easing = QUAD_EASING)
		return FALSE
	animate(src, pixel_y = 0, time = time_hight, easing = QUAD_EASING) // Back up
	if(!do_after(src, delay, TRUE))
		animate(src, pixel_y = 0, time = time_low, easing = QUAD_EASING)
		return FALSE
	return TRUE

/datum/emote/pushup/proc/can_do_pushup(mob/user)
	if(!user.mind || !user.client)
		return FALSE
	if(isobserver(user))
		return TRUE

	var/mob/living/L = user

	if(L.incapacitated())
		return FALSE

	if(!L.resting || L.buckled)
		to_chat(user, span_warning("Вы не в том положении для отжиманий! Лягте на пол!"))
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
				to_chat(user, span_warning("У вас недостаток конечностей! Как вы собрались отжиматься?!"))
				return FALSE

	return TRUE


/datum/emote/pushup/proc/calculate_valueloss_per_pushup(mob/living/user, pushups_in_a_row = 0, on_knees = FALSE, one_arm = FALSE, clap = FALSE)
	// Humans have 120 stamina
	// Default loss per pushup = 5 stamina
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
	if(clap)
		valueloss += 4

	if(!ishuman(user))
		return max(1, valueloss)

	var/mob/living/carbon/human/H = user

	valueloss += 0.5 * H.age/10
	if(H.wear_suit)
		valueloss += 0.5
	if(H.back)
		valueloss += 0.5

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
				exp_sum += text2num(play_records[exp_type]) / 60 // Конвертируем из минут в часы
	if(is_physical_job)
		exp_sum *= physical_job_mod

	var/list/extremities = list(
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG,
		)
	for(var/zone in extremities)
		var/obj/item/organ/limb = H.get_limb_by_name(zone)
		if(limb.is_robotic())
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

	valueloss += (pushups_in_a_row + 1) / pushap_difficulty_level	// усложняем

	if(valueloss <= 0)
		valueloss = 1

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


	return max(0.1, valueloss / pushap_div)

/datum/emote/pushup/proc/get_pushup_message_addition(mob/living/L, on_knees = FALSE, one_arm = FALSE, clap = FALSE)
	var/message_part = ""
	if(on_knees)
		message_part = " на коленях"
	if(one_arm)
		message_part = " на одной руке"
	if(clap)
		message_part += " с хлопком"
	var/message_oxy = ""
	switch(L.getOxyLoss())
		if(20 to 50)
			message_oxy = " с одышкой"
		if(51 to 100)
			message_oxy = " с тяжелой одышкой"
		if(101 to 130)
			message_oxy = " весь покраснев и выпучив глаза"
		if(131 to INFINITY)
			message_oxy = ", еле держась на руках и прикрыв глаза"
	return "[message_part][message_oxy]"

/datum/emote/pushup/proc/clap_pushup(mob/user, intentional)
	var/clap_sound = pick(
		'modular_ss220/emotes/audio/claps/clap1.ogg',
		'modular_ss220/emotes/audio/claps/clap2.ogg',
		'modular_ss220/emotes/audio/claps/clap3.ogg',
		)
	play_sound_effect(user, intentional, clap_sound, get_volume(user))
