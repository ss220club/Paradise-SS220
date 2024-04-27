/obj/item/clothing/suit/mantle/armor/captain/black
	name = "чёрная капитанская мантия"
	desc = "Носится верховным лидером станции NSS Cyberiad."
	icon = 'modular_ss220/clothing/icons/object/cloaks.dmi'
	icon_state = "capcloak_black"
	icon_override = 'modular_ss220/clothing/icons/mob/cloaks.dmi'
	item_state = "capcloak_black"

/obj/item/clothing/suit/mantle/armor/captain_black/Initialize(mapload)
	. = ..()
	desc = "Носится верховным лидером станции [station_name()]."

/obj/item/clothing/suit/mantle/armor/desert_mantle
	name = "пустынная мантия"
	desc = "Мешковатые обмотки из особой плотной ткани. Создает дополнительную защиту за счет многослойности и крепости материала."
	icon = 'modular_ss220/clothing/icons/object/cloaks.dmi'
	icon_state = "cloak_desert"
	icon_override = 'modular_ss220/clothing/icons/mob/cloaks.dmi'
	allowed = list(/obj/item/reagent_containers/drinks/flask, /obj/item/melee, /obj/item/flash, /obj/item/lighter, /obj/item/clothing/mask/cigarette, /obj/item/storage/fancy/cigarettes, /obj/item/tank/internals, /obj/item/gun/energy, /obj/item/gun/projectile, /obj/item/kitchen/knife)
