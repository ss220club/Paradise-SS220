/datum/mod_theme/blueshield
	name = "blueshield"
	desc = "A modified Shellguard Munitions security default suit."
	extended_desc = "A Shellguard Munitions classic, this model of MODsuit has been designed for quick response to \
		hostile situations. These suits have been layered with plating worthy enough for fires or corrosive environments, \
		and come with composite cushioning and an advanced honeycomb structure underneath the hull to ensure protection \
		against broken bones or possible avulsions. The suit's legs have been given more rugged actuators, \
		allowing the suit to do more work in carrying the weight. However, the systems used in these suits are more than \
		a few years out of date, leading to an overall lower capacity for modules."
	default_skin = "blueshield"
	armor_type_1 = /obj/item/mod/armor/mod_theme_blueshield
	complexity_max = DEFAULT_MAX_COMPLEXITY - 3
	slowdown_inactive = 1
	slowdown_active = 0.45
	ui_theme = "blueshield"
	allowed_suit_storage = list(
		/obj/item/ammo_box,
		/obj/item/ammo_casing,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/restraints/handcuffs,
		/obj/item/flash,
		/obj/item/melee/baton,
		/obj/item/gun,
	)
	skins = list(
		"blueshield" = list(
			HELMET_FLAGS = list(
				UNSEALED_LAYER = null,
				UNSEALED_CLOTHING = THICKMATERIAL,
				SEALED_CLOTHING = STOPSPRESSUREDMAGE | BLOCKHAIR,
				UNSEALED_INVISIBILITY = HIDEFACE,
				SEALED_INVISIBILITY = HIDEMASK | HIDEEYES | HIDEFACE,
				UNSEALED_COVER = HEADCOVERSMOUTH,
				SEALED_COVER = HEADCOVERSEYES,
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

/obj/item/mod/armor/mod_theme_blueshield
	armor = list(MELEE = 25, BULLET = 20, LASER = 20, ENERGY = 5, BOMB = 25, RAD = 0, FIRE = 150, ACID = 150)
