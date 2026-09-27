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
	conflicting_quirks = list(/datum/quirk/alcohol_tolerance/heavy_drinker)

/datum/quirk/foreigner
	name = "Foreigner"
	desc = "Вы совсем недавно присоединились к крупнейшему галактическому сообществу \
			и еще не знаете общегалактического языка. Вы не можете вступить на должность \
			в командовании или службе безопасности. Несовместимо с расой Плазмамен."
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
	var/brute_modifier = 1.2

/datum/quirk/frail/apply_quirk_effects(mob/living/carbon/human/quirky)
	..()
	owner.dna.species.brute_mod = brute_modifier

#define ASTHMA_ATTACK_THRESHOLD 20

/datum/quirk/asthma
	name = "Asthma"
	desc = "Вам трудно отдышаться, а при физических нагрузках могут случаться приступы сильного кашля. Несовместимо с расой КПБ."
	cost = -4
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
	if(prob(min(ease_of_breathing, 50)))
		trigger_asthma_symptom(ease_of_breathing)

/* Causes an asthmatic flareup, which gets worse depending on how much oxygen and stamina damage the owner already has.
*  If a bad attack isn't treated, it can easily feed into itself and kill the user.
*/
/datum/quirk/asthma/proc/trigger_asthma_symptom(current_severity)
	owner.visible_message(SPAN_NOTICE("[owner] violently coughs!"), SPAN_WARNING("Your asthma flares up!"))
	switch(current_severity)
		if(20 to 30)
			owner.adjustOxyLoss(5)
		if(40 to 59)
			owner.adjustOxyLoss(8)
		if(60 to 79)
			owner.adjustOxyLoss(15)
		if(80 to 99) // By now you're doubled over coughing
			owner.adjustOxyLoss(20)
			owner.AdjustLoseBreath(4 SECONDS)
		if(100 to INFINITY)
			owner.adjustOxyLoss(25)
			owner.AdjustLoseBreath(8 SECONDS)
			owner.KnockDown(6 SECONDS)
#undef ASTHMA_ATTACK_THRESHOLD

/datum/quirk/no_apc_charging
	name = "High Internal Resistance"
	desc = "ЛКП на станции рассчитаны на более высокое напряжение, чем может выдержать ваше шасси, поэтому заряжать \
			его можно только на зарядных станциях. Совместимо только с расой КПБ."
	cost = -1
	species_flags = QUIRK_ORGANIC_INCOMPATIBLE
	trait_to_apply = TRAIT_NO_APC_CHARGING
	organ_slot_to_remove = "r_arm_device" // This feels like such a dumb way to do this but I can't think of a smarter solution

/datum/quirk/pacifism
	name = "Pacifist"
	desc = "Вы не можете заставить себя причинять боль другим и не можете занимать должности в \
			командовании или службе безопасности."
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
	desc = "Вы не различаете цвета. Несовместимо с расой Слаймомен."
	cost = -1
	trait_to_apply = TRAIT_COLORBLIND
	species_flags = QUIRK_SLIME_INCOMPATIBLE

/datum/quirk/loudmouthed
	name = "Loudmouthed"
	desc = "Вы не можете говорить шепотом."
	cost = -1
	trait_to_apply = TRAIT_NO_WHISPERING

/datum/quirk/nearsighted
	name = "Nearsighted"
	desc = "Вы плохо видите без специальных очков. Несовместимо с расой Слаймомен."
	cost = -1
	trait_to_apply = TRAIT_NEARSIGHT
	species_flags = QUIRK_SLIME_INCOMPATIBLE

/datum/quirk/impaired_coordination
	name = "Impaired coordination"
	desc = "У вас нарушена координация, из-за чего вы медленно передвигаетесь."
	cost = -1
	trait_to_apply = TRAIT_GOTTAGOSLOW

#define HALLUCINATIONS_COOLDOWN_MIN 1 MINUTES
#define HALLUCINATIONS_COOLDOWN_MAX 2 MINUTES

/datum/quirk/hallucinations
	name = "Hallucinations"
	desc = "Вы периодически видите и слышите то, чего не существует. Не можете занимать должности в \
			командовании или службе безопасности."
	cost = -2
	blacklisted = TRUE
	processes = TRUE
	var/next_hallucination = 0

/datum/quirk/hallucinations/apply_quirk_effects(mob/living/carbon/human/quirky)
	next_hallucination = world.time + rand(HALLUCINATIONS_COOLDOWN_MIN, HALLUCINATIONS_COOLDOWN_MAX)
	..()

/datum/quirk/hallucinations/process()
	if(!..())
		return
	if(next_hallucination > world.time)
		return
	next_hallucination = world.time + rand(HALLUCINATIONS_COOLDOWN_MIN, HALLUCINATIONS_COOLDOWN_MAX)
	var/severity
	var/chance = rand(100)

	if(chance <= 65)
		severity = HALLUCINATE_MINOR
	else if(chance <= 95)
		severity = HALLUCINATE_MODERATE
	else
		severity = HALLUCINATE_MAJOR

	var/hallucination_type = pickweight(GLOB.hallucinations[severity])
	new hallucination_type(get_turf(owner), owner)

#undef HALLUCINATIONS_COOLDOWN_MIN
#undef HALLUCINATIONS_COOLDOWN_MAX

/datum/quirk/addiction
	name = "Addiction"
	desc = "Ваш организм постоянно требует определённый препарат. Несовместимо с расой КПБ."
	cost = -2
	species_flags = QUIRK_MACHINE_INCOMPATIBLE
	var/list/addiction_reagents = list(
	/datum/reagent/medicine/omnizine,
	/datum/reagent/happiness,
	/datum/reagent/space_drugs,
	/datum/reagent/consumable/drink/coffee
	)

	var/addicted_reagent
	var/addiction_stage = 1

/datum/quirk/addiction/apply_quirk_effects(mob/living/carbon/human/quirky)
	..()

	addicted_reagent = pick(addiction_reagents)

	var/datum/reagent/addiction = new addicted_reagent
	addiction.last_addiction_dose = world.timeofday
	addiction.addiction_stage = 1
	addiction.permanent_addiction = TRUE

	owner.reagents.addiction_list.Add(addiction)
/datum/quirk/unclonable
	name = "Unclonable"
	desc = "You have a genetic condition that prevents you from being cloned. This does not prevent revival by other methods."
	cost = -1
	trait_to_apply = TRAIT_UNCLONABLE
	species_flags = QUIRK_MACHINE_INCOMPATIBLE | QUIRK_SLIME_INCOMPATIBLE | QUIRK_VOX_INCOMPATIBLE

/datum/quirk/work_hard_party_harder
	name = "Work Hard, Party Harder"
	desc = "You party like there's no tomorrow every day, the consequences are a problem for future you! When the shift starts, you will always wake up in a random part of the station, drunk."
	cost = -1
	trait_to_apply = TRAIT_WORK_HARD_PARTY_HARDER
	conflicting_quirks = list(/datum/quirk/temperate_partier)

/datum/quirk/hevy
	name = "Big Jon"
	desc = "Ты больше чем некоторые персоны."
	cost = -2
	trait_to_apply = TRAIT_TINY
	conflicting_quirks = list(/datum/quirk/tiny)

/datum/quirk/hevy/apply_quirk_effects() // Just the pasted `activate()` proc from the dwarf mutation.
	..() // I'M AT MY WITS END THIS IS THE ONLY WAY I KNOW TO MAKE THIS WORK.
	owner.resize = 1.2
	owner.update_transform()

/datum/quirk/water_fear
	name = "Aquaphobia"
	desc = "Вы испытываете сильный страх перед водой. Даже небольшой контакт с ней вызывает панику."
	cost = -1
	trait_to_apply = TRAIT_WATER_FEAR
	species_flags = QUIRK_GREY_INCOMPATIBLE | QUIRK_DIONA_INCOMPATIBLE

/datum/quirk/darkness_fear
	name = "Nyctophobia"
	desc = "Вы испытываете сильный страх в темноте. В полной темноте вам становится трудно сохранять спокойствие."
	cost = -2
	processes = TRUE
	species_flags = QUIRK_DIONA_INCOMPATIBLE
	conflicting_quirks = list(/datum/quirk/night_creature)
	var/in_darkness = FALSE
	var/next_panic = 0

/datum/quirk/darkness_fear/apply_quirk_effects(mob/living/carbon/human/quirky)
	..()
	next_panic = world.time + 30 SECONDS

/datum/quirk/darkness_fear/process()
	if(!..())
		return

	var/turf/T = get_turf(owner)
	if(!T)
		return

	var/light_amount = T.get_lumcount()

	if(light_amount < 0.2)
		if(!in_darkness)
			in_darkness = TRUE
			ADD_TRAIT(owner, TRAIT_GOTTAGOSLOW, "darkness_fear")

#ifndef UNIT_TESTS // Это надо чтобы тесты не ломались иза механа страха в темноте
		if(next_panic <= world.time)
			next_panic = world.time + rand(20 SECONDS, 40 SECONDS)
			owner.adjustStaminaLoss(5)
		if(prob(50))
			owner.emote("shiver")
		else if(prob(70))
			owner.emote("scream")
		else
			owner.emote("shiver")
			owner.emote("scream")
#endif
	else if(in_darkness)
		in_darkness = FALSE
		REMOVE_TRAIT(owner, TRAIT_GOTTAGOSLOW, "darkness_fear")
