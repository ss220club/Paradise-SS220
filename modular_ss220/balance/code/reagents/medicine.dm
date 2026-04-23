/datum/reagent/medicine/syndicate_nanites
	overdose_threshold = 50
	harmless = FALSE

/datum/reagent/medicine/syndicate_nanites/overdose_process(mob/living/M, severity)
	var/update_flags = STATUS_UPDATE_NONE
	update_flags |= M.adjustCloneLoss(1.5 * REAGENTS_EFFECT_MULTIPLIER, FALSE)
	return list(0, update_flags)

/datum/reagent/medicine/adv_lava_extract // Use Only Lux medipen
	name = "Модифицированный Экстракт Лазиса"
	id = "adv_lava_extract"
	description = "Очень дорогое лекарство, которое помогает перекачивать кровь по телу и предотвращает замедление работы сердца, исцеляя пациента в процессе. Передозировка приводит к сердечным приступам."
	reagent_state = LIQUID
	color = "#F5F5F5"
	overdose_threshold = 10
	harmless = FALSE

/atom/movable/screen/alert/adv_lava_extract
	name = "Учащённое сердцебиение"
	desc = "Ваше сердце бьется с огромной силой! Будьте осторожны, чтобы не вызвать сердечный приступ."
	icon = 'modular_ss220/objects/icons/luxpen.dmi'
	icon_state = "penthrite"

/datum/reagent/medicine/adv_lava_extract/on_mob_add(mob/living/carbon/human/user)
	. = ..()
	user.throw_alert("penthrite", /atom/movable/screen/alert/adv_lava_extract)

	if(user.client)
		user.playsound_local(user, 'sound/effects/heartbeat.ogg', 100, TRUE)

/datum/reagent/medicine/adv_lava_extract/on_mob_life(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	update_flags |= M.adjustOxyLoss(-3.5, FALSE)
	update_flags |= M.adjustToxLoss(-2.5, FALSE)
	update_flags |= M.adjustBruteLoss(-3.5, FALSE)
	update_flags |= M.adjustFireLoss(-3, FALSE)
	if(prob(50))
		M.AdjustLoseBreath(-2 SECONDS)
	M.SetConfused(0)
	M.SetSleeping(0)
	if(M.getFireLoss() > 35)
		update_flags |= M.adjustFireLoss(-4, FALSE)
	if(M.health < 0)
		update_flags |= M.adjustToxLoss(-1, FALSE)
		update_flags |= M.adjustBruteLoss(-1, FALSE)
		update_flags |= M.adjustFireLoss(-1, FALSE)
	return ..() | update_flags

/datum/reagent/medicine/adv_lava_extract/overdose_process(mob/living/M, severity)
	var/update_flags = STATUS_UPDATE_NONE
	update_flags |= M.adjustOxyLoss(5, FALSE)
	update_flags |= M.adjustToxLoss(4, FALSE)
	update_flags |= M.adjustBruteLoss(8, FALSE)
	update_flags |= M.adjustFireLoss(8, FALSE)
	update_flags |= M.adjustStaminaLoss(25, FALSE)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.undergoing_cardiac_arrest())
			H.set_heartattack(TRUE)
	return ..() | update_flags

/datum/reagent/medicine/adv_lava_extract/on_mob_delete(mob/living/carbon/human/user)
	. = ..()
	user.clear_alert("penthrite")

	if(user.client)
		user.stop_sound_channel(CHANNEL_HEARTBEAT)

/datum/reagent/medicine/dermalin
	name = "Дермалин"
	id = "dermalin"
	description = "Препарат восстанавливает обожженные ткани, оказывая механическое воздействие на организм; передозировка вызывает сильное воспаление кожи."
	reagent_state = LIQUID
	color = "#eeff00"
	metabolization_rate = 0.4
	overdose_threshold = 15
	harmless = FALSE
	var/list/drug_list = list("crank", "methamphetamine", "space_drugs", "synaptizine", "psilocybin", "ephedrine", "epinephrine", "stimulants", "stimulative_agent", "bath_salts", "lsd", "thc", "mephedrone", "pump_up")
	taste_description = "Сладковато кислый"
	goal_department = "Chemistry"
	goal_difficulty = REAGENT_GOAL_HARD

/datum/reagent/medicine/dermalin/on_mob_life(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	for(var/I in M.reagents.reagent_list)
		var/datum/reagent/R = I
		if(drug_list.Find(R.id))
			M.reagents.remove_reagent(R.id, 5)
	update_flags |= M.adjustFireLoss(-5, FALSE)
	update_flags |= M.adjustStaminaLoss(15, FALSE)
	if(prob(30))
		M.Confused(10 SECONDS)
	if(prob(5))
		M.SetWeakened(6 SECONDS, FALSE)
	return ..() | update_flags

/datum/reagent/medicine/dermalin/overdose_process(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	update_flags |= M.adjustFireLoss(10, FALSE)
	update_flags |= M.adjustStaminaLoss(20, FALSE)
	return ..() | update_flags

/datum/reagent/medicine/bruzin
	name = "Брузин"
	id = "bruzin"
	description = "Препарат восстанавливает серьезные порезы, оказывая нагрузку на организм; передозировка вызывает разрыв тканей."
	reagent_state = LIQUID
	color = "#dd0303"
	metabolization_rate = 0.4
	overdose_threshold = 15
	harmless = FALSE
	var/list/drug_list = list("crank", "methamphetamine", "space_drugs", "synaptizine", "psilocybin", "ephedrine", "epinephrine", "stimulants", "stimulative_agent", "bath_salts", "lsd", "thc", "mephedrone", "pump_up")
	taste_description = "Сладковато мясной"
	goal_department = "Chemistry"
	goal_difficulty = REAGENT_GOAL_HARD

/datum/reagent/medicine/bruzin/on_mob_life(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	for(var/I in M.reagents.reagent_list)
		var/datum/reagent/R = I
		if(drug_list.Find(R.id))
			M.reagents.remove_reagent(R.id, 5)
	update_flags |= M.adjustBruteLoss(-5, FALSE)
	update_flags |= M.adjustStaminaLoss(15, FALSE)
	if(prob(30))
		M.Confused(10 SECONDS)
	if(prob(5))
		M.SetWeakened(6 SECONDS, FALSE)
	return ..() | update_flags

/datum/reagent/medicine/bruzin/overdose_process(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	update_flags |= M.adjustBruteLoss(10, FALSE)
	update_flags |= M.adjustStaminaLoss(20, FALSE)
	return list(0, update_flags)

/datum/chemical_reaction/dermalin
	name = "Дермалин"
	id = "dermalin"
	result = "dermalin"
	required_reagents = list("salglu_solution" = 1, "synthflesh" = 1, "kelotane" = 2, "mitocholide" = 1, "haloperidol" = 1)
	result_amount = 1

/datum/chemical_reaction/bruzin
	name = "Брузин"
	id = "bruzin"
	result = "bruzin"
	required_reagents = list("salglu_solution" = 1, "synthflesh" = 1, "bicaridine" = 2, "mitocholide" = 1, "haloperidol" = 1)
	result_amount = 1

/datum/reagent/medicine/bruzin_pluse
	name = "Брузин плюс"
	id = "bruzin_pluse"
	description = "Продвинутая версия Брузина, лишённая стандартных побочных эффектов ценой ужасающих эффектов при передозе. Экслюзивная разработка синдиката."
	reagent_state = LIQUID
	color = "#dd0303"
	metabolization_rate = 0.4
	overdose_threshold = 30
	harmless = FALSE
	taste_description = "Сладковато мясной"

/datum/reagent/medicine/bruzin_pluse/on_mob_life(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	update_flags |= M.adjustBruteLoss(-5, FALSE)
	return ..() | update_flags

/datum/reagent/medicine/bruzin_pluse/overdose_process(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	update_flags |= M.adjustBruteLoss(15, FALSE)
	update_flags |= M.adjustStaminaLoss(40, FALSE)
	if(prob(70))
		M.Confused(15 SECONDS)
	if(prob(50))
		M.SetWeakened(5 SECONDS, FALSE)
	return list(0, update_flags)

/datum/reagent/medicine/dermalin_pluse
	name = "Дермалин Плюс"
	id = "dermalin_pluse"
	description = "Продвинутая версия Дермалина, лишённая стандартных побочных эффектов ценой ужасающих эффектов при передозе. Экслюзивная разработка синдиката."
	reagent_state = LIQUID
	color = "#eeff00"
	metabolization_rate = 0.4
	overdose_threshold = 30
	harmless = FALSE
	taste_description = "Сладковато кислый"

/datum/reagent/medicine/dermalin_pluse/on_mob_life(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	update_flags |= M.adjustFireLoss(-5, FALSE)
	return ..() | update_flags

/datum/reagent/medicine/dermalin_pluse/overdose_process(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	update_flags |= M.adjustFireLoss(15, FALSE)
	update_flags |= M.adjustStaminaLoss(40, FALSE)
	if(prob(70))
		M.Confused(15 SECONDS)
	if(prob(50))
		M.SetWeakened(5 SECONDS, FALSE)
	return ..() | update_flags
