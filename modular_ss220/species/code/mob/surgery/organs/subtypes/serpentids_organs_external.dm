///Хитиновые конечности
/obj/item/organ/external/chest/carapace
	encased = "chitin"
	min_broken_damage = 40

/obj/item/organ/external/chest/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/carapace, src, FALSE, min_broken_damage)

/obj/item/organ/external/groin/carapace
	encased = "chitin"
	min_broken_damage = 40

/obj/item/organ/external/groin/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/carapace, src, FALSE, min_broken_damage)

/obj/item/organ/external/head/carapace
	encased = "chitin"
	min_broken_damage = 30

/obj/item/organ/external/head/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/carapace, src, FALSE, min_broken_damage)

/obj/item/organ/external/arm/carapace
	encased = "chitin"
	min_broken_damage = 20

/obj/item/organ/external/arm/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/carapace, src, TRUE, min_broken_damage)

/obj/item/organ/external/arm/right/carapace
	encased = "chitin"
	min_broken_damage = 20

/obj/item/organ/external/arm/right/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/carapace, src, TRUE, min_broken_damage)

/obj/item/organ/external/leg/carapace
	encased = "chitin"
	min_broken_damage = 20

/obj/item/organ/external/leg/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/carapace, src, TRUE, min_broken_damage)

/obj/item/organ/external/leg/right/carapace
	encased = "chitin"
	min_broken_damage = 20

/obj/item/organ/external/leg/right/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/carapace, src, TRUE, min_broken_damage)

/obj/item/organ/external/hand/carapace
	encased = "chitin"
	min_broken_damage = 20

/obj/item/organ/external/hand/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/carapace, src, TRUE, min_broken_damage)

/obj/item/organ/external/hand/right/carapace
	encased = "chitin"
	min_broken_damage = 20

/obj/item/organ/external/hand/right/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/carapace, src, TRUE, min_broken_damage)

/obj/item/organ/external/foot/carapace
	encased = "chitin"
	min_broken_damage = 20

/obj/item/organ/external/foot/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/carapace, src, TRUE, min_broken_damage)

/obj/item/organ/external/foot/right/carapace
	encased = "chitin"
	min_broken_damage = 20

/obj/item/organ/external/foot/right/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/carapace, src, TRUE, min_broken_damage)
