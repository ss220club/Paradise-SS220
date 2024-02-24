//===== Nucleation food =====
/obj/item/stack/sheet/mineral/uranium/Initialize(mapload)
	. = ..()
	material_type = MATERIAL_CLASS_RAD
	nutritional_value = 40

/obj/item/stack/ore/uranium/Initialize(mapload)
	. = ..()
	material_type = MATERIAL_CLASS_RAD
	nutritional_value = 20

/obj/item/coin/uranium/Initialize(mapload)
	. = ..()
	material_type = MATERIAL_CLASS_RAD
	nutritional_value = 40
