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
	name = "Dermalin"
	id = "dermalin"
	description = "It restores burnt tissues by straining the body; an overdose causes severe inflammation of the skin."
	reagent_state = LIQUID
	color = "#eeff00"
	metabolization_rate = 1.5
	overdose_threshold = 15
	harmless = FALSE
	taste_description = "soothed burns"

/datum/reagent/medicine/dermalin/on_mob_life(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	update_flags |= M.adjustFireLoss(-5, FALSE)
	update_flags |= M.adjustStaminaLoss(2, FALSE)
	return ..() | update_flags

/datum/reagent/medicine/dermalin/overdose_process(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	update_flags |= M.adjustFireLoss(10, FALSE)
	update_flags |= M.adjustStaminaLoss(5, FALSE)
	return ..() | update_flags

/datum/reagent/medicine/bruzin
	name = "Bruzin"
	id = "bruzin"
	description = "Restores serious cuts by straining the body; overdose causes a disruption in the body's regeneration."
	reagent_state = LIQUID
	color = "#dd0303"
	metabolization_rate = 1.5
	overdose_threshold = 15
	harmless = FALSE
	taste_description = "knitting wounds"

/datum/reagent/medicine/bruzin/on_mob_life(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	update_flags |= M.adjustBruteLoss(-5, FALSE)
	update_flags |= M.adjustStaminaLoss(2, FALSE)
	return ..() | update_flags

/datum/reagent/medicine/bruzin/overdose_process(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	update_flags |= M.adjustBruteLoss(10, FALSE)
	update_flags |= M.adjustStaminaLoss(5, FALSE)
	return list(0, update_flags)

/datum/chemical_reaction/dermalin
	name = "Dermalin"
	id = "dermalin"
	result = "dermalin"
	required_reagents = list("salglu_solution" = 1, "synthflesh" = 1, "kelotane" = 2, "mitocholide" = 1, "omnizine" = 1)
	result_amount = 1

/datum/chemical_reaction/bruzin
	name = "Bruzin"
	id = "bruzin"
	result = "bruzin"
	required_reagents = list("salglu_solution" = 1, "synthflesh" = 1, "bicaridine" = 2, "mitocholide" = 1, "omnizine" = 1)
	result_amount = 1

//MARK: Robot Drugs
// Made for robots, by robots.

// Robot weed. Mixes the effects of CBD and THC.
/datum/reagent/w33d
	name = "W33D"
	id = "w33d"
	description = "A thick, oily concoction designed to mimic the effects of cannabis in synthetics. \
	As a happy coincidence, when it dries out it can also function as servicable filler, sealant, and insulator."
	reagent_state = LIQUID
	color = "#17dd17"
	overdose_threshold = 30
	process_flags = SYNTHETIC
	taste_description = "man, like, totally the best most relaxing thing ever, dude"

/datum/reagent/w33d/on_mob_life(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	if(prob(10))
		M.AdjustStuttering(rand(0, 6 SECONDS))
	if(prob(5))
		M.emote(pick("hsigh", "giggle", "laugh", "smile"))
	if(prob(5))
		to_chat(M, "<span class='notice'>[pick("You feel peaceful.", "You whirr softly.", "You feel chill.", "You vibe.")]</span>")
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
	name = "Grokodil"
	id = "grokodil"
	description = "An experimental compound cooked up in the back alleys of New Canaan, designed to mimic the effects of Krokodil in synthetics. \
	Unfortunately, this worked a little too well, as it also faithfully replicates the fact that there are serious side-effects. \
	Overconsumption will cause extreme corrosion and a combonation of endothermic and exothermic reactions that will lead to localized melting and generalized temperature reduction."
	color = "#212121"
	process_flags = SYNTHETIC
	overdose_threshold = 20
	addiction_chance = 10
	addiction_threshold = 10
	taste_description = "very poor life choices"
	allowed_overdose_process = TRUE
	goal_department = "Science"
	goal_difficulty = REAGENT_GOAL_HARD

/datum/reagent/grokodil/on_mob_life(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	M.AdjustJitter(-80 SECONDS)
	if(prob(25))
		M.emote(pick("smile", "grin", "chuckle", "laugh"))
	if(prob(15))
		to_chat(M, "<span class='notice'>You feel pretty chill.</span>")
		M.bodytemperature--
		M.emote("smile")
	if(prob(30))
		to_chat(M, "<span class='warning'>You feel too chill!</span>")
		M.emote(pick("shiver", "cross"))
		update_flags |= M.adjustBruteLoss(2, FALSE)
		update_flags |= M.adjustFireLoss(2, FALSE)
		update_flags |= M.adjustBrainLoss(3, FALSE)
		update_flags |= M.adjustStaminaLoss(-50, FALSE)
		M.bodytemperature -= 20
	if(prob(2))
		to_chat(M, "<span class='warning'>Patches of corrosion appear on your chassis!</span>")
		update_flags |= M.adjustBruteLoss(2, FALSE)
	return ..() | update_flags

/datum/reagent/grokodil/overdose_process(mob/living/M, severity)
	var/list/overdose_info = ..()
	var/effect = overdose_info[REAGENT_OVERDOSE_EFFECT]
	var/update_flags = overdose_info[REAGENT_OVERDOSE_FLAGS]
	if(severity == 1)
		if(effect <= 2)
			M.visible_message("<span class='warning'>[M] looks dazed!</span>")
			M.Stun(6 SECONDS)
			do_sparks(5, FALSE, M)
			M.emote("stare")
		else if(effect <= 4)
			M.emote("shiver")
			M.bodytemperature -= 40
		else if(effect <= 7)
			to_chat(M, "<span class='warning'>Your chassis and internals are corroding!</span>")
			update_flags |= M.adjustBruteLoss(5, FALSE)
			update_flags |= M.adjustFireLoss(2, FALSE)
			update_flags |= M.adjustBrainLoss(1, FALSE)
			M.emote("cry")
		return list(effect, update_flags)

	if(severity == 2)
		if(effect <= 2)
			M.visible_message(
				"<span class='warning'>[M] sways and falls over!</span>",
				"<span class='warning'>You sway and fall over!</span>"
			)
			update_flags |= M.adjustBruteLoss(3, FALSE)
			update_flags |= M.adjustBrainLoss(3, FALSE)
			M.Weaken(16 SECONDS)
			M.emote("faint")
		else if(effect <= 4)
			M.visible_message(
				"<span class='danger'>Large cracks appear on [M]'s casing and the surrounding area starts to melt!</span>",
				"<span class='userdanger'>Large cracks appear on your casing and the surrounding area starts to melt!</span>"
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
	name = "W33D"
	id = "w33d"
	result = "w33d"
	required_reagents = list("synthanol" = 1, "oil" = 1, "aluminum" = 1)
	result_amount = 3
	mix_message = "The mixture bubbles into a vibrant green oil with a musky smell."

/datum/chemical_reaction/grokodil
	name = "Grokodil"
	id = "grokodil"
	result = "grokodil"
	required_reagents = list("mutadone" = 1, "heparin" = 1, "cleaner" = 1, "phenol" = 1, "w33d" = 1)
	result_amount = 5
	mix_message = "A semi-solid black powder crashes out of the solution."
	min_temp = T0C + 100
	mix_sound = 'sound/goonstation/misc/fuse.ogg'
