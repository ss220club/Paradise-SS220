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
	metabolization_rate = 1.5
	overdose_threshold = 15
	harmless = FALSE
	taste_description = "Сладковато кислый"
	goal_department = "Chemistry"
	goal_difficulty = REAGENT_GOAL_HARD

/datum/reagent/medicine/dermalin/on_mob_life(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	update_flags |= M.adjustFireLoss(-5, FALSE)
	update_flags |= M.adjustStaminaLoss(5, FALSE)
	return ..() | update_flags

/datum/reagent/medicine/dermalin/overdose_process(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	update_flags |= M.adjustFireLoss(10, FALSE)
	update_flags |= M.adjustStaminaLoss(7.5, FALSE)
	return ..() | update_flags

/datum/reagent/medicine/bruzin
	name = "Брузин"
	id = "bruzin"
	description = "Препарат восстанавливает серьезные порезы, оказывая нагрузку на организм; передозировка вызывает разрыв тканей."
	reagent_state = LIQUID
	color = "#dd0303"
	metabolization_rate = 1.5
	overdose_threshold = 15
	harmless = FALSE
	taste_description = "Сладковато мясной"
	goal_department = "Chemistry"
	goal_difficulty = REAGENT_GOAL_HARD

/datum/reagent/medicine/bruzin/on_mob_life(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	update_flags |= M.adjustBruteLoss(-5, FALSE)
	update_flags |= M.adjustStaminaLoss(5, FALSE)
	return ..() | update_flags

/datum/reagent/medicine/bruzin/overdose_process(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	update_flags |= M.adjustBruteLoss(10, FALSE)
	update_flags |= M.adjustStaminaLoss(7.5, FALSE)
	return list(0, update_flags)

/datum/chemical_reaction/dermalin
	name = "Дермалин"
	id = "dermalin"
	result = "dermalin"
	required_reagents = list("salglu_solution" = 1, "synthflesh" = 1, "kelotane" = 2, "mitocholide" = 1, "omnizine" = 1)
	result_amount = 1

/datum/chemical_reaction/bruzin
	name = "Брузин"
	id = "bruzin"
	result = "bruzin"
	required_reagents = list("salglu_solution" = 1, "synthflesh" = 1, "bicaridine" = 2, "mitocholide" = 1, "omnizine" = 1)
	result_amount = 1

//MARK: Роботические наркотики
// Сделано для роботов, От роботов.

// Роботизированная трава. Сочетает в себе эффекты КБД и ТГК.
/datum/reagent/w33d
	name = "В33Д"
	id = "w33d"
	description = "Густая маслянистая смесь, предназначенная для имитации действия каннабиса в синтетических препаратах. \
	По счастливому совпадению, после высыхания она также может использоваться в качестве пригодного наполнителя, герметика и изолятора.."
	reagent_state = LIQUID
	color = "#17dd17"
	overdose_threshold = 30
	process_flags = SYNTHETIC
	taste_description = "Чувак, это просто лучшее и самое расслабляющее занятие на свете!"

/datum/reagent/w33d/on_mob_life(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	if(prob(10))
		M.AdjustStuttering(rand(0, 6 SECONDS))
	if(prob(5))
		M.emote(pick("hsigh", "giggle", "laugh", "smile"))
	if(prob(5))
		to_chat(M, "<span class='notice'>[pick("Ты чувствуешь себя спокойно.", "Ты тихо жужжишь.", "Ты чувствуешь себя расслабленно.", "Ты наслаждаешься атмосферой.")]</span>")
	if(prob(4))
		M.Confused(20 SECONDS)
	if(prob(10))
		M.AdjustConfused(-10 SECONDS)
		M.SetWeakened(0, FALSE)
	if(prob(25))
		if(ishuman(M))
			var/mob/living/carbon/human/dude = M
			update_flags |= dude.adjustBruteLoss(-4, FALSE, robotic = TRUE)
			update_flags |= dude.adjustFireLoss(-4, FALSE, robotic = TRUE)
	if(volume >= 50 && prob(25))
		if(prob(10))
			M.Drowsy(20 SECONDS)
	return ..() | update_flags

/datum/reagent/w33d/overdose_process(mob/living/M, severity)
	var/update_flags = STATUS_UPDATE_NONE
	update_flags |= M.adjustBruteLoss(3, FALSE)
	update_flags |= M.adjustFireLoss(3, FALSE)
	update_flags |= M.adjustBrainLoss(1, FALSE)
	update_flags |= M.adjustStaminaLoss(5, FALSE)
	return list(0, update_flags)

// Robot Krokodil
/datum/reagent/grokodil
	name = "Грокодил"
	id = "grokodil"
	description = "Экспериментальное соединение, созданное в темных переулках Нью-Кэнана, призвано имитировать действие Крокодила в синтетических материалах. \
	К сожалению, это сработало слишком хорошо, поскольку также точно воспроизводит тот факт, что у него есть серьезные побочные эффекты. \
	Чрезмерное потребление вызовет сильную коррозию и сочетание эндотермических и экзотермических реакций, которые приведут к локальному плавлению и общему снижению температуры."
	color = "#212121"
	process_flags = SYNTHETIC
	overdose_threshold = 20
	addiction_chance = 10
	addiction_threshold = 10
	taste_description = "Очень неудачный жизненный выбор"
	allowed_overdose_process = TRUE
	goal_department = "Science"
	goal_difficulty = REAGENT_GOAL_HARD

/datum/reagent/grokodil/on_mob_life(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	M.AdjustJitter(-80 SECONDS)
	if(prob(25))
		M.emote(pick("smile", "grin", "chuckle", "laugh"))
	if(prob(15))
		to_chat(M, "<span class='notice'>Ты чувствуешь себя довольно спокойно.</span>")
		M.bodytemperature--
		M.emote("smile")
	if(prob(30))
		to_chat(M, "<span class='warning'>Ты слишком расслаблен</span>")
		M.emote(pick("shiver", "cross"))
		update_flags |= M.adjustBruteLoss(2, FALSE)
		update_flags |= M.adjustFireLoss(2, FALSE)
		update_flags |= M.adjustBrainLoss(3, FALSE)
		update_flags |= M.adjustStaminaLoss(-50, FALSE)
		M.bodytemperature -= 20
	if(prob(2))
		to_chat(M, "<span class='warning'>На корпусе вашего шасси появляются пятна коррозии.!</span>")
		update_flags |= M.adjustBruteLoss(2, FALSE)
	return ..() | update_flags

/datum/reagent/grokodil/overdose_process(mob/living/M, severity)
	var/list/overdose_info = ..()
	var/effect = overdose_info[REAGENT_OVERDOSE_EFFECT]
	var/update_flags = overdose_info[REAGENT_OVERDOSE_FLAGS]
	if(severity == 1)
		if(effect <= 2)
			M.visible_message("<span class='warning'>[M] выглядит ошеломлённым!</span>")
			M.Stun(6 SECONDS)
			do_sparks(5, FALSE, M)
			M.emote("stare")
		else if(effect <= 4)
			M.emote("shiver")
			M.bodytemperature -= 40
		else if(effect <= 7)
			to_chat(M, "<span class='warning'>Корпус и внутренние компоненты вашего шасси подвергаются коррозии.!</span>")
			update_flags |= M.adjustBruteLoss(5, FALSE)
			update_flags |= M.adjustFireLoss(2, FALSE)
			update_flags |= M.adjustBrainLoss(1, FALSE)
			M.emote("cry")
		return list(effect, update_flags)

	if(severity == 2)
		if(effect <= 2)
			M.visible_message(
				"<span class='warning'>[M] качается и падает!</span>",
				"<span class='warning'>Ты покачиваешься и падаешь!</span>"
			)
			update_flags |= M.adjustBruteLoss(3, FALSE)
			update_flags |= M.adjustBrainLoss(3, FALSE)
			M.Weaken(16 SECONDS)
			M.emote("faint")
		else if(effect <= 4)
			M.visible_message(
				"<span class='danger'>На корпусе появляются крупные трещины [M]'s и окружающая область начинает плавиться!</span>",
				"<span class='userdanger'>На корпусе появляются крупные трещины и окружающая область начинает плавиться!</span>"
			)
			update_flags |= M.adjustBruteLoss(25, FALSE)
			update_flags |= M.adjustFireLoss(25, FALSE) // We can't husk a robot. So we substitute with some extra melt damage.
			M.emote("scream")
			M.emote("faint")
		else if(effect <= 7)
			M.emote("shiver")
			M.bodytemperature -= 70
	return list(effect, update_flags)

/datum/chemical_reaction/w33d
	name = "В33Д"
	id = "w33d"
	result = "w33d"
	required_reagents = list("synthanol" = 1, "oil" = 1, "aluminum" = 1)
	result_amount = 3
	mix_message = "Смесь вспенивается, превращаясь в ярко-зеленое масло с мускусным запахом.."

/datum/chemical_reaction/grokodil
	name = "Грокодил"
	id = "grokodil"
	result = "grokodil"
	required_reagents = list("mutadone" = 1, "heparin" = 1, "cleaner" = 1, "phenol" = 1, "w33d" = 1)
	result_amount = 5
	mix_message = "Из раствора выпадает полутвердый черный порошок."
	min_temp = T0C + 100
	mix_sound = 'sound/goonstation/misc/fuse.ogg'
