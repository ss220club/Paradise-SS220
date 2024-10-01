// Modular MOD's clothes
// Сюда новые моды для людей и остальных рас
/obj/item/clothing/head/mod/modular_mods
	icon = 'modular_ss220/clothing/icons/object/mod_clothing.dmi'
	item_state = 'modular_ss220/clothing/icons/mob/mod_clothing.dmi'
	icon_override = 'modular_ss220/clothing/icons/mob/mod_clothing.dmi'
	icon_state = "skrell_elite-helmet"
	sprite_sheets = list(
		"Human" 			= 	'modular_ss220/clothing/icons/mob/mod_clothing.dmi',
		"Skrell" 			= 	'modular_ss220/clothing/icons/mob/species/skrell/mod_clothing.dmi',
		)

/obj/item/clothing/suit/mod/modular_mods
	icon = 'modular_ss220/clothing/icons/object/mod_clothing.dmi'
	item_state = 'modular_ss220/clothing/icons/mob/mod_clothing.dmi'
	icon_override = 'modular_ss220/clothing/icons/mob/mod_clothing.dmi'
	icon_state = "skrell_elite-chestplate"
	sprite_sheets = list(
		"Human" 			= 	'modular_ss220/clothing/icons/mob/mod_clothing.dmi',
		"Skrell" 			= 	'modular_ss220/clothing/icons/mob/species/skrell/mod_clothing.dmi',
		)

/obj/item/clothing/gloves/mod/modular_mods
	icon = 'modular_ss220/clothing/icons/object/mod_clothing.dmi'
	item_state = 'modular_ss220/clothing/icons/mob/mod_clothing.dmi'
	icon_override = 'modular_ss220/clothing/icons/mob/mod_clothing.dmi'
	icon_state = "skrell_elite-gauntlets"
	sprite_sheets = list(
		"Human" 			= 	'modular_ss220/clothing/icons/mob/mod_clothing.dmi',
		"Skrell" 			= 	'modular_ss220/clothing/icons/mob/species/skrell/mod_clothing.dmi',
		)

/obj/item/clothing/shoes/mod/modular_mods
	icon = 'modular_ss220/clothing/icons/object/mod_clothing.dmi'
	item_state = 'modular_ss220/clothing/icons/mob/mod_clothing.dmi'
	icon_override = 'modular_ss220/clothing/icons/mob/mod_clothing.dmi'
	icon_state = "skrell_elite-boots"
	sprite_sheets = list(
		"Human" 			= 	'modular_ss220/clothing/icons/mob/mod_clothing.dmi',
		"Skrell" 			= 	'modular_ss220/clothing/icons/mob/species/skrell/mod_clothing.dmi',
		)

// Modular MOD's control

/obj/item/mod/control/modular_mods
	icon = 'modular_ss220/clothing/icons/object/mod_clothing.dmi'
	icon_override = 'modular_ss220/clothing/icons/mob/mod_clothing.dmi'

/obj/item/mod/control/modular_mods/Initialize(mapload, datum/mod_theme/new_theme, new_skin, obj/item/mod/core/new_core)
	. = ..()
	if(new_theme)
		theme = new_theme
	theme = GLOB.mod_themes[theme]
	slot_flags = theme.slot_flags
	extended_desc = theme.extended_desc
	slowdown_inactive = theme.slowdown_inactive
	slowdown_active = theme.slowdown_active
	complexity_max = theme.complexity_max
	ui_theme = theme.ui_theme
	charge_drain = theme.charge_drain
	wires = new/datum/wires/mod(src)
	if(length(req_access))
		locked = TRUE
	new_core?.install(src)
	helmet = new /obj/item/clothing/shoes/mod/modular_mods(src)
	mod_parts += helmet
	chestplate = new /obj/item/clothing/shoes/mod/modular_mods(src)
	chestplate.allowed += theme.allowed_suit_storage
	mod_parts += chestplate
	gauntlets = new /obj/item/clothing/shoes/mod/modular_mods(src)
	mod_parts += gauntlets
	boots = new /obj/item/clothing/shoes/mod/modular_mods(src)
	mod_parts += boots
	var/list/all_parts = mod_parts + src
	for(var/obj/item/part as anything in all_parts)
		part.name = "[theme.name] [part.name]"
		part.desc = "[part.desc] [theme.desc]"
		part.armor = part.armor.attachArmor(theme.armor_type_2.armor)
		part.resistance_flags = theme.resistance_flags
		part.flags |= theme.atom_flags //flags like initialization or admin spawning are here, so we cant set, have to add
		part.heat_protection = NONE
		part.cold_protection = NONE
		part.max_heat_protection_temperature = theme.max_heat_protection_temperature
		part.min_cold_protection_temperature = theme.min_cold_protection_temperature
		part.siemens_coefficient = theme.siemens_coefficient
		part.flags_2 = theme.flag_2_flags
	for(var/obj/item/part as anything in mod_parts)
		RegisterSignal(part, COMSIG_OBJ_DECONSTRUCT, PROC_REF(on_part_destruction)) //look into
		RegisterSignal(part, COMSIG_PARENT_QDELETING, PROC_REF(on_part_deletion))
	set_mod_skin(new_skin || theme.default_skin)
	update_speed()
	RegisterSignal(src, COMSIG_ATOM_EXITED, PROC_REF(on_exit))
	for(var/obj/item/mod/module/module as anything in theme.inbuilt_modules)
		module = new module(src)
		install(module)
	ADD_TRAIT(src, TRAIT_ADJACENCY_TRANSPARENT, ROUNDSTART_TRAIT)

//Skrell elite mod
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


// Pre equipped

/obj/item/mod/control/pre_equipped/skrell_elite
	theme = /datum/mod_theme/skrell_elite
	applied_cell = /obj/item/stock_parts/cell/bluespace
