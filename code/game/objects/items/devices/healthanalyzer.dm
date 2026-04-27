#define SIMPLE_HEALTH_SCAN 0
#define DETAILED_HEALTH_SCAN 1
/proc/get_chemscan_results(mob/living/user, mob/living/M)
	var/msgs = list()
	if(!ishuman(M))
		return
	var/hallucinating = HAS_TRAIT(user, TRAIT_MED_MACHINE_HALLUCINATING)
	var/mob/living/carbon/human/H = M
	var/has_real_or_fake_reagents = FALSE
	if(length(H.reagents.reagent_list))
		has_real_or_fake_reagents = TRUE
		msgs += SPAN_BOLDNOTICE("В субъекте обнаружены следующие реагенты:")
		for(var/datum/reagent/R in H.reagents.reagent_list)
			var/volume = R.volume
			var/overdosing = R.overdosed
			if(hallucinating)
				if(prob(20))
					// make reagents look like they may exist in really crazy amounts, but also disappear
					volume = max(rand(hallucinating - 10, hallucinating + 100), 0)
				if(!volume)
					continue
				if(!overdosing)
					overdosing = prob(10)
			msgs += SPAN_NOTICE("[volume]ю. [R.name][overdosing ? "</span> - [SPAN_BOLDANNOUNCEIC("ПЕРЕДОЗИРОВКА")]" : "."]")
	if(hallucinating && prob(10))
		has_real_or_fake_reagents = TRUE
		if(!length(H.reagents.reagent_list))
			msgs += SPAN_BOLDNOTICE("В субъекте обнаружены следующие реагенты:")
			for(var/i in 1 to rand(1, 2))
				var/reagent_name = pick(GLOB.chemical_reagents_list)
				msgs += SPAN_NOTICE("[rand(5, 100)]ю. [GLOB.chemical_reagents_list[reagent_name]][prob(30) ? " - ПЕРЕДОЗИРОВКА" : "."]")
	if(!has_real_or_fake_reagents)
		msgs += SPAN_NOTICE("Субъект не содержит реагентов.")
	if(length(H.reagents.addiction_list))
		msgs += SPAN_DANGER("Субъект зависим от следующих реагентов:")
		for(var/datum/reagent/R in H.reagents.addiction_list)
			msgs += SPAN_DANGER("[R.name] Стадия: [R.addiction_stage]/5")
	if(hallucinating && prob(10))
		if(!length(H.reagents.addiction_list))
			msgs += SPAN_DANGER("Субъект зависим от следующих реагентов:")
			// try to add two random chems
			for(var/i in 1 to rand(1, 2))
				var/reagent_name = pick(GLOB.chemical_reagents_list)
				msgs += SPAN_DANGER("[GLOB.chemical_reagents_list[reagent_name]] Стадия: [rand(1, 5)]/5")
	return msgs

/proc/chemscan(mob/living/user, mob/living/M)
	if(ishuman(M))
		var/list/results = get_chemscan_results(user, M)
		to_chat(user, results.Join("<br>"))

/obj/item/healthanalyzer
	name = "health analyzer"
	desc = "Ручной сканер тела, способный распознавать жизненно важные показатели пациента."
	icon = 'icons/obj/device.dmi'
	icon_state = "health"
	worn_icon_state = "healthanalyzer"
	inhand_icon_state = "healthanalyzer"
	belt_icon = "health_analyzer"
	flags = CONDUCT | NOBLUDGEON
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	materials = list(MAT_METAL = 200)
	origin_tech = "magnets=1;biotech=1"
	/// Can be SIMPLE_HEALTH_SCAN (damage is only shown as a single % value), or DETAILED_HEALTH_SCAN (shows the % value and also damage for every specific limb).
	var/mode = DETAILED_HEALTH_SCAN
	/// Is the health analyzer upgraded? Allows reagents in the body to be seen.
	var/advanced = FALSE

/obj/item/healthanalyzer/examine(mob/user)
	. = ..()
	. += SPAN_NOTICE("Используйте [src.declent_ru(NOMINATIVE)] в руке чтобы включить детализацию повреждений.")

/obj/item/healthanalyzer/attack_self__legacy__attackchain(mob/user)
	mode = !mode
	switch(mode)
		if(DETAILED_HEALTH_SCAN)
			to_chat(user, SPAN_NOTICE("Теперь [src.declent_ru(NOMINATIVE)] показывает повреждения каждой конечности."))
		if(SIMPLE_HEALTH_SCAN)
			to_chat(user, SPAN_NOTICE("[capitalize(src.declent_ru(NOMINATIVE))] больше не показывает повреждения каждой конечности."))

/obj/item/healthanalyzer/attack__legacy__attackchain(mob/living/M, mob/living/user)
	if((HAS_TRAIT(user, TRAIT_CLUMSY) || user.getBrainLoss() >= 60) && prob(50))
		var/list/msgs = list()
		user.visible_message(SPAN_WARNING("[user] анализирует жизненные показатели пола!"), SPAN_NOTICE("Вы по глупости пытаетесь проанализировать жизненные показатели пола!"))
		msgs += SPAN_NOTICE("Анализ результатов для пола:\nОбщее состояние: Здоровый")
		msgs += SPAN_NOTICE("Основные: <font color='blue'>Удушье</font>/<font color='green'>Токсины</font>/<font color='#FFA500'>Ожоги</font>/<font color='red'>Ушибы</font>")
		msgs += SPAN_NOTICE("Детализация повреждений: <font color='blue'>0</font> - <font color='green'>0</font> - <font color='#FFA500'>0</font> - <font color='red'>0</font>")
		msgs += SPAN_NOTICE("Температура тела: ???")
		to_chat(user, chat_box_healthscan(msgs.Join("<br>")))
		return
	user.visible_message(
		SPAN_NOTICE("[user] анализирует жизненные показатели [M.declent_ru(GENITIVE)]."),
		SPAN_NOTICE("Вы анализируете жизненные показатели [M.declent_ru(GENITIVE)].")
	)
	healthscan(user, M, mode, advanced)
	add_fingerprint(user)

// Used by the PDA medical scanner too.
/proc/healthscan(mob/user, mob/living/M, mode = DETAILED_HEALTH_SCAN, advanced = FALSE)
	var/list/msgs = list()
	var/scanned_name = "[M.declent_ru(GENITIVE)]"
	var/probably_dead = (M.stat == DEAD)
	// show your own health, evil
	if(HAS_TRAIT(user, TRAIT_MED_MACHINE_HALLUCINATING) && prob(5))
		M = user
	if(HAS_TRAIT(user, TRAIT_MED_MACHINE_HALLUCINATING) && prob(10) && IS_HORIZONTAL(M))
		probably_dead = TRUE
	if(isanimal_or_basicmob(M))
		// No box here, keep it simple.
		if(probably_dead)
			to_chat(user, SPAN_NOTICE("Анализ результатов для [M.declent_ru(GENITIVE)]:\nОбщее состояние: <font color='red'>Мёртв</font>"))
			return

		to_chat(user, SPAN_NOTICE("Анализ результатов для [M.declent_ru(GENITIVE)]:\nОбщее состояние: [round(M.health / M.maxHealth * 100, 0.1)]%"))
		to_chat(user, "\t Детализация повреждений: <font color='red'>[M.maxHealth - M.health]</font>")
		return

	// These sensors are designed for organic life.
	if(!ishuman(M) || ismachineperson(M) || (HAS_TRAIT(user, TRAIT_MED_MACHINE_HALLUCINATING) && prob(5)))
		msgs += SPAN_NOTICE("Анализ результатов для ОШИБКА:\nОбщее состояние: ОШИБКА")
		msgs += "Основные: [SPAN_HEALTHSCAN_OXY("Удушье")]/<font color='green'>Токсины</font>/<font color='#FFA500'>Ожоги</font>/<font color='red'>Ушибы</font>"
		msgs += "Детализация повреждений: [SPAN_HEALTHSCAN_OXY("?")] - <font color='green'>?</font> - <font color='#FFA500'>?</font> - <font color='red'>?</font>"
		msgs += SPAN_NOTICE("Температура тела: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)")
		msgs += SPAN_WARNING("<b>Предупреждение: уровень крови ОШИБКА: --% --cl.</b></span><span class='notice'>Тип: ОШИБКА")
		msgs += SPAN_NOTICE("Пульс субъекта: <font color='red'>-- bpm.</font>")
		to_chat(user, chat_box_healthscan(msgs.Join("<br>")))
		return

	var/mob/living/carbon/human/H = M
	var/fake_oxy = max(rand(1,40), H.getOxyLoss(), (300 - (H.getToxLoss() + H.getFireLoss() + H.getBruteLoss())))
	var/OX = H.getOxyLoss()
	var/TX = H.getToxLoss()
	var/BU = H.getFireLoss()
	var/BR = H.getBruteLoss()

	// adjust health randomly if hallucinating
	if(HAS_TRAIT(user, TRAIT_MED_MACHINE_HALLUCINATING) && prob(5))
		var/list/healths = list(OX, TX, BU, BR)
		shuffle_inplace(healths)
		OX = healths[1]
		TX = healths[2]
		BU = healths[3]
		BR = healths[4]

	OX = OX > 50 ? "<b>[OX]</b>" : OX
	TX = TX > 50 ? "<b>[TX]</b>" : TX
	BU = BU > 50 ? "<b>[BU]</b>" : BU
	BR = BR > 50 ? "<b>[BR]</b>" : BR

	var/status = "<font color='red'>Мёртв</font>" // Dead by default to make it simpler
	var/DNR = !H.ghost_can_reenter() // If the ghost can't reenter
	if(H.stat == DEAD)
		if(DNR)
			status = "<font color='red'>Мёртв <b>(DNR)</b></font>"
	else // Alive or unconscious
		if(HAS_TRAIT(H, TRAIT_FAKEDEATH) || probably_dead) // status still shows as "Dead"
			OX = fake_oxy > 50 ? "<b>[fake_oxy]</b>" : fake_oxy
		else
			status = "Состояние [H.health]%"

	msgs += "<span class='notice'>Анализ результатов для [scanned_name]:\nОбщее состояние: [status]"
	msgs += "Основные: [SPAN_HEALTHSCAN_OXY("Удушье")]/<font color='green'>Токсины</font>/<font color='#FFA500'>Ожоги</font>/<font color='red'>Ушибы</font>"
	msgs += "Детализация повреждений: [SPAN_HEALTHSCAN_OXY("[OX]")] - <font color='green'>[TX]</font> - <font color='#FFA500'>[BU]</font> - <font color='red'>[BR]</font>"
	if(H.timeofdeath && (H.stat == DEAD || (HAS_TRAIT(H, TRAIT_FAKEDEATH)) || probably_dead))

		var/tod = probably_dead && (HAS_TRAIT(user, TRAIT_MED_MACHINE_HALLUCINATING) && prob(10)) ? world.time - rand(10, 5000) : H.timeofdeath  // Sure let's blow it out
		msgs += SPAN_NOTICE("Время смерти: [station_time_timestamp("hh:mm:ss", tod)]")
		var/tdelta = round(world.time - tod)
		if(H.is_revivable() && !DNR)
			msgs += SPAN_DANGER("Субъект умер [DisplayTimeText(tdelta)] назад. Дефибрилляция ещё возможна!")
		else
			msgs += "<font color='red'>Субъект умер [DisplayTimeText(tdelta)] назад. <b>Дефибрилляция более невозможна!</b></font>"
	if(mode == DETAILED_HEALTH_SCAN)
		var/list/damaged = H.get_damaged_organs(1,1)
		if(length(damaged))
			msgs += SPAN_NOTICE("Локальные повреждения. Ушибы/ожоги:")
			for(var/obj/item/organ/external/org in damaged)
				msgs += "<span class='notice'>[capitalize(org.name)]: [(org.brute_dam > 0) ? "<font color='red'>[org.brute_dam]</font></span>" : "<font color='red'>0</font>"]-[(org.burn_dam > 0) ? "<font color='#FF8000'>[org.burn_dam]</font>" : "<font color='#FF8000'>0</font>"]"
	if(advanced)
		msgs.Add(get_chemscan_results(user, H))
	for(var/thing in H.viruses)
		var/datum/disease/D = thing
		// If the disease is incubating, or if it's stealthy and hasn't been put into a pandemic yet the scanner won't see it
		if(D.incubation || (D.visibility_flags & VIRUS_HIDDEN_SCANNER && !(D.GetDiseaseID() in GLOB.detected_advanced_diseases["[user.z]"])))
			continue
		// Snowflaking heart problems, because they are special (and common).
		if(istype(D, /datum/disease/critical))
			msgs += SPAN_NOTICE("<font color='red'><b>Предупреждение: у субъекта [D.name].</b>\nСтадия: [D.stage]/[D.max_stages].\nМетод лечения: [D.cure_text]</font>")
			continue
		if(istype(D, /datum/disease/advance))
			var/datum/disease/advance/A = D
			if(!(A.id in GLOB.known_advanced_diseases[num2text(user.z)]))
				msgs += SPAN_NOTICE("<font color='red'><b>Предупреждение: Обнаружен неизвестный штамм вируса</b>\nШтамм:[A.strain]\nСтадия: [A.stage]")
			else
				msgs += SPAN_NOTICE("<font color='red'><b>Предупреждение: Обнаружен [A.form]</b>\nНазвание: [A.name].\nШтамм:[A.strain]\nТип: [A.spread_text].\nСтадия: [A.stage]/[A.max_stages].\nМетод лечения: [A.cure_text]\nНеобходимо лечений: [A.cures_required]</font>")
			continue
		msgs += SPAN_NOTICE("<font color='red'><b>Предупреждение: Обнаружен [D.form]</b>\nНазвание: [D.name].\nТип: [D.spread_text].\nСтадия: [D.stage]/[D.max_stages].\nМетод лечения: [D.cure_text]</font>")
	if(H.undergoing_cardiac_arrest())
		var/datum/organ/heart/heart = H.get_int_organ_datum(ORGAN_DATUM_HEART)
		if(heart && !(heart.linked_organ.status & ORGAN_DEAD))
			msgs += "<span class='notice'><font color='red'><b>Сердце пациента остановилось.</b>\nМетод лечения: Электрический шок</font>"
		else if(heart && (heart.linked_organ.status & ORGAN_DEAD))
			msgs += "<span class='notice'><font color='red'><b>Зафиксирован некроз сердца субъекта.</b></font>"
		else if(!heart)
			msgs += "<span class='notice'><font color='red'><b>Субъект не имеет сердца.</b></font>"
	if(H.getStaminaLoss() || HAS_TRAIT(user, TRAIT_MED_MACHINE_HALLUCINATING) && prob(5))
		msgs += SPAN_NOTICE("Субъект страдает от переутомления.")
	if(H.getCloneLoss() || (HAS_TRAIT(user, TRAIT_MED_MACHINE_HALLUCINATING) && prob(5)))
		msgs += SPAN_WARNING("Субъект имеет [H.getCloneLoss() > 30 ? "серьёзное" : "незначительное"] клеточное повреждение.")
	// Brain.
	var/obj/item/organ/internal/brain = H.get_int_organ(/obj/item/organ/internal/brain)
	if(brain)
		if(H.check_brain_threshold(BRAIN_DAMAGE_RATIO_CRITICAL)) // 100
			msgs += SPAN_WARNING("Мозг субъекта мёртв.")
		else if(H.check_brain_threshold(BRAIN_DAMAGE_RATIO_MODERATE)) // 60
			msgs += SPAN_WARNING("Обнаружено серьезное повреждение мозга. Возможно, у пациента слабоумие.")
		else if(H.check_brain_threshold(BRAIN_DAMAGE_RATIO_MINOR)) // 10
			msgs += SPAN_WARNING("Обнаружено значительное повреждение мозга. Возможно, у пациента сотрясение мозга.")
	else
		msgs += SPAN_WARNING("Субъект не имеет мозга.")

	// Broken bones, internal bleeding, infection, and critical burns.
	var/broken_bone = FALSE
	var/internal_bleed = FALSE
	var/burn_wound = FALSE
	for(var/name in H.bodyparts_by_name)
		var/obj/item/organ/external/e = H.bodyparts_by_name[name]
		if(!e)
			continue
		var/limb = e.name
		if(e.status & ORGAN_BROKEN)
			if((e.limb_name in list("l_arm", "r_arm", "l_hand", "r_hand", "l_leg", "r_leg", "l_foot", "r_foot")) && !(e.status & ORGAN_SPLINTED))
				msgs += SPAN_WARNING("Обнаружен незафиксированный перелом в [limb]. Рекомендуется наложение шин при транспортировке.")
			broken_bone = TRUE
		if(e.has_infected_wound())
			msgs += SPAN_WARNING("Обнаружена инфицированная рана в [limb]. Рекомендуется дезинфекция.")
		burn_wound = burn_wound || (e.status & ORGAN_BURNT)
		internal_bleed = internal_bleed || (e.status & ORGAN_INT_BLEEDING)
	if(broken_bone)
		msgs += SPAN_WARNING("Обнаружены переломы костей. Продвинутый сканер покажет местоположение.")
	if(internal_bleed)
		msgs += SPAN_WARNING("Обнаружено внутреннее кровотечение. Продвинутый сканер покажет местоположение.")
	if(burn_wound)
		msgs += SPAN_WARNING("Обнаружен серьёзный ожог. Осмотрите пациента для установления местоположения.")

	if(HAS_TRAIT(user, TRAIT_MED_MACHINE_HALLUCINATING) && prob(5))
		var/list/spooky_conditions = list(
			SPAN_DEAD("Patient appears to be infested."),
			SPAN_DEAD("Patient's bones are hollow."),
			SPAN_DEAD("Patient has limited attachment to this physical plane."),
			SPAN_USERDANGER("Patient is aggressive. Immediate sedation recommended."),
			SPAN_WARNING("Patient's vitamin D levels are dangerously low."),
			SPAN_WARNING("Patient's spider levels are dangerously low."),
			SPAN_DEAD("Subject is ready for experimentation."),
		)
		msgs += pick(spooky_conditions)

	if(HAS_TRAIT(user, TRAIT_MED_MACHINE_HALLUCINATING) && prob(5) && (H.stat == DEAD || (HAS_TRAIT(H, TRAIT_FAKEDEATH))))
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), user, SPAN_DANGER("[H]'s head snaps to look at you.")), rand(1 SECONDS, 3 SECONDS))

	// Blood.
	var/blood_id = H.get_blood_id()
	if(blood_id)
		if(H.bleed_rate)
			msgs += SPAN_DANGER("У субъекта кровотечение!")
		var/blood_percent =  round((H.blood_volume / BLOOD_VOLUME_NORMAL)*100)
		var/blood_type = H.dna.blood_type
		var/blood_volume = round(H.blood_volume)
		if(blood_id != "blood")//special blood substance
			var/datum/reagent/R = GLOB.chemical_reagents_list[blood_id]
			if(R)
				blood_type = R.name
			else
				blood_type = blood_id
		if(H.blood_volume <= BLOOD_VOLUME_SAFE && H.blood_volume > BLOOD_VOLUME_OKAY)
			msgs += SPAN_DANGER("НИЗКИЙ уровень крови [blood_percent] %, [blood_volume] сл,</span> <span class='notice'>тип: [blood_type]")
		else if(H.blood_volume <= BLOOD_VOLUME_OKAY)
			msgs += SPAN_DANGER("КРИТИЧЕСКИЙ уровень крови [blood_percent] %, [blood_volume] сл,</span> <span class='notice'>тип: [blood_type]")
		else
			msgs += SPAN_NOTICE("Уровень крови [blood_percent] %, [blood_volume] сл, тип: [blood_type]")

	msgs += SPAN_NOTICE("Температура тела: [round(H.bodytemperature-T0C, 0.01)]&deg;C ([round(H.bodytemperature*1.8-459.67, 0.01)]&deg;F)")
	msgs += SPAN_NOTICE("Пульс субъекта: <font color='[H.pulse == PULSE_THREADY || H.pulse == PULSE_NONE ? "red" : "blue"]'>[H.get_pulse()] bpm.</font>")

	var/implant_detect
	for(var/obj/item/organ/internal/O in H.internal_organs)
		if(O.is_robotic() && !O.stealth_level)
			implant_detect += "[O.name].<br>"
	if(implant_detect)
		msgs += SPAN_NOTICE("Обнаружены кибернетические модификации:")
		msgs += SPAN_NOTICE("[implant_detect]")

	// Do you have too many genetics superpowers?
	if(H.gene_stability < 40)
		msgs += SPAN_USERDANGER("Гены субъекта быстро разрушаются!")
	else if(H.gene_stability < 70)
		msgs += SPAN_DANGER("Гены субъекта спонтанно разрушаются.")
	else if(H.gene_stability < 85)
		msgs += SPAN_WARNING("Незначительные признаки нестабильности в генах субъекта.")

	if(HAS_TRAIT(H, TRAIT_HUSK))
		msgs += SPAN_DANGER("Субъект стал хаском. Рекомендуется примененить синтплоть.")

	if(H.radiation > RAD_MOB_SAFE)
		msgs += SPAN_DANGER("Субъект облучён.")

	msgs += SPAN_NOTICE("Биологический возраст: [H.age]")

	//SS220 ADDITION START - SERPENTIDS
	if(SEND_SIGNAL(H, COMSIG_SHELL_GET_CARAPACE_STATE) & CARAPACE_SHELL_BROKEN)
		msgs = get_carapace_damage_level(H, msgs)
	//SS220 ADDITION END - SERPENTIDS

	to_chat(user, chat_box_healthscan(msgs.Join("<br>")))

/obj/item/healthanalyzer/attackby__legacy__attackchain(obj/item/I, mob/user, params)
	if(!istype(I, /obj/item/healthupgrade))
		return ..()
	if(advanced)
		to_chat(user, SPAN_NOTICE("[capitalize(src.declent_ru(NOMINATIVE))] уже улучшен."))
		return
	if(!user.unequip(I))
		to_chat(user, SPAN_WARNING("[src.declent_ru(NOMINATIVE)] застрял в вашей руке!"))
		return
	to_chat(user, SPAN_NOTICE("Вы установили улучшение на [src.declent_ru(ACCUSATIVE)]."))
	add_overlay("advanced")
	playsound(loc, I.usesound, 50, TRUE)
	advanced = TRUE
	qdel(I)

/obj/item/healthanalyzer/advanced
	name = "advanced health analyzer"
	advanced = TRUE

/obj/item/healthanalyzer/advanced/Initialize(mapload)
	. = ..()
	add_overlay("advanced")

/obj/item/healthupgrade
	name = "Health Analyzer Upgrade"
	desc = "Модуль улучшения, который может быть установлен на анализатор здоровья для расширения возможностей."
	icon = 'icons/obj/device.dmi'
	icon_state = "healthupgrade"
	w_class = WEIGHT_CLASS_TINY
	origin_tech = "magnets=2;biotech=2"
	materials = list(MAT_METAL = 200, MAT_GLASS = 200)
	usesound = 'sound/items/deconstruct.ogg'
#undef SIMPLE_HEALTH_SCAN
#undef DETAILED_HEALTH_SCAN
