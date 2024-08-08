/obj/item/storage/backpack/vox
	name = "vox backpack"
	desc = "Рюкзак воксов из плотно переплетенного синтетического волокна. Хорошо защищает спину носителя при побегах и вмещает достаточно добра."
	icon_state = "backpack_vox"
	item_color = "backpack_vox"
	item_state = "backpack_vox"
	//var/list/species_restricted = list("Vox")
	icon = 'modular_ss220/antagonists/icons/clothing/obj_storage.dmi'
	icon_override = 'modular_ss220/antagonists/icons/clothing/mob/back.dmi'
	sprite_sheets = list(
		"Vox" = 'modular_ss220/antagonists/icons/clothing/mob/vox/back.dmi'
		)
	lefthand_file = 'modular_ss220/antagonists/icons/clothing/inhands/clothing_lefthand.dmi'
	righthand_file = 'modular_ss220/antagonists/icons/clothing/inhands/clothing_righthand.dmi'
	armor = list(MELEE = 5, BULLET = 5, LASER = 15, ENERGY = 10, BOMB = 10, RAD = 30, FIRE = 60, ACID = 50)
	resistance_flags = FIRE_PROOF
	origin_tech = "syndicate=1"
	max_combined_w_class = 35

/obj/item/storage/backpack/satchel_flat/vox
	name = "vox satchel"
	desc = "Ранец воксов из синтетического волокна. Компактный, из-за чего его можно отлично прятать."
	icon_state = "satchel_vox"
	item_color = "satchel_vox"
	item_state = "satchel_vox"
	icon = 'modular_ss220/antagonists/icons/clothing/obj_storage.dmi'
	icon_override = 'modular_ss220/antagonists/icons/clothing/mob/back.dmi'
	sprite_sheets = list(
		"Vox" = 'modular_ss220/antagonists/icons/clothing/mob/vox/back.dmi'
		)
	lefthand_file = 'modular_ss220/antagonists/icons/clothing/inhands/clothing_lefthand.dmi'
	righthand_file = 'modular_ss220/antagonists/icons/clothing/inhands/clothing_righthand.dmi'
	resistance_flags = FIRE_PROOF
	origin_tech = "syndicate=1"
	max_combined_w_class = 25

/obj/item/storage/backpack/duffel/vox
	name = "vox duffelbag"
	desc = "Сумка воксов из синтетического волокна. Емкий, вмещает много добра."
	icon_state = "duffel_vox"
	item_color = "duffel_vox"
	item_state = "duffel_vox"
	icon = 'modular_ss220/antagonists/icons/clothing/obj_storage.dmi'
	icon_override = 'modular_ss220/antagonists/icons/clothing/mob/back.dmi'
	sprite_sheets = list(
		"Vox" = 'modular_ss220/antagonists/icons/clothing/mob/vox/back.dmi'
		)
	lefthand_file = 'modular_ss220/antagonists/icons/clothing/inhands/clothing_lefthand.dmi'
	righthand_file = 'modular_ss220/antagonists/icons/clothing/inhands/clothing_righthand.dmi'
	silent = TRUE
	zip_time = 2
	resistance_flags = FIRE_PROOF
	origin_tech = "syndicate=1"
	max_combined_w_class = 45
	allow_same_size = TRUE
	cant_hold = list(/obj/item/storage/backpack)
