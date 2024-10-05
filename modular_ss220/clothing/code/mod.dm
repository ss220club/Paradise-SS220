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
/datum/mod_theme/skrell_raskinta
	name = "\improper Ме'керр"
	desc = "Боевая броня с функцией костюма для ВКД, созданная для войнов Раскинта Ме'керр-Кетиш."
	extended_desc = "Массивный бронекостюм, выполненный в черно-синих цветах, является отлечительной чертой  \
		военных формирований Раскинта-Кэтиш. Защитные пластины состоят из укрепленной керамики, в то время как\
		каркасные пластины выполнены из сплавов вороной пластали, позволяющей эффективно поглащать и рассеивать энергию \
		через радиаторные отводы на ''хвостовых'' окончаниях шлема. \
		Этот костюм является самым частовстречаемым в штурмовых отрядах Оборонительных Сил Скреллов. "
	default_skin = "skrell_elite"
	armor_type_1 = /obj/item/mod/armor/mod_theme_skrell_raskinta
	flag_2_flags = RAD_PROTECT_CONTENTS_2
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	siemens_coefficient = 0
	slowdown_inactive = 1
	slowdown_active = 0.25
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

/obj/item/mod/armor/mod_theme_skrell_raskinta
	armor = list(MELEE = 40, BULLET = 25, LASER = 25, ENERGY = 20, BOMB = 25, RAD = INFINITY, FIRE = 200, ACID = 200)

/obj/item/mod/control/pre_equipped/exclusive/skrell_raskinta
	theme = /datum/mod_theme/skrell_raskinta
	applied_cell = /obj/item/stock_parts/cell/super
	applied_modules = list(
		/obj/item/mod/module/storage/syndicate,
		/obj/item/mod/module/welding,
		/obj/item/mod/module/emp_shield,
		/obj/item/mod/module/status_readout,
		/obj/item/mod/module/flashlight,
		/obj/item/mod/module/magboot/advanced,
		/obj/item/mod/module/jetpack/advanced,
	)
	default_pins = list(
		/obj/item/mod/module/jetpack/advanced,
		/obj/item/mod/module/magboot/advanced,
	)


/datum/mod_theme/skrell_sardaukars
	name = "\improper Куи'кверр"
	desc = "Элитная боевая броня гвардейцев Императора Скреллианской империи."
	extended_desc = "Благодаря высшим технологическим достижениям скреллов, этот костюм сочетает в себе  \
		невероятные показатели защищенности и мобильности, являясь незаменимой вещью на вооружении Раскинта. \
		Носящие его воины Куи'кверр-Кэтиш являются личной гвардией Императора и выполняют самые сложные задачи по его воле. \
		Кроваво-белоснежные цвета, отождествляющие кровь врагов и власть Его Величества, скорее всего последнее \
		что вы увидите в своей жизни. "
	default_skin = "skrell_white"
	armor_type_1 = /obj/item/mod/armor/mod_theme_skrell_sardaukars
	resistance_flags = FIRE_PROOF
	flag_2_flags = RAD_PROTECT_CONTENTS_2
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	siemens_coefficient = 0
	slowdown_inactive = 0.5
	slowdown_active = 0
	complexity_max = DEFAULT_MAX_COMPLEXITY + 10
	allowed_suit_storage = list(
		/obj/item/ammo_box,
		/obj/item/ammo_casing,
		/obj/item/restraints/handcuffs,
		/obj/item/flash,
		/obj/item/melee/baton,
		/obj/item/gun,
	)
	skins = list(
		"skrell_white" = list(
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

/obj/item/mod/armor/mod_theme_skrell_sardaukars
	armor = list(MELEE = 100, BULLET = 100, LASER = 50, ENERGY = 50, BOMB = 100, RAD = INFINITY, FIRE = INFINITY, ACID = INFINITY)

/obj/item/mod/control/pre_equipped/exclusive/skrell_sardaukars
	theme = /datum/mod_theme/skrell_sardaukars
	applied_cell = /obj/item/stock_parts/cell/bluespace
	applied_modules = list(
		/obj/item/mod/module/storage/bluespace,
		/obj/item/mod/module/welding,
		/obj/item/mod/module/emp_shield,
		/obj/item/mod/module/jetpack/advanced,
		/obj/item/mod/module/status_readout,
		/obj/item/mod/module/magboot/advanced,
	)
	default_pins = list(
		/obj/item/mod/module/jetpack/advanced,
		/obj/item/mod/module/magboot/advanced,
	)

/obj/item/mod/control/pre_equipped/exclusive/skrell_sardaukars/Initialize(mapload, new_theme, new_skin, new_core, new_access)
	. = ..()
	ADD_TRAIT(chestplate, TRAIT_RSG_IMMUNE, ROUNDSTART_TRAIT)
