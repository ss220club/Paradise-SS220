/obj/item/clothing/head/helmet/bike_helmet
	name = "байкерский шлем"
	desc = "Крутой шлем."
	icon = 'modular_ss220/clothing/icons/object/hats.dmi'
	icon_state = "bike_helmet"
	icon_override = 'modular_ss220/clothing/icons/mob/helmets.dmi'
	item_state = "bike_helmet"
	lefthand_file = 'modular_ss220/clothing/icons/inhands/left_hand.dmi'
	righthand_file = 'modular_ss220/clothing/icons/inhands/right_hand.dmi'
	toggle_message = "Вы опустили защитное стекло"
	alt_toggle_message = "Вы подняли защитное стекло"
	actions_types = list(/datum/action/item_action/toggle_helmet_mode)
	armor = list("melee" = 25, "bullet" = 15, "laser" = 10, "energy" = 10, "bomb" = 10, "bio" = 0, "rad" = 0, "fire" = 15, "acid" = 0)
	can_toggle = TRUE
	toggle_sound = 'sound/weapons/tap.ogg'
	dog_fashion = null
	sprite_sheets = list(
		"Drask" = 'modular_ss220/clothing/icons/mob/species/drask/helmet.dmi',
		"Skrell" = 'modular_ss220/clothing/icons/mob/species/skrell/helmet.dmi',
		"Tajaran" = 'modular_ss220/clothing/icons/mob/species/tajaran/helmet.dmi',
		"Unathi" = 'modular_ss220/clothing/icons/mob/species/unathi/helmet.dmi',
		"Vox" = 'modular_ss220/clothing/icons/mob/species/vox/helmet.dmi',
		"Vulpkanin" = 'modular_ss220/clothing/icons/mob/species/vulpkanin/helmet.dmi',
		)
