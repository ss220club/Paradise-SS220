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

//desert
/obj/item/clothing/suit/mantle/armor/desert_mantle
	name = "пустынная мантия"
	desc = "Мешковатые обмотки из особой плотной ткани. Создает дополнительную защиту за счет многослойности и крепости материала."
	icon = 'modular_ss220/clothing/icons/object/cloaks.dmi'
	icon_state = "cloak_desert"
	icon_override = 'modular_ss220/clothing/icons/mob/cloaks.dmi'
	item_state = "cloak_desert"
	allowed = list(/obj/item/reagent_containers/drinks/flask, /obj/item/melee, /obj/item/flash, /obj/item/lighter, /obj/item/clothing/mask/cigarette, /obj/item/storage/fancy/cigarettes, /obj/item/tank/internals, /obj/item/gun, /obj/item/kitchen/knife)

/obj/item/clothing/suit/mantle/armor/desert_mantle/cloak2
	name = "пустынный плащ"
	desc = "Длинный и удобный плащ из особой плотной ткани, позволяет прикрываться для защиты от солнца и недоброжелателей."
	icon_state = "cloak_desert2"
	item_state = "cloak_desert2"

/obj/item/clothing/suit/mantle/armor/captain/ntcloak
	name = "чёрная офицерская мантия"
	desc = "Носится офицером Центрального Командования Нанотрейзен."
	icon = 'modular_ss220/clothing/icons/object/cloaks.dmi'
	icon_state = "ntcloak"
	icon_override = 'modular_ss220/clothing/icons/mob/cloaks.dmi'
	item_state = "ntcloak"

/obj/item/clothing/suit/mantle/armor/captain/ntcloak/trench
	name = "чёрная офицерская тренчкот"
	desc = "Носится офицером Центрального Командования Нанотрейзен."
	icon_state = "ntcloak2"
	item_state = "ntcloak2"

/obj/item/clothing/suit/mantle/armor/desert_mantle/kidanmantle
	name = "киданский плащ"
	desc = "Длинный и удобный плащ из особой плотной ткани, позволяет прикрываться для защиты от солнца и недоброжелателей."
	icon_state = "kidan_mantle"
	item_state = "kidan_mantle"
	species_restricted = list("Kidan")
