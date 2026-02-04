/obj/item/clothing/glasses/hud/security/eyepatch
	name = "повязка на глаз с secHUD"
	desc = "Прототип повязки на глаз с интегрированным secHUD. От этого исполнения отказались в пользу более удобного и легковесного размещения в очках, однако на устройство все еще спрос среди ценителей. Данную повязку можно носить как на правом, так и на левом глазу."
	icon = 'modular_ss220/clothing/icons/object/eyes.dmi'
	icon_state = "hudpatch"
	worn_icon = 'modular_ss220/clothing/icons/mob/eyes.dmi'
	item_color = "hudpatch"
	prescription_upgradable = FALSE
	sprite_sheets = list(
		"Kidan" = 'modular_ss220/clothing/icons/mob/species/kidan/eyes.dmi',
		"Grey" = 'modular_ss220/clothing/icons/mob/species/grey/eyes.dmi',
		"Vox" = 'modular_ss220/clothing/icons/mob/species/vox/eyes.dmi',
		"Drask" = 'modular_ss220/clothing/icons/mob/species/drask/eyes.dmi',
	)
	var/flipped = FALSE

/obj/item/clothing/glasses/hud/security/eyepatch/update_icon_state()
	icon_state = flipped ? "[initial(icon_state)]_flipped" : initial(icon_state)

/obj/item/clothing/glasses/hud/security/eyepatch/attack_self__legacy__attackchain(mob/user)
	flipped = !flipped
	to_chat(user, "You flip [src] [flipped ? "left" : "right"].")
	update_icon(UPDATE_ICON_STATE)
