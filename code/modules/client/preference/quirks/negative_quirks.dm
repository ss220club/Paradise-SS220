/datum/quirk/alcohol_tolerance
	var/alcohol_modifier = 1

/datum/quirk/alcohol_tolerance/apply_quirk_effects(mob/living/quirky)
	..()
	owner.physiology.alcohol_mod *= alcohol_modifier

/datum/quirk/alcohol_tolerance/remove_quirk_effects()
	..()
	owner.physiology.alcohol_mod /= alcohol_modifier

/datum/quirk/alcohol_tolerance/lightweight
	name = "Lightweight"
	desc = "Вы плохо переносите алкоголь и быстрее пьянеете."
	cost = -1
	alcohol_modifier = 1.5

/datum/quirk/foreigner
	name = "Foreigner"
	desc = "Вы совсем недавно присоединились к крупнейшему галактическому сообществу и еще не знаете общегалактического языка. Вы не можете вступить на должность в командовании или службе безопасности."
	cost = -2
	item_to_give = /obj/item/taperecorder
	blacklisted = TRUE
	trait_to_apply = TRAIT_FOREIGNER
	species_flags = QUIRK_PLASMAMAN_INCOMPATIBLE

/datum/quirk/foreigner/apply_quirk_effects(mob/living/quirky)
	..()
	owner.remove_language("Galactic Common")
	if(!length(owner.languages))
		log_admin("[owner] set up a character with no known languages.") // It's possible to do this but I have no idea how to prevent it without just giving them back galcom for free, so admins can ask them to not do that
		return
	owner.set_default_language(quirky.languages[1]) // set_default_language needs to be passed a direct reference to the user's language list

/datum/quirk/foreigner/remove_quirk_effects()
	owner.add_language("Galactic Common")
	..()

/datum/quirk/deaf
	name = "Deafness"
	desc = "Вы неизлечимо глухи и не можете занимать должности в командовании или службе безопасности."
	cost = -4
	trait_to_apply = TRAIT_DEAF
	blacklisted = TRUE

/datum/quirk/blind
	name = "Blind"
	desc = "Вы неизлечимо слепы и не можете занимать должности в командовании или службе безопасности."
	cost = -4
	trait_to_apply = TRAIT_BLIND
	blacklisted = TRUE
	item_to_give = /obj/item/blindcane

/datum/quirk/mute
	name = "Mute"
	desc = "Вы неизлечимо немы и не можете занимать должности в командовании или службе безопасности."
	cost = -3
	blacklisted = TRUE
	trait_to_apply = TRAIT_MUTE

/datum/quirk/frail
	name = "Frail"
	desc = "Вам значительно легче получить серьезную травму, чем большинству людей."
	cost = -3
	trait_to_apply = TRAIT_FRAIL

#define ASTHMA_ATTACK_THRESHOLD 50

/datum/quirk/asthma
	name = "Asthma"
	desc = "Вам трудно отдышаться, а при физических нагрузках могут случаться приступы сильного кашля. Несовместимо с расой КПБ."
	cost = -3
	species_flags = QUIRK_MACHINE_INCOMPATIBLE
	trait_to_apply = TRAIT_ASTHMATIC
	processes = TRUE
	item_to_give = /obj/item/reagent_containers/pill/salbutamol // If an inhaler ever gets made put it here

/datum/quirk/asthma/process()
	if(!..())
		return
	var/ease_of_breathing = owner.getOxyLoss() + owner.getStaminaLoss() / 2
	if(ease_of_breathing < ASTHMA_ATTACK_THRESHOLD)
		return
	owner.emote("cough")
	if(prob(ease_of_breathing / 4))
		trigger_asthma_symptom(ease_of_breathing)

/* Causes an asthmatic flareup, which gets worse depending on how much oxygen and stamina damage the owner already has.
*  If a bad attack isn't treated, it can easily feed into itself and kill the user.
*/
/datum/quirk/asthma/proc/trigger_asthma_symptom(current_severity)
	owner.visible_message(SPAN_NOTICE("[owner] violently coughs!"), SPAN_WARNING("Your asthma flares up!"))
	switch(current_severity)
		if(50 to 75)
			owner.adjustOxyLoss(5)
		if(76 to 100)
			owner.adjustOxyLoss(7)
		if(101 to 150) // By now you're doubled over coughing
			owner.adjustOxyLoss(5)
			owner.AdjustLoseBreath(4 SECONDS)
			owner.KnockDown(4 SECONDS)
		if(151 to INFINITY)
			owner.adjustOxyLoss(15)

#undef ASTHMA_ATTACK_THRESHOLD

/datum/quirk/no_apc_charging
	name = "High Internal Resistance"
	desc = "ЛКП на станции рассчитаны на более высокое напряжение, чем может выдержать ваше шасси, поэтому заряжать его можно только на зарядных станциях. Совместимо только с КПБ."
	cost = -2
	species_flags = QUIRK_ORGANIC_INCOMPATIBLE
	trait_to_apply = TRAIT_NO_APC_CHARGING
	organ_slot_to_remove = "r_arm_device" // This feels like such a dumb way to do this but I can't think of a smarter solution

/datum/quirk/pacifism
	name = "Pacifist"
	desc = "Вы не можете заставить себя причинять боль другим и не можете занимать должности в командовании или службе безопасности."
	cost = -3
	blacklisted = TRUE
	trait_to_apply = TRAIT_PACIFISM

/datum/quirk/hungry
	name = "Hungry"
	desc = "Для вас голод наступает быстрее."
	cost = -1

/datum/quirk/hungry/apply_quirk_effects()
	..()
	owner.dna.species.hunger_drain += 0.03

/datum/quirk/hungry/remove_quirk_effects()
	..()
	owner.dna.species.hunger_drain += 0.03

/datum/quirk/colorblind
	name = "Monochromacy"
	desc = "Вы не различаете цвета."
	cost = -2
	trait_to_apply = TRAIT_COLORBLIND
	species_flags = QUIRK_SLIME_INCOMPATIBLE

/datum/quirk/loudmouthed
	name = "Loudmouthed"
	desc = "Вы не можете говорить шепотом."
	cost = -1
	trait_to_apply = TRAIT_NO_WHISPERING

/datum/quirk/nearsighted
	name = "Nearsighted"
	desc = "Вы плохо видите без специальных очков."
	cost = -1
	trait_to_apply = TRAIT_NEARSIGHT
	species_flags = QUIRK_SLIME_INCOMPATIBLE
