/obj/item/organ/external/chest/carapace
	encased = "chitin"
	min_broken_damage = 40

/obj/item/organ/external/chest/carapace/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/carapace, src, FALSE, min_broken_damage)

/obj/item/organ/external/chest/carapace/replaced()
	.=..()
	AddComponent(/datum/component/carapace_shell, owner)
