// MARK: MODsuit clothes
/obj/item/clothing/head/mod/exclusive
	icon = 'modular_ss220/clothing/icons/object/mod_clothing.dmi'
	item_state = 'modular_ss220/clothing/icons/mob/mod_clothing.dmi'
	icon_override = 'modular_ss220/clothing/icons/mob/mod_clothing.dmi'
	sprite_sheets = list(
		"Human" = 'modular_ss220/clothing/icons/mob/mod_clothing.dmi',
		"Skrell" = 'modular_ss220/clothing/icons/mob/species/skrell/mod_clothing.dmi',
		)

/obj/item/clothing/suit/mod/exclusive
	icon = 'modular_ss220/clothing/icons/object/mod_clothing.dmi'
	item_state = 'modular_ss220/clothing/icons/mob/mod_clothing.dmi'
	icon_override = 'modular_ss220/clothing/icons/mob/mod_clothing.dmi'
	sprite_sheets = list(
		"Human" = 'modular_ss220/clothing/icons/mob/mod_clothing.dmi',
		"Skrell" = 'modular_ss220/clothing/icons/mob/species/skrell/mod_clothing.dmi',
		)

/obj/item/clothing/gloves/mod/exclusive
	icon = 'modular_ss220/clothing/icons/object/mod_clothing.dmi'
	item_state = 'modular_ss220/clothing/icons/mob/mod_clothing.dmi'
	icon_override = 'modular_ss220/clothing/icons/mob/mod_clothing.dmi'
	sprite_sheets = list(
		"Human" = 'modular_ss220/clothing/icons/mob/mod_clothing.dmi',
		"Skrell" = 'modular_ss220/clothing/icons/mob/species/skrell/mod_clothing.dmi',
		)

/obj/item/clothing/shoes/mod/exclusive
	icon = 'modular_ss220/clothing/icons/object/mod_clothing.dmi'
	item_state = 'modular_ss220/clothing/icons/mob/mod_clothing.dmi'
	icon_override = 'modular_ss220/clothing/icons/mob/mod_clothing.dmi'
	sprite_sheets = list(
		"Human" = 'modular_ss220/clothing/icons/mob/mod_clothing.dmi',
		"Skrell" = 'modular_ss220/clothing/icons/mob/species/skrell/mod_clothing.dmi',
		)

// MARK: MODsuit control
/obj/item/mod/control/proc/build_head()
	return new /obj/item/clothing/head/mod(src)

/obj/item/mod/control/proc/build_suit()
	return new /obj/item/clothing/suit/mod(src)

/obj/item/mod/control/proc/build_gloves()
	return new /obj/item/clothing/gloves/mod(src)

/obj/item/mod/control/proc/build_shoes()
	return new /obj/item/clothing/shoes/mod(src)

/obj/item/mod/control/pre_equipped/exclusive
	icon = 'modular_ss220/clothing/icons/object/mod_clothing.dmi'
	icon_override = 'modular_ss220/clothing/icons/mob/mod_clothing.dmi'

/obj/item/mod/control/pre_equipped/exclusive/build_head()
	return new /obj/item/clothing/head/mod/exclusive(src)

/obj/item/mod/control/pre_equipped/exclusive/build_suit()
	return new /obj/item/clothing/suit/mod/exclusive(src)

/obj/item/mod/control/pre_equipped/exclusive/build_gloves()
	return new /obj/item/clothing/gloves/mod/exclusive(src)

/obj/item/mod/control/pre_equipped/exclusive/build_shoes()
	return new /obj/item/clothing/shoes/mod/exclusive(src)

// MARK: Skrell elite MODsuit
/datum/mod_theme/skrell_elite
	name = "skrell"
	desc = "A high-speed rescue suit by Nanotrasen, intended for its' emergency response teams."
	extended_desc = "A streamlined suit of Nanotrasen design, these sleek black suits are only worn by \
		elite emergency response personnel to help save the day. While the slim and nimble design of the suit \
		cuts the ceramics and ablatives in it down, dropping the protection, \
		it keeps the wearer safe from the harsh void of space while sacrificing no speed whatsoever. \
		While wearing it you feel an extreme deference to darkness. "
	default_skin = "skrell_elite"
	armor_type_1 = /obj/item/mod/armor/mod_theme_skrell_elite

	resistance_flags = FIRE_PROOF
	flag_2_flags = RAD_PROTECT_CONTENTS_2
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	siemens_coefficient = 0
	slowdown_inactive = 0.5
	slowdown_active = 0
	complexity_max = DEFAULT_MAX_COMPLEXITY + 5
	allowed_suit_storage = list(
		/obj/item/ammo_box,
		/obj/item/ammo_casing,
		/obj/item/restraints/handcuffs,
		/obj/item/flash,
		/obj/item/melee/baton,
		/obj/item/gun,
	)
	skins = list(
		"skrell_elite" = list(
			MOD_ICON_OVERRIDE = 'modular_ss220/clothing/icons/object/mod_clothing.dmi',
			HELMET_FLAGS = list(
				UNSEALED_LAYER = COLLAR_LAYER,

				SEALED_CLOTHING = THICKMATERIAL | STOPSPRESSUREDMAGE | BLOCK_GAS_SMOKE_EFFECT | BLOCKHAIR,
				UNSEALED_INVISIBILITY = HIDEFACE,
				SEALED_INVISIBILITY = HIDEMASK | HIDEEYES | HIDEFACE,
				SEALED_COVER = HEADCOVERSMOUTH | HEADCOVERSEYES,
			),
			CHESTPLATE_FLAGS = list(
				UNSEALED_CLOTHING = THICKMATERIAL,
				SEALED_CLOTHING = STOPSPRESSUREDMAGE,
				SEALED_INVISIBILITY = HIDEJUMPSUIT | HIDETAIL,
			),
			GAUNTLETS_FLAGS = list(
				UNSEALED_CLOTHING = THICKMATERIAL,
				SEALED_CLOTHING = STOPSPRESSUREDMAGE,
				CAN_OVERSLOT = TRUE,
			),
			BOOTS_FLAGS = list(
				UNSEALED_CLOTHING = THICKMATERIAL,
				SEALED_CLOTHING = STOPSPRESSUREDMAGE,
				CAN_OVERSLOT = TRUE,
			),
		),
	)

/obj/item/mod/armor/mod_theme_skrell_elite
	armor = list(MELEE = 40, BULLET = 25, LASER = 25, ENERGY = 20, BOMB = 25, RAD = INFINITY, FIRE = 200, ACID = 200)

/obj/item/mod/control/pre_equipped/exclusive/skrell_elite
	theme = /datum/mod_theme/skrell_elite
	applied_cell = /obj/item/stock_parts/cell/bluespace
