/datum/species
	var/thirst_drain = THIRST_FACTOR

/datum/species/machine/New()
	. = ..()
	inherent_traits.Add(TRAIT_NO_THIRST)

/datum/species/abductor/New()
	. = ..()
	inherent_traits.Add(TRAIT_NO_THIRST)

/datum/species/golem/New()
	. = ..()
	inherent_traits.Add(TRAIT_NO_THIRST)

/datum/species/plasmaman/New()
	. = ..()
	inherent_traits.Add(TRAIT_NO_THIRST)

/datum/species/skeleton/New()
	. = ..()
	inherent_traits.Add(TRAIT_NO_THIRST)

/datum/species/grey/New()
	. = ..()
	inherent_traits.Add(TRAIT_NO_THIRST)

/datum/species/vox/New()
	. = ..()
	inherent_traits.Add(TRAIT_NO_THIRST)

/datum/antagonist/vampire/apply_innate_effects(mob/living/mob_override)
	. = ..()
	ADD_TRAIT(mob_override, TRAIT_NO_THIRST, "vampire")

/datum/antagonist/vampire/remove_innate_effects(mob/living/mob_override)
	. = ..()
	REMOVE_TRAIT(mob_override, TRAIT_NO_THIRST, "vampire")
