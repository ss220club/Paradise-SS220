/obj/machinery/economy/vending/autodrobe/Initialize(mapload)
	products += list(
		/obj/item/clothing/head/ratge = 1,
		)
	prices += list(
		/obj/item/clothing/head/ratge = 75,
		)
	. = ..()

/obj/item/clothing/head/ratge
	name = "ratge head"
	desc = "Ну ты и крыса!"
	icon = 'modular_ss220/clothing/icons/object/hats.dmi'
	icon_state = "ratgehead"
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'
	flags = BLOCKHAIR
	flags_inv = HIDEMASK | HIDEEARS | HIDEEYES | HIDEFACE
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	sprite_sheets = list(
		"Abductor" 			= 	'modular_ss220/clothing/icons/mob/hats.dmi',
		"Ancient Skeleton" 	= 	'modular_ss220/clothing/icons/mob/hats.dmi',
		"Diona" 			= 	'modular_ss220/clothing/icons/mob/hats.dmi',
		"Drask" 			= 	'modular_ss220/clothing/icons/mob/hats.dmi',
		"Golem" 			= 	'modular_ss220/clothing/icons/mob/hats.dmi',
		"Grey" 				= 	'modular_ss220/clothing/icons/mob/species/grey/hats.dmi',
		"Human" 			= 	'modular_ss220/clothing/icons/mob/hats.dmi',
		"Kidan" 			= 	'modular_ss220/clothing/icons/mob/species/kidan/hats.dmi',
		"Machine"			= 	'modular_ss220/clothing/icons/mob/hats.dmi',
		"Monkey" 			= 	'modular_ss220/clothing/icons/mob/hats.dmi',
		"Nian" 				= 	'modular_ss220/clothing/icons/mob/hats.dmi',
		"Plasmaman" 		= 	'modular_ss220/clothing/icons/mob/hats.dmi',
		"Shadow" 			= 	'modular_ss220/clothing/icons/mob/hats.dmi',
		"Skrell" 			= 	'modular_ss220/clothing/icons/mob/hats.dmi',
		"Slime People" 		= 	'modular_ss220/clothing/icons/mob/hats.dmi',
		"Tajaran" 			= 	'modular_ss220/clothing/icons/mob/species/tajaran/hats.dmi',
		"Unathi" 			= 	'modular_ss220/clothing/icons/mob/hats.dmi',
		"Vox" 				= 	'modular_ss220/clothing/icons/mob/hats.dmi',
		"Vulpkanin" 		= 	'modular_ss220/clothing/icons/mob/species/vulpkanin/hats.dmi',
		)
