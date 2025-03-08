/obj/item/clothing/glasses/hud/security/sunglasses/eyepatch
	name = "повязка на глаз с secHUD"
	desc = "Устаревший вариант размещения secHUD с защитой глаз от вспышек, от подобного исполнения давно отказались в пользу более удобного и легковесного размещения в солнцезащитных очках, однако многие продолжают пользваться старым вариантом в угоду стилю. Данную повязку можно носить как на правом, так и на левом глазу."
	icon = 'modular_ss220/clothing/icons/object/eyes.dmi'
	icon_state = "hudpatch"
	item_state = "hudpatch"
	item_color = "hudpatch"
	sprite_sheets = list(
		"Human" = 'modular_ss220/clothing/icons/mob/eyes.dmi',
		"Tajaran" = 'modular_ss220/clothing/icons/mob/eyes.dmi',
		"Vulpkanin" = 'modular_ss220/clothing/icons/mob/eyes.dmi',
		"Kidan" = 'modular_ss220/clothing/icons/mob/species/kidan/eyes.dmi',
		"Skrell" = 'modular_ss220/clothing/icons/mob/eyes.dmi',
		"Nucleation" = 'modular_ss220/clothing/icons/mob/eyes.dmi',
		"Skeleton" = 'modular_ss220/clothing/icons/mob/eyes.dmi',
		"Slime People" = 'modular_ss220/clothing/icons/mob/eyes.dmi',
		"Unathi" = 'modular_ss220/clothing/icons/mob/eyes.dmi',
		"Grey" = 'modular_ss220/clothing/icons/mob/species/grey/eyes.dmi',
		"Abductor" = 'modular_ss220/clothing/icons/mob/eyes.dmi',
		"Golem" = 'modular_ss220/clothing/icons/mob/eyes.dmi',
		"Machine" = 'modular_ss220/clothing/icons/mob/eyes.dmi',
		"Diona" = 'modular_ss220/clothing/icons/mob/eyes.dmi',
		"Nian" = 'modular_ss220/clothing/icons/mob/eyes.dmi',
		"Shadow" = 'modular_ss220/clothing/icons/mob/eyes.dmi',
		"Vox" = 'modular_ss220/clothing/icons/mob/species/vox/eyes.dmi',
		"Drask" = 'modular_ss220/clothing/icons/mob/species/drask/eyes.dmi',
	)
	prescription_upgradable = FALSE
	var/base_icon
	var/flipped = FALSE

/obj/item/clothing/glasses/hud/security/sunglasses/eyepatch/update_icon_state()
	if(..())
		item_state = "[replacetext("[item_state]", "_flipped", "")][flipped ? "_flipped" : ""]"

/obj/item/clothing/glasses/hud/security/sunglasses/eyepatch/attack_self__legacy__attackchain(mob/user)
	if(!base_icon)
		base_icon = icon_state

	flipped = !flipped
	to_chat(user, "You flip [src] [flipped ? "left" : "right"].")
	if(flipped)
		icon_state = "[base_icon]_flipped"
	else
		icon_state = "[base_icon]"

/datum/crafting_recipe/hudsunsecremoval
	blacklist = list(
		/obj/item/clothing/glasses/hud/security/sunglasses/eyepatch
	)
