/datum/quirk/alcohol_tolerance/heavy_drinker
	conflicting_quirks = list(/datum/quirk/alcohol_tolerance/lightweight)

/datum/quirk/tiny
	conflicting_quirks = list(/datum/quirk/hevy)
	var/brute_modifier = 0.05

/datum/quirk/tiny/apply_quirk_effects(mob/living/carbon/human/quirky)
	..()
	owner.dna.species.brute_mod += brute_modifier

/datum/quirk/major
	name = "Money money money!"
	desc = "Депнув в казино вы получили свои заветные деньги."
	cost = 3
	item_to_give = /obj/item/stack/spacecash/c4500

#define NIGHT_CREATURE_DARKNESS 0.2
#define NIGHT_CREATURE_BRIGHTNESS 0.5

/datum/quirk/night_creature
	name = "Житель темных подвалов"
	desc = "Вы лучше видите в темноте и быстрее передвигаетесь. Яркий свет ухудшает ваше зрение и замедляет вас."
	cost = 2
	processes = TRUE
	species_flags = QUIRK_DIONA_INCOMPATIBLE
	conflicting_quirks = list(/datum/quirk/darkness_fear)

	var/in_darkness = FALSE
	var/in_light = FALSE

/datum/quirk/night_creature/process()
	if(!..())
		return

	var/turf/T = get_turf(owner)
	if(!T)
		return

	var/light_amount = T.get_lumcount()

	if(light_amount < 0.2)
		if(!in_darkness)
			in_darkness = TRUE
			in_light = FALSE

			ADD_TRAIT(owner, TRAIT_DARKNESS_ADAPTED, "night_creature")
			ADD_TRAIT(owner, TRAIT_GOTTAGONOTSOFAST, "night_creature")
			REMOVE_TRAIT(owner, TRAIT_GOTTAGOSLOW, "night_creature")
			REMOVE_TRAIT(owner, TRAIT_NEARSIGHT, "night_creature")

			owner.update_sight()

	else if(light_amount > 0.5)
		if(!in_light)
			in_darkness = FALSE
			in_light = TRUE

			REMOVE_TRAIT(owner, TRAIT_DARKNESS_ADAPTED, "night_creature")
			REMOVE_TRAIT(owner, TRAIT_GOTTAGONOTSOFAST, "night_creature")
			ADD_TRAIT(owner, TRAIT_GOTTAGOSLOW, "night_creature")
			ADD_TRAIT(owner, TRAIT_NEARSIGHT, "night_creature")

			owner.update_sight()

	else
		if(in_darkness || in_light)
			in_darkness = FALSE
			in_light = FALSE

			REMOVE_TRAIT(owner, TRAIT_DARKNESS_ADAPTED, "night_creature")
			REMOVE_TRAIT(owner, TRAIT_GOTTAGONOTSOFAST, "night_creature")
			REMOVE_TRAIT(owner, TRAIT_GOTTAGOSLOW, "night_creature")
			REMOVE_TRAIT(owner, TRAIT_NEARSIGHT, "night_creature")

			owner.update_sight()
#undef NIGHT_CREATURE_DARKNESS
#undef NIGHT_CREATURE_BRIGHTNESS

#define SS220_POLYCYTHEMIA_BLOOD_MAX 600

/datum/quirk/polycythemia
	name = "Polycythemia vera"
	desc = "Ваш организм производит больше крови, чем обычно."
	cost = 2
	trait_to_apply = TRAIT_POLYCYTHEMIA
	conflicting_quirks = list(/datum/quirk/erythrocytopenia)
	processes = TRUE

/datum/quirk/polycythemia/apply_quirk_effects(mob/living/carbon/human/M)
	..()

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!(NO_BLOOD in H.dna.species.species_traits))
			H.blood_volume = SS220_POLYCYTHEMIA_BLOOD_MAX

/datum/quirk/polycythemia/process()
	if(!..())
		return

	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(!(NO_BLOOD in H.dna.species.species_traits))
			if(H.blood_volume < SS220_POLYCYTHEMIA_BLOOD_MAX)
				H.blood_volume += 0.8
