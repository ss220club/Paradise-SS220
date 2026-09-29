/datum/quirk/alcohol_tolerance/heavy_drinker
	conflicting_quirks = list(/datum/quirk/alcohol_tolerance/lightweight)

/datum/quirk/tiny
	conflicting_quirks = list(/datum/quirk/hevy)

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
