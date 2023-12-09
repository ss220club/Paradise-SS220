/obj/item/clothing/head/mod
	name = "MOD helmet"
	desc = "A helmet for a MODsuit."
	icon = 'modular_ss220/clothing/icons/object/mod_clothings.dmi'
	icon_state = "standard-helmet"
	base_icon_state = "helmet"
	item_state = 'modular_ss220/clothing/icons/mob/mod_clothing.dmi'
	icon_override = 'modular_ss220/clothing/icons/mob/mod_clothing.dmi'
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, RAD = 0, FIRE = 0, ACID = 0)
	body_parts_covered = HEAD
	heat_protection = HEAD
	cold_protection = HEAD
	sprite_sheets = list(
		"Grey" = 'icons/mob/clothing/modsuit/species/grey_helmets.dmi',
		"Vulpkanin" = 'icons/mob/clothing/modsuit/species/vulp_modsuits.dmi',
		"Tajaran" = 'icons/mob/clothing/modsuit/species/taj_modsuits.dmi',
		"Unathi" = 'icons/mob/clothing/modsuit/species/modsuits_younahthee.dmi'
		)

/obj/item/clothing/suit/mod
	name = "MOD chestplate"
	desc = "A chestplate for a MODsuit."
	icon = 'modular_ss220/clothing/icons/object/mod_clothings.dmi'
	icon_state = "standard-chestplate"
	base_icon_state = "chestplate"
	item_state = 'modular_ss220/clothing/icons/mob/mod_clothing.dmi'
	icon_override = 'modular_ss220/clothing/icons/mob/mod_clothing.dmi'
	blood_overlay_type = "armor"
	allowed = list(
		/obj/item/tank/internals,
		/obj/item/flashlight,
		/obj/item/tank/jetpack/oxygen/captain,
	)
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, RAD = 0, FIRE = 0, ACID = 0)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	heat_protection = UPPER_TORSO|LOWER_TORSO
	cold_protection = UPPER_TORSO|LOWER_TORSO
	hide_tail_by_species = list("modsuit")
	sprite_sheets = list(
		"Vulpkanin" = 'icons/mob/clothing/modsuit/species/vulp_modsuits.dmi',
		"Tajaran" = 'icons/mob/clothing/modsuit/species/taj_modsuits.dmi',
		"Unathi" = 'icons/mob/clothing/modsuit/species/modsuits_younahthee.dmi'
		)


/obj/item/clothing/gloves/mod
	name = "MOD gauntlets"
	desc = "A pair of gauntlets for a MODsuit."
	icon = 'modular_ss220/clothing/icons/object/mod_clothings.dmi'
	icon_state = "standard-gauntlets"
	base_icon_state = "gauntlets"
	item_state = 'modular_ss220/clothing/icons/mob/mod_clothing.dmi'
	icon_override = 'modular_ss220/clothing/icons/mob/mod_clothing.dmi'
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, RAD = 0, FIRE = 0, ACID = 0)
	body_parts_covered = HANDS|ARMS
	heat_protection = HANDS|ARMS
	cold_protection = HANDS|ARMS
	sprite_sheets = list(
		"Vulpkanin" = 'icons/mob/clothing/modsuit/species/vulp_modsuits.dmi',
		"Tajaran" = 'icons/mob/clothing/modsuit/species/taj_modsuits.dmi',
		"Unathi" = 'icons/mob/clothing/modsuit/species/modsuits_younahthee.dmi'
		)


/obj/item/clothing/shoes/mod
	name = "MOD boots"
	desc = "A pair of boots for a MODsuit."
	icon = 'modular_ss220/clothing/icons/object/mod_clothings.dmi'
	icon_state = "standard-boots"
	base_icon_state = "boots"
	item_state = 'modular_ss220/clothing/icons/mob/mod_clothing.dmi'
	icon_override = 'modular_ss220/clothing/icons/mob/mod_clothing.dmi'
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, RAD = 0, FIRE = 0, ACID = 0)
	body_parts_covered = FEET|LEGS
	heat_protection = FEET|LEGS
	cold_protection = FEET|LEGS
	sprite_sheets = list(
		"Vulpkanin" = 'icons/mob/clothing/modsuit/species/vulp_modsuits.dmi',
		"Tajaran" = 'icons/mob/clothing/modsuit/species/taj_modsuits.dmi ',
		"Unathi" = 'icons/mob/clothing/modsuit/species/modsuits_younahthee.dmi'
		)

/obj/item/mod
	name = "Base MOD"
	desc = "You should not see this, yell at a coder!"
	icon = 'modular_ss220/clothing/icons/object/mod_clothings.dmi'// figure out how to work with 2 of these
	icon_override = 'modular_ss220/clothing/icons/mob/mod_clothing.dmi'

/obj/item/mod/control
	name = "MOD control unit"
	desc = "The control unit of a Modular Outerwear Device, a powered suit that protects against various environments."

	icon_state = "standard-control"
	icon_state = "mod_control"
	item_state = "mod_control"
	base_icon_state = "control"
	slot_flags = SLOT_FLAG_BACK
	strip_delay = 10 SECONDS
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, RAD = 0, FIRE = 0, ACID = 0)
	actions_types = list(
		/datum/action/item_action/mod/deploy,
		/datum/action/item_action/mod/activate,
		/datum/action/item_action/mod/panel,
		/datum/action/item_action/mod/module,
	)
	resistance_flags = NONE
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	siemens_coefficient = 0.5
