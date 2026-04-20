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
