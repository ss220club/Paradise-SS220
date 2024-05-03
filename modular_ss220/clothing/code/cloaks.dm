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
	item_state = "cloak_desert"
	allowed = list(/obj/item/reagent_containers/drinks/flask, /obj/item/melee, /obj/item/flash, /obj/item/lighter, /obj/item/storage/fancy/cigarettes, /obj/item/tank/internals, /obj/item/gun, /obj/item/kitchen/knife, /obj/item/dualsaber)
	sprite_sheets = list(
		"Human"				= 	'modular_ss220/clothing/icons/mob/cloaks.dmi',
		"Diona" 			= 	'modular_ss220/clothing/icons/mob/cloaks.dmi',
		"Drask" 			= 	'modular_ss220/clothing/icons/mob/cloaks.dmi',
		"Grey" 				= 	'modular_ss220/clothing/icons/mob/cloaks.dmi',
		"Human" 			= 	'modular_ss220/clothing/icons/mob/cloaks.dmi',
		"Machine"			= 	'modular_ss220/clothing/icons/mob/cloaks.dmi',
		"Nian" 				= 	'modular_ss220/clothing/icons/mob/cloaks.dmi',
		"Plasmaman" 		= 	'modular_ss220/clothing/icons/mob/cloaks.dmi',
		"Skrell" 			= 	'modular_ss220/clothing/icons/mob/cloaks.dmi',
		"Slime People" 		= 	'modular_ss220/clothing/icons/mob/cloaks.dmi',
		"Unathi" 			= 	'modular_ss220/clothing/icons/mob/cloaks.dmi',
		"Vox" 				= 	'modular_ss220/clothing/icons/mob/cloaks.dmi',
		"Nucleation"		=	'modular_ss220/clothing/icons/mob/cloaks.dmi',
		"Kidan" 			= 	'modular_ss220/clothing/icons/mob/species/kidan/cloaks.dmi',
		"Tajaran" 			=	'modular_ss220/clothing/icons/mob/cloaks.dmi',
		"Vulpkanin" 		= 	'modular_ss220/clothing/icons/mob/species/vulpkanin/cloaks.dmi',
	)

/obj/item/clothing/suit/mantle/armor/desert_mantle/cloak2
	name = "пустынный плащ"
	desc = "Длинный и удобный плащ из особой плотной ткани, позволяет защититься от солнца и недоброжелателей."
	icon_state = "cloak_desert2"
	item_state = "cloak_desert2"
	flags_inv = HIDETAIL

/obj/item/clothing/suit/mantle/armor/desert_mantle/ntcloak
	name = "чёрная офицерская мантия"
	desc = "Носится офицером Центрального Командования Нанотрейзен."
	icon_state = "ntcloak"
	item_state = "ntcloak"
	species_restricted = list("Human")

/obj/item/clothing/suit/mantle/armor/desert_mantle/ntcloak/trench
	name = "чёрная офицерская тренчкот"
	desc = "Носится офицером Центрального Командования Нанотрейзен."
	icon_state = "ntcloak2"
	item_state = "ntcloak2"
