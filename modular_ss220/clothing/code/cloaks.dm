/obj/item/clothing/suit/mantle/armor/captain_black
	name = "чёрная капитанская мантия"
	desc = "Носится верховным лидером станции NSS Cyberiad."
	icon = 'modular_ss220/clothing/icons/object/cloaks.dmi'
	icon_state = "capcloak_black"
	icon_override = 'modular_ss220/clothing/icons/mob/cloaks.dmi'
	item_state = "capcloak_black"
	armor = list(MELEE = 50, BULLET = 35, LASER = 50, ENERGY = 5, BOMB = 15, RAD = 0, FIRE = 50, ACID = 50)

/obj/item/clothing/suit/mantle/armor/captain_black/Initialize(mapload)
	. = ..()
	desc = "Носится верховным лидером станции [station_name()]."
