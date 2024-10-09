///Хитиновые конечности = прочее
/obj/item/organ/external/groin/carapace
	encased = "chitin"
	min_broken_damage = 40

/obj/item/organ/external/groin/carapace/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/carapace, src, FALSE, min_broken_damage)

/obj/item/organ/external/arm/carapace
	encased = "chitin"
	min_broken_damage = 20

/obj/item/organ/external/arm/carapace/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/carapace, src, TRUE, min_broken_damage)

/obj/item/organ/external/arm/right/carapace
	encased = "chitin"
	min_broken_damage = 20

/obj/item/organ/external/arm/right/carapace/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/carapace, src, TRUE, min_broken_damage)

/obj/item/organ/external/leg/carapace
	encased = "chitin"
	min_broken_damage = 20

/obj/item/organ/external/leg/carapace/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/carapace, src, TRUE, min_broken_damage)

/obj/item/organ/external/leg/right/carapace
	encased = "chitin"
	min_broken_damage = 20

/obj/item/organ/external/leg/right/carapace/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/carapace, src, TRUE, min_broken_damage)

/obj/item/organ/external/foot/carapace
	encased = "chitin"
	min_broken_damage = 20

/obj/item/organ/external/foot/carapace/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/carapace, src, TRUE, min_broken_damage)

/obj/item/organ/external/foot/right/carapace
	encased = "chitin"
	min_broken_damage = 20

/obj/item/organ/external/foot/right/carapace/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/carapace, src, TRUE, min_broken_damage)
