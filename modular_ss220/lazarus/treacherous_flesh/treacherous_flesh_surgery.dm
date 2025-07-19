/datum/surgery/check_anomalies
	name = "Поиск аномалий"
	steps = list(
		/datum/surgery_step/generic/cut_open,
		/datum/surgery_step/generic/clamp_bleeders,
		/datum/surgery_step/generic/retract_skin,
		/datum/surgery_step/proxy/open_organ,
		/datum/surgery_step/open_encased/saw,
		/datum/surgery_step/open_encased/retract,
		/datum/surgery_step/proxy/check_anomalies,
		/datum/surgery_step/glue_bone,
		/datum/surgery_step/set_bone,
		/datum/surgery_step/finish_bone,
		/datum/surgery_step/proxy/open_organ,
		/datum/surgery_step/generic/cauterize
	)
	possible_locs = list(BODY_ZONE_CHEST)
	requires_organic_bodypart = TRUE
	requires_bodypart = TRUE

/datum/surgery_step/proxy/check_anomalies
	name = "поиск аномалий (proxy)"
	branches = list(/datum/surgery/intermediate/check_anomalies)

/datum/surgery/intermediate/check_anomalies
	possible_locs = list(BODY_ZONE_CHEST)
	requires_organic_bodypart = TRUE
	requires_bodypart = TRUE
	steps = list(/datum/surgery_step/check_anomalies)

/datum/surgery_step/check_anomalies
	name = "поиск аномалий"
	allowed_tools = list(TOOL_HEMOSTAT = 100)
	time = 10 SECONDS

/datum/surgery_step/check_anomalies/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/confirm = alert(user, "Вы уверены, что хотите изъять 'аномалию' из тела пациента? Если он не заражён, это нанесёт серьёзный урон.","Достать аномалию?","Да","Нет")
	if(confirm != "Да")
		return SURGERY_BEGINSTEP_ABORT
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(
		"<span class='notice'>[user] начал копаться во внутренностях [affected] при помощи [tool].</span>",
		"<span class='notice'>Вы начали искать аномалии внутри [affected] при помощи [tool].</span>",
		chat_message_type = MESSAGE_TYPE_COMBAT
	)
	return ..()

/datum/surgery_step/check_anomalies/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(target.treacherous_flesh)
		user.visible_message(
			"<span class='boldwarning'>[user] вытаскивает из тела [affected] нечто ужасное!</span>",
			"<span class='boldwarning'>Вы вытаскиваете из тела [affected] нечто ужасное!</span>",
			chat_message_type = MESSAGE_TYPE_COMBAT
		)
		target.emote("scream")
		target.adjustStaminaLoss(100)
		var/mob/living/simple_animal/hostile/flesh_biomorph/lesser/M
		switch(target.treacherous_flesh.evolution_stage)
			if(EVOLUTION_STAGE_0 to EVOLUTION_STAGE_1)
				target.adjustBruteLoss(60)
				M = new /mob/living/simple_animal/hostile/flesh_biomorph/lesser/small(target.loc)
			if(EVOLUTION_STAGE_2)
				target.adjustBruteLoss(120)
				M = new /mob/living/simple_animal/hostile/flesh_biomorph/lesser/medium(target.loc)
			if(EVOLUTION_STAGE_3 to EVOLUTION_STAGE_4)
				target.adjustBruteLoss(200)
				M = new /mob/living/simple_animal/hostile/flesh_biomorph/lesser/large(target.loc)
		M.client = target.treacherous_flesh.client
		target.treacherous_flesh.disinfest()
	else
		user.visible_message(
			"<span class='boldwarning'>[user] начинает доставать из тела [affected] кусок его селезёнки!.</span>",
			"<span class='boldwarning'>УПС!!! Похоже это было что-то важное!</span>",
			chat_message_type = MESSAGE_TYPE_COMBAT
		)
		target.emote("scream")
		target.adjustStaminaLoss(100)
		target.adjustBruteLoss(50)
		target.adjustCloneLoss(25)
	return SURGERY_STEP_CONTINUE

#undef EVOLUTION_STAGE_0
#undef EVOLUTION_STAGE_1
#undef EVOLUTION_STAGE_2
#undef EVOLUTION_STAGE_3
#undef EVOLUTION_STAGE_4
