/obj/item/organ/external/hand/carapace
	encased = "chitin"
	min_broken_damage = 20

/obj/item/organ/external/hand/carapace/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/carapace, src, TRUE, min_broken_damage)

/obj/item/organ/external/hand/right/carapace
	encased = "chitin"
	min_broken_damage = 20

/obj/item/organ/external/hand/right/carapace/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/carapace, src, TRUE, min_broken_damage)

//Модификация граба для хвата из стелса
/datum/species/grab(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	. = .. ()
	var/obj/item/grab/grab_item = user.get_active_hand()
	var/limb_name = (user.l_hand == grab_item ? "l_hand" : "r_hand")
	var/obj/item/organ/external/hand/active_hand = user.get_limb_by_name(limb_name)
	if (istype(active_hand, /obj/item/organ/external/hand/carapace) || istype(active_hand, /obj/item/organ/external/hand/right/carapace))
		if (user.invisibility == INVISIBILITY_LEVEL_TWO)
			grab_item.state = GRAB_AGGRESSIVE
			grab_item.icon_state = "grabbed1"
			user.reset_visibility()
