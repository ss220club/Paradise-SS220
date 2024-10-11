/*
===Модуль сдвига оверлея
Компонент должен цепляться на моба.
При инициализации предаются сдвиги.
*/
//Базовый трешхолд урона, при достижение или выше которого будет слом.
#define COMSIG_MOB_OVERLAY_SHIFT_CALL "shift_call"
#define COMSIG_MOB_OVERLAY_SHIFT_UPDATE "update_call"
#define COMSIG_MOB_OVERLAY_SHIFT_CHECK "module_available"
	#define MOB_OVERLAY_SHIFT_CHECK (1<<0)

/datum/component/mob_overlay_shift
	var/mob/living/carbon/human/mob
	var/shift_x_inhand = 0
	var/shift_x_center_inhand = 0
	var/shift_y_inhand = 0
	var/shift_y_center_inhand = 0
	var/shift_x_side_inhand = 0
	var/shift_y_side_inhand = 0
	var/shift_x_front_inhand = 0
	var/shift_y_front_inhand = 0

	var/shift_x_belt = 0
	var/shift_x_center_belt = 0
	var/shift_y_belt = 0
	var/shift_y_center_belt = 0
	var/shift_x_side_belt = 0
	var/shift_y_side_belt = 0
	var/shift_x_front_belt = 0
	var/shift_y_front_belt = 0

	var/shift_x_back = 0
	var/shift_x_center_back = 0
	var/shift_y_back = 0
	var/shift_y_center_back = 0
	var/shift_x_side_back = 0
	var/shift_y_side_back = 0
	var/shift_x_front_back = 0
	var/shift_y_front_back = 0

/datum/component/mob_overlay_shift/Initialize(var/caller_mob, var/shift_xs_hand = 0, var/shift_ys_hand = 0, var/shift_xf_hand = 0, var/shift_yf_hand = 0, var/shift_x_hand = 0, var/shift_y_hand = 0, var/shift_xs_belt = 0, var/shift_ys_belt = 0, var/shift_xf_belt = 0, var/shift_yf_belt = 0, var/shift_x_belt = 0, var/shift_y_belt = 0, var/shift_xs_back = 0, var/shift_ys_back = 0, var/shift_xf_back = 0, var/shift_yf_back = 0, var/shift_x_back = 0, var/shift_y_back = 0)
	..()
	mob = parent

	shift_x_center_inhand = shift_x_hand
	shift_y_center_inhand = shift_y_hand
	shift_x_side_inhand = shift_xs_hand
	shift_y_side_inhand = shift_ys_hand
	shift_x_front_inhand = shift_xf_hand
	shift_y_front_inhand = shift_yf_hand

	shift_x_center_belt = shift_x_belt
	shift_y_center_belt = shift_y_belt
	shift_x_side_belt = shift_xs_belt
	shift_y_side_belt = shift_ys_belt
	shift_x_front_belt = shift_xf_belt
	shift_y_front_belt = shift_yf_belt

	shift_x_center_back = shift_x_back
	shift_y_center_back = shift_y_back
	shift_x_side_back = shift_xs_back
	shift_y_side_back = shift_ys_back
	shift_x_front_back = shift_xf_back
	shift_y_front_back = shift_yf_back

/datum/component/mob_overlay_shift/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOB_OVERLAY_SHIFT_CALL, PROC_REF(shift_call))
	RegisterSignal(parent, COMSIG_MOB_OVERLAY_SHIFT_CHECK, PROC_REF(module_available))
	RegisterSignal(parent, COMSIG_MOB_OVERLAY_SHIFT_UPDATE, PROC_REF(update_call))

/datum/component/mob_overlay_shift/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MOB_OVERLAY_SHIFT_CALL)
	UnregisterSignal(parent, COMSIG_MOB_OVERLAY_SHIFT_CHECK)
	UnregisterSignal(parent, COMSIG_MOB_OVERLAY_SHIFT_UPDATE)

/datum/component/mob_overlay_shift/proc/module_available()
	SIGNAL_HANDLER
	return MOB_OVERLAY_SHIFT_CHECK

//Проки, срабатываемые при получении или исцелении урона
/datum/component/mob_overlay_shift/proc/shift_call(mob, new_dir)
	switch(new_dir)
		if(EAST)
			shift_x_inhand = shift_x_side_inhand + shift_x_center_inhand
			shift_y_inhand = shift_y_side_inhand + shift_y_center_inhand
			shift_x_belt = shift_x_side_belt + shift_x_center_belt
			shift_y_belt = shift_y_side_belt + shift_y_center_belt
			shift_x_back = shift_x_side_back + shift_x_center_back
			shift_y_back = shift_y_side_back + shift_y_center_back
		if(WEST)
			shift_x_inhand = -shift_x_side_inhand + shift_x_center_inhand
			shift_y_inhand = -shift_y_side_inhand + shift_y_center_inhand
			shift_x_belt = -shift_x_side_belt + shift_x_center_belt
			shift_y_belt = -shift_y_side_belt + shift_y_center_belt
			shift_x_back = -shift_x_side_back + shift_x_center_back
			shift_y_back = -shift_y_side_back + shift_y_center_back
		if(NORTH)
			shift_x_inhand = shift_x_front_inhand + shift_x_center_inhand
			shift_y_inhand = shift_y_front_inhand + shift_y_center_inhand
			shift_x_belt = shift_x_front_belt + shift_x_center_belt
			shift_y_belt = shift_y_front_belt + shift_y_center_belt
			shift_x_back = shift_x_front_back + shift_x_center_back
			shift_y_back = shift_y_front_back + shift_y_center_back
		if(SOUTH)
			shift_x_inhand = -shift_x_front_inhand + shift_x_center_inhand
			shift_y_inhand = -shift_y_front_inhand + shift_y_center_inhand
			shift_x_belt = -shift_x_front_belt + shift_x_center_belt
			shift_y_belt = -shift_y_front_belt + shift_y_center_belt
			shift_x_back = -shift_x_front_back + shift_x_center_back
			shift_y_back = -shift_y_front_back + shift_y_center_back
	update_call()

/datum/component/mob_overlay_shift/proc/update_call()
	update_inv_r_hand()
	update_inv_l_hand()
	update_inv_belt()
	update_inv_back()

/datum/component/mob_overlay_shift/proc/update_inv_belt()
	mob.remove_overlay(BELT_LAYER)
	mob.remove_overlay(SPECIAL_BELT_LAYER)
	var/overlay_layer = BELT_LAYER

	if(mob.client && mob.hud_used)
		var/atom/movable/screen/inventory/inv = mob.hud_used.inv_slots[SLOT_HUD_BELT]
		if(inv)
			inv.update_icon()

		if(mob.hud_used.hud_version == HUD_STYLE_STANDARD && mob.belt)
			mob.client.screen += mob.belt
			mob.belt.screen_loc = ui_belt

	if(mob.belt)
		// Manual checks for outliers (Claymores, null rods, defibs, judobelt, etc.) - Items that are belts but not storages.
		var/list/special_belts = list(
			/obj/item/defibrillator/compact,
			/obj/item/nullrod,
			/obj/item/storage/belt/judobelt,
			/obj/item/claymore)
		overlay_layer = is_type_in_list(mob.belt, special_belts) ? SPECIAL_BELT_LAYER : BELT_LAYER
		if(istype(mob.belt, /obj/item/storage/belt))
			var/obj/item/storage/belt/B = mob.belt
			overlay_layer = B.layer_over_suit ? SPECIAL_BELT_LAYER : BELT_LAYER

		var/t_state = mob.belt.item_state
		mob.update_observer_view(mob.belt)
		if(!t_state)
			t_state = mob.belt.icon_state

		var/mutable_appearance/standing
		if(mob.belt.icon_override)
			t_state = "[t_state]_be"
			standing = mutable_appearance(mob.belt.icon_override, "[t_state]", layer = -overlay_layer)
		else if(mob.belt.sprite_sheets && mob.belt.sprite_sheets[mob.dna.species.sprite_sheet_name])
			standing = mutable_appearance(mob.belt.sprite_sheets[mob.dna.species.sprite_sheet_name], "[t_state]", layer = -overlay_layer)
		else
			standing = mutable_appearance('icons/mob/clothing/belt.dmi', "[t_state]", layer = -overlay_layer)
		standing.pixel_x = shift_x_belt
		standing.pixel_y = shift_y_belt
		mob.overlays_standing[overlay_layer] = standing
	mob.apply_overlay(BELT_LAYER)
	mob.apply_overlay(SPECIAL_BELT_LAYER)

/datum/component/mob_overlay_shift/proc/update_inv_back()
	mob.remove_overlay(BACK_LAYER)
	if(mob.back)
		mob.update_hud_back(mob.back)
		//determine the icon to use
		var/t_state = mob.back.item_state
		if(!t_state)
			t_state = mob.back.icon_state
		var/mutable_appearance/standing
		if(mob.back.icon_override)
			standing = mutable_appearance(mob.back.icon_override, "[mob.back.icon_state]", layer = -BACK_LAYER)
		else if(mob.back.sprite_sheets && mob.back.sprite_sheets[mob.dna.species.sprite_sheet_name])
			standing = mutable_appearance(mob.back.sprite_sheets[mob.dna.species.sprite_sheet_name], "[t_state]", layer = -BACK_LAYER)
		else
			standing = mutable_appearance('icons/mob/clothing/back.dmi', "[t_state]", layer = -BACK_LAYER)

		//create the image
		standing.alpha = mob.back.alpha
		standing.color = mob.back.color
		standing.pixel_x = shift_x_back
		standing.pixel_y = shift_y_back
		mob.overlays_standing[BACK_LAYER] = standing
	mob.apply_overlay(BACK_LAYER)

/datum/component/mob_overlay_shift/proc/update_inv_r_hand()
	mob.remove_overlay(R_HAND_LAYER)
	if(mob.r_hand)
		mob.show_hand_to_observers(mob.r_hand, left = FALSE)
		var/t_state = mob.r_hand.item_state
		if(!t_state)
			t_state = mob.r_hand.icon_state

		var/mutable_appearance/standing
		if(mob.r_hand.sprite_sheets_inhand && mob.r_hand.sprite_sheets_inhand[mob.dna.species.sprite_sheet_name])
			t_state = "[t_state]_r"
			standing = mutable_appearance(mob.r_hand.sprite_sheets_inhand[mob.dna.species.sprite_sheet_name], "[t_state]", layer = -R_HAND_LAYER, color = mob.r_hand.color)
		else
			standing = mutable_appearance(mob.r_hand.righthand_file, "[t_state]", layer = -R_HAND_LAYER, color = mob.r_hand.color)
			standing = center_image(standing, (mob.r_hand.inhand_x_dimension), (mob.r_hand.inhand_y_dimension))
			standing.pixel_x = shift_x_inhand
			standing.pixel_y = shift_y_inhand
		mob.overlays_standing[R_HAND_LAYER] = standing
	mob.apply_overlay(R_HAND_LAYER)


/datum/component/mob_overlay_shift/proc/update_inv_l_hand()
	mob.remove_overlay(L_HAND_LAYER)
	if(mob.l_hand)
		mob.show_hand_to_observers(mob.l_hand, left = TRUE)
		var/t_state = mob.l_hand.item_state
		if(!t_state)
			t_state = mob.l_hand.icon_state

		var/mutable_appearance/standing
		if(mob.l_hand.sprite_sheets_inhand && mob.l_hand.sprite_sheets_inhand[mob.dna.species.sprite_sheet_name])
			t_state = "[t_state]_l"
			standing = mutable_appearance(mob.l_hand.sprite_sheets_inhand[mob.dna.species.sprite_sheet_name], "[t_state]", layer = -L_HAND_LAYER, color = mob.l_hand.color)
		else
			standing = mutable_appearance(mob.l_hand.lefthand_file, "[t_state]", layer = -L_HAND_LAYER, color = mob.l_hand.color)
			standing = center_image(standing, mob.l_hand.inhand_x_dimension, mob.l_hand.inhand_y_dimension)
			standing.pixel_x = shift_x_inhand
			standing.pixel_y = shift_y_inhand
		mob.overlays_standing[L_HAND_LAYER] = standing
	mob.apply_overlay(L_HAND_LAYER)

/mob/living/carbon/human/setDir(new_dir)
	. = ..()
	if(SEND_SIGNAL(src, COMSIG_MOB_OVERLAY_SHIFT_CHECK) & MOB_OVERLAY_SHIFT_CHECK)
		SEND_SIGNAL(src, COMSIG_MOB_OVERLAY_SHIFT_CALL, new_dir)
