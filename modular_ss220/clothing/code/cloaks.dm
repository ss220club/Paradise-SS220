/obj/item/clothing/neck/cloak/captain_mantle/black
	name = "чёрная капитанская мантия"
	desc = "Носится верховным лидером станции NSS Cyberiad."
	icon = 'modular_ss220/clothing/icons/object/cloaks.dmi'
	icon_state = "capcloak_black"
	worn_icon = 'modular_ss220/clothing/icons/mob/cloaks.dmi'

/obj/item/clothing/neck/cloak/captain_mantle/black/Initialize(mapload)
	. = ..()
	desc = "Носится верховным лидером станции [station_name()]."

/* EI cloak */
/obj/item/clothing/suit/hooded/ei_cloak
	name = "плащ Gold On Black"
	desc = "Корпоративный плащ, выполненный в угольных тонах все с тем же золотым покрытием и специальным логотипом от Etamin Industry – золотой звездой."
	icon = 'modular_ss220/clothing/icons/object/cloaks.dmi'
	icon_state = "ei_cloak"
	worn_icon = 'modular_ss220/clothing/icons/mob/cloaks.dmi'
	sprite_sheets = list(
		"Kidan" = 'modular_ss220/clothing/icons/mob/species/kidan/cloaks.dmi',
		"Grey" = 'modular_ss220/clothing/icons/mob/species/grey/cloaks.dmi',
		"Vox" = 'modular_ss220/clothing/icons/mob/species/vox/cloaks.dmi',
		"Drask" = 'modular_ss220/clothing/icons/mob/species/drask/cloaks.dmi',
	)
	hoodtype = /obj/item/clothing/head/hooded/ei_hood

/obj/item/clothing/head/hooded/ei_hood
	name = "капюшон Gold On Black"
	desc = "Капюшон, прикрепленный к плащу Gold On Black."
	icon = 'modular_ss220/clothing/icons/object/hats.dmi'
	icon_state = "ei_hood"
	worn_icon = 'modular_ss220/clothing/icons/mob/hats.dmi'
	flags = BLOCKHAIR
	flags_inv = HIDEEARS
	sprite_sheets = list(
		"Tajaran" = 'modular_ss220/clothing/icons/mob/species/tajaran/hats.dmi',
		"Vulpkanin" = 'modular_ss220/clothing/icons/mob/species/vulpkanin/hats.dmi',
		"Kidan" = 'modular_ss220/clothing/icons/mob/species/kidan/hats.dmi',
		"Grey" = 'modular_ss220/clothing/icons/mob/species/grey/hats.dmi',
		"Vox" = 'modular_ss220/clothing/icons/mob/species/vox/hats.dmi',
		"Drask" = 'modular_ss220/clothing/icons/mob/species/drask/hats.dmi',
	)

/obj/item/clothing/neck/ei_cloak_hoodless
	name = "накидка Gold On Black"
	desc = "Корпоративная накидка, выполненная в угольных тонах все с тем же золотым покрытием и специальным логотипом от Etamin Industry – золотой звездой."
	icon = 'modular_ss220/clothing/icons/object/cloaks.dmi'
	icon_state = "ei_cloak"
	worn_icon = 'modular_ss220/clothing/icons/mob/cloaks.dmi'
	sprite_sheets = list(
		"Kidan" = 'modular_ss220/clothing/icons/mob/species/kidan/cloaks.dmi',
		"Grey" = 'modular_ss220/clothing/icons/mob/species/grey/cloaks.dmi',
		"Vox" = 'modular_ss220/clothing/icons/mob/species/vox/cloaks.dmi',
		"Drask" = 'modular_ss220/clothing/icons/mob/species/drask/cloaks.dmi',
	)
