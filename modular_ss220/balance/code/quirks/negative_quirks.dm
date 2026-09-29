/datum/reagent
	var/permanent_addiction = FALSE

/datum/quirk/alcohol_tolerance/lightweight
	conflicting_quirks = list(/datum/quirk/alcohol_tolerance/heavy_drinker)

/datum/quirk/impaired_coordination
	name = "Impaired coordination"
	desc = "У вас нарушена координация, из-за чего вы медленно передвигаетесь."
	cost = -3
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

	switch(chance)
		if(1 to 65)
			severity = HALLUCINATE_MINOR
		if(66 to 95)
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
	var/list/addiction_items = list(
	/datum/reagent/medicine/omnizine = /obj/item/storage/fancy/cigarettes/cigpack_syndicate,
	/datum/reagent/nicotine/dense = /obj/item/storage/fancy/cigarettes/cigpack_carcinoma,
	/datum/reagent/space_drugs = /obj/item/storage/box/papersack/jellybean/wtf,
	/datum/reagent/medicine/perfluorodecalin = /obj/item/storage/pill_bottle/perfluorodecalin,
	/datum/reagent/krokodil = /obj/item/storage/box/papersack/krokodil,
	/datum/reagent/medicine/morphine = /obj/item/storage/pill_bottle/morphine/quirk
	)

	var/list/addiction_reagents = list(
	/datum/reagent/medicine/omnizine,
	/datum/reagent/nicotine/dense,
	/datum/reagent/space_drugs,
	/datum/reagent/medicine/perfluorodecalin,
	/datum/reagent/krokodil,
	/datum/reagent/medicine/morphine
	)

	var/addicted_reagent

/datum/quirk/addiction/apply_quirk_effects(mob/living/carbon/human/quirky)
	addicted_reagent = pick(addiction_reagents)
	item_to_give = addiction_items[addicted_reagent]

	..()

	var/datum/reagent/addiction = new addicted_reagent
	addiction.last_addiction_dose = world.timeofday
	addiction.addiction_stage = 1
	addiction.permanent_addiction = TRUE

	owner.reagents.addiction_list.Add(addiction)

/obj/item/storage/box/papersack/jellybean/wtf
	name = "Strange packed meal"
	desc = "Чем-то странным попахивает."

/obj/item/storage/box/papersack/jellybean/wtf/populate_contents()
	for(var/i in 1 to 10)
		new /obj/item/food/candy/jellybean/wtf(src)

/obj/item/storage/box/papersack/krokodil
	name = "Strange packed meal"
	desc = "Чем-то странным попахивает."

/obj/item/storage/box/papersack/krokodil/populate_contents()
	for(var/i in 1 to 10)
		new /obj/item/reagent_containers/glass/beaker/drugs/krokodil(src)

/obj/item/reagent_containers/glass/beaker/drugs/krokodil
	list_reagents = list("krokodil" = 1)

/obj/item/storage/pill_bottle/perfluorodecalin
	wrapper_color = COLOR_BLUE_LIGHT

/obj/item/storage/pill_bottle/perfluorodecalin/populate_contents()
	for(var/I in 1 to 8)
		new /obj/item/reagent_containers/pill/perfluorodecalin(src)

/obj/item/reagent_containers/pill/perfluorodecalin
	name = "\improper Perfluorodecalin pill"
	desc = "Выписаные специальные таблетки для зависимых."
	icon_state = "pill10"
	list_reagents = list("perfluorodecalin" = 1)

/obj/item/storage/pill_bottle/morphine/quirk
	wrapper_color = COLOR_LIGHT_CYAN

/obj/item/storage/pill_bottle/morphine/quirk/populate_contents()
	for(var/I in 1 to 8)
		new /obj/item/reagent_containers/pill/morphine/quirk(src)

/obj/item/reagent_containers/pill/morphine/quirk
	name = "\improper Morphine pill"
	desc = "Видимо врачи плохо лечили тебя что у тебя такая зависимость?"
	icon_state = "pill10"
	list_reagents = list("morphine" = 1)

/datum/quirk/hevy
	name = "Big Jon"
	desc = "Ты больше чем некоторые персоны."
	cost = -1
	trait_to_apply = TRAIT_HEVY
	conflicting_quirks = list(/datum/quirk/tiny)
	var/brute_modifier = -0.05

/datum/quirk/hevy/apply_quirk_effects(mob/living/carbon/human/quirky)
	..()
	owner.dna.species.brute_mod += brute_modifier

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
	next_panic = world.time + 15 SECONDS

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

#ifndef UNIT_TESTS
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

#define SS220_ASTHMA_ATTACK_THRESHOLD 20

/datum/quirk/asthma
 //SS220 EDIT START - Asthma rework
	cost = -4
	item_to_give = /obj/item/storage/pill_bottle/salbutamol
	var/ease_of_breathing = 0
 //SS220 EDIT END - Asthma rework

/datum/quirk/asthma/process()
 //SS220 EDIT START - Asthma rework
	..()

	ease_of_breathing = owner.getOxyLoss() + owner.getStaminaLoss() / 1.5

	if(ease_of_breathing < SS220_ASTHMA_ATTACK_THRESHOLD)
		return

	owner.emote("cough")

	if(prob(min(ease_of_breathing, 75)))
		ss220_trigger_asthma_symptom(ease_of_breathing)
 //SS220 EDIT END - Asthma rework

/datum/quirk/asthma/proc/ss220_trigger_asthma_symptom(current_severity)
 //SS220 EDIT START - Asthma rework
	owner.visible_message(
		SPAN_NOTICE("[owner] violently coughs!"),
		SPAN_WARNING("Your asthma flares up!")
	)

	switch(current_severity)
		if(20 to 39)
			owner.adjustOxyLoss(5)
		if(40 to 59)
			owner.adjustOxyLoss(8)
		if(60 to 79)
			owner.adjustOxyLoss(15)
		if(80 to 99)
			owner.adjustOxyLoss(20)
			owner.AdjustLoseBreath(4 SECONDS)
		if(100 to INFINITY)
			owner.adjustOxyLoss(25)
			owner.AdjustLoseBreath(8 SECONDS)
			owner.KnockDown(6 SECONDS)
 //SS220 EDIT END - Asthma rework

#undef SS220_ASTHMA_ATTACK_THRESHOLD

/datum/quirk/frail
	var/brute_modifier = 0.2

/datum/quirk/frail/apply_quirk_effects(mob/living/carbon/human/quirky)
	..()
	owner.dna.species.brute_mod += brute_modifier

#define SS220_ERYTHROCYTOPENIA_BLOOD_MIN BLOOD_VOLUME_OKAY

/datum/quirk/erythrocytopenia
	name = "Эритропения"
	desc = "Ваш организм производит недостаточно крови."
	cost = -2
	trait_to_apply = TRAIT_ERYTHROCYTOPENIA
	conflicting_quirks = list(/datum/quirk/polycythemia)
	processes = TRUE

/datum/quirk/erythrocytopenia/process()
	if(!..())
		return

	if(owner.blood_volume > SS220_ERYTHROCYTOPENIA_BLOOD_MIN)
		owner.blood_volume = max(
			owner.blood_volume - 0.8,
			SS220_ERYTHROCYTOPENIA_BLOOD_MIN
		)
