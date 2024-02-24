//===== Plasmaman food =====
/obj/item/stack/sheet/plasmaglass/Initialize(mapload)
	. = ..()
	material_type = MATERIAL_CLASS_PLASMA
	nutritional_value = 10

/obj/item/stack/ore/plasma/Initialize(mapload)
	. = ..()
	material_type = MATERIAL_CLASS_PLASMA
	nutritional_value = 10

/obj/item/stack/sheet/mineral/plasma/Initialize(mapload)
	. = ..()
	material_type = MATERIAL_CLASS_PLASMA
	nutritional_value = 20

/obj/item/coin/plasma/Initialize(mapload)
	. = ..()
	material_type = MATERIAL_CLASS_PLASMA
	nutritional_value = 40
