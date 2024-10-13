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
	var/dir = 1

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

	var/shift_x_head = 0
	var/shift_x_center_head = 0
	var/shift_y_head = 0
	var/shift_y_center_head = 0
	var/shift_x_side_head = 0
	var/shift_y_side_head = 0
	var/shift_x_front_head = 0
	var/shift_y_front_head = 0

/datum/component/mob_overlay_shift/Initialize(caller_mob, shift_xs_hand = 0, shift_ys_hand = 0, shift_xf_hand = 0, shift_yf_hand = 0, shift_x_hand = 0, shift_y_hand = 0, shift_xs_belt = 0, shift_ys_belt = 0, shift_xf_belt = 0, shift_yf_belt = 0, shift_x_belt = 0, shift_y_belt = 0, shift_xs_back = 0, shift_ys_back = 0, shift_xf_back = 0, shift_yf_back = 0, shift_x_back = 0, shift_y_back = 0, shift_xs_head = 0, shift_ys_head = 0, shift_xf_head = 0, shift_yf_head = 0, shift_x_head = 0, shift_y_head = 0)
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

	shift_x_center_head = shift_x_head
	shift_y_center_head = shift_y_head
	shift_x_side_head = shift_xs_head
	shift_y_side_head = shift_ys_head
	shift_x_front_head = shift_xf_head
	shift_y_front_head = shift_yf_head

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
	if (new_dir)
		dir = new_dir
	switch(dir)
		if(EAST)
			shift_x_inhand = shift_x_side_inhand + shift_x_center_inhand
			shift_y_inhand = shift_y_side_inhand + shift_y_center_inhand
			shift_x_belt = shift_x_side_belt + shift_x_center_belt
			shift_y_belt = shift_y_side_belt + shift_y_center_belt
			shift_x_back = shift_x_side_back + shift_x_center_back
			shift_y_back = shift_y_side_back + shift_y_center_back
			shift_x_head = shift_x_side_head + shift_x_center_head
			shift_y_head = shift_y_side_head + shift_y_center_head
		if(WEST)
			shift_x_inhand = -shift_x_side_inhand + shift_x_center_inhand
			shift_y_inhand = -shift_y_side_inhand + shift_y_center_inhand
			shift_x_belt = -shift_x_side_belt + shift_x_center_belt
			shift_y_belt = -shift_y_side_belt + shift_y_center_belt
			shift_x_back = -shift_x_side_back + shift_x_center_back
			shift_y_back = -shift_y_side_back + shift_y_center_back
			shift_x_head = -shift_x_side_head + shift_x_center_head
			shift_y_head = -shift_y_side_head + shift_y_center_head
		if(NORTH)
			shift_x_inhand = shift_x_front_inhand + shift_x_center_inhand
			shift_y_inhand = shift_y_front_inhand + shift_y_center_inhand
			shift_x_belt = shift_x_front_belt + shift_x_center_belt
			shift_y_belt = shift_y_front_belt + shift_y_center_belt
			shift_x_back = shift_x_front_back + shift_x_center_back
			shift_y_back = shift_y_front_back + shift_y_center_back
			shift_x_head = shift_x_front_head + shift_x_center_head
			shift_y_head = shift_y_front_head + shift_y_center_head
		if(SOUTH)
			shift_x_inhand = -shift_x_front_inhand + shift_x_center_inhand
			shift_y_inhand = -shift_y_front_inhand + shift_y_center_inhand
			shift_x_belt = -shift_x_front_belt + shift_x_center_belt
			shift_y_belt = -shift_y_front_belt + shift_y_center_belt
			shift_x_back = -shift_x_front_back + shift_x_center_back
			shift_y_back = -shift_y_front_back + shift_y_center_back
			shift_x_head = -shift_x_front_head + shift_x_center_head
			shift_y_head = -shift_y_front_head + shift_y_center_head
	update_call()

/datum/component/mob_overlay_shift/proc/update_call()
	update_inv_r_hand()
	update_inv_l_hand()
	update_inv_belt()
	update_inv_back()
	update_inv_head()
	update_inv_glasses()
	update_inv_ears()

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

/datum/component/mob_overlay_shift/proc/update_inv_head()
	mob.remove_overlay(HEAD_LAYER)
	if(mob.client && mob.hud_used)
		var/atom/movable/screen/inventory/inv = mob.hud_used.inv_slots[SLOT_HUD_HEAD]
		if(inv)
			inv.update_icon()

	if(mob.head)
		mob.update_hud_head(mob.head)
		var/mutable_appearance/standing
		if(mob.head.sprite_sheets && mob.head.sprite_sheets[mob.dna.species.sprite_sheet_name])
			standing = mutable_appearance(mob.head.sprite_sheets[mob.dna.species.sprite_sheet_name], "[mob.head.icon_state]", layer = -HEAD_LAYER)
			if(istype(mob.head, /obj/item/clothing/head/helmet/space/plasmaman))
				var/obj/item/clothing/head/helmet/space/plasmaman/P = mob.head
				if(!P.up)
					standing.overlays += P.visor_icon
		else if(mob.head.icon_override)
			standing = mutable_appearance(mob.head.icon_override, "[mob.head.icon_state]", layer = -HEAD_LAYER)
		else
			standing = mutable_appearance('icons/mob/clothing/head.dmi', "[mob.head.icon_state]", layer = -HEAD_LAYER)

		if(mob.head.blood_DNA)
			var/image/bloodsies = image("icon" = mob.dna.species.blood_mask, "icon_state" = "helmetblood")
			bloodsies.color = mob.head.blood_color
			standing.overlays += bloodsies
		standing.alpha = mob.head.alpha
		standing.color = mob.head.color
		standing.pixel_x = shift_x_head
		standing.pixel_y = shift_y_head
		mob.overlays_standing[HEAD_LAYER] = standing
	mob.apply_overlay(HEAD_LAYER)

/datum/component/mob_overlay_shift/proc/update_inv_glasses()
	mob.remove_overlay(GLASSES_LAYER)
	mob.remove_overlay(GLASSES_OVER_LAYER)
	mob.remove_overlay(OVER_MASK_LAYER)

	if(mob.client && mob.hud_used)
		var/atom/movable/screen/inventory/inv = mob.hud_used.inv_slots[SLOT_HUD_GLASSES]
		if(inv)
			inv.update_icon()

	if(mob.glasses)
		var/mutable_appearance/new_glasses
		var/obj/item/organ/external/head/head_organ = mob.get_organ("head")
		mob.update_hud_glasses(mob.glasses)

		if(mob.glasses.icon_override)
			new_glasses = mutable_appearance(mob.glasses.icon_override, "[mob.glasses.icon_state]", layer = -GLASSES_LAYER)
		else if(mob.glasses.sprite_sheets && mob.glasses.sprite_sheets[head_organ.dna.species.sprite_sheet_name])
			new_glasses = mutable_appearance(mob.glasses.sprite_sheets[head_organ.dna.species.sprite_sheet_name], "[mob.glasses.icon_state]", layer = -GLASSES_LAYER)
		else
			new_glasses = mutable_appearance('icons/mob/clothing/eyes.dmi', "[mob.glasses.icon_state]", layer = -GLASSES_LAYER)

		new_glasses.pixel_x = shift_x_head
		new_glasses.pixel_y = shift_y_head

		var/datum/sprite_accessory/hair/hair_style = GLOB.hair_styles_full_list[head_organ.h_style]
		var/obj/item/clothing/glasses/G = mob.glasses
		if(istype(G) && G.over_mask) //If the user's used the 'wear over mask' verb on the glasses.
			new_glasses.layer = -OVER_MASK_LAYER
			mob.overlays_standing[OVER_MASK_LAYER] = new_glasses
			mob.apply_overlay(OVER_MASK_LAYER)
		else if(hair_style && hair_style.glasses_over) //Select which layer to use based on the properties of the hair style. Hair styles with hair that don't overhang the arms of the glasses should have glasses_over set to a positive value.
			new_glasses.layer = -GLASSES_OVER_LAYER
			mob.overlays_standing[GLASSES_OVER_LAYER] = new_glasses
			mob.apply_overlay(GLASSES_OVER_LAYER)
		else
			mob.overlays_standing[GLASSES_LAYER] = new_glasses
			mob.apply_overlay(GLASSES_LAYER)

	mob.update_misc_effects()

/datum/component/mob_overlay_shift/proc/update_inv_ears()
	mob.remove_overlay(LEFT_EAR_LAYER)
	mob.remove_overlay(RIGHT_EAR_LAYER)

	if(mob.client && mob.hud_used)
		var/atom/movable/screen/inventory/left_ear_inv = mob.hud_used.inv_slots[SLOT_HUD_LEFT_EAR]
		var/atom/movable/screen/inventory/right_ear_inv = mob.hud_used.inv_slots[SLOT_HUD_RIGHT_EAR]
		if(left_ear_inv)
			left_ear_inv.update_icon()
		if(right_ear_inv)
			right_ear_inv.update_icon()

	if(mob.l_ear)
		mob.update_hud_l_ear(mob.l_ear)

		var/left_ear_item_state = mob.l_ear.item_state ? mob.l_ear.item_state : mob.l_ear.icon_state
		var/left_ear_icon = 'icons/mob/clothing/ears.dmi'
		if(mob.l_ear.sprite_sheets && mob.l_ear.sprite_sheets[mob.dna.species.sprite_sheet_name])
			left_ear_icon = mob.l_ear.sprite_sheets[mob.dna.species.sprite_sheet_name]
		if(mob.l_ear.icon_override)
			left_ear_item_state = "[left_ear_item_state]_l"
			left_ear_icon = mob.l_ear.icon_override

		var/mutable_appearance/standing = mutable_appearance(left_ear_icon, left_ear_item_state, layer = -LEFT_EAR_LAYER)
		standing.pixel_x = shift_x_head
		standing.pixel_y = shift_y_head
		mob.overlays_standing[LEFT_EAR_LAYER] = standing

	if(mob.r_ear)
		mob.update_hud_r_ear(mob.r_ear)

		var/right_ear_item_state = mob.r_ear.item_state ? mob.r_ear.item_state : mob.r_ear.icon_state
		var/right_ear_icon = 'icons/mob/clothing/ears.dmi'
		if(mob.r_ear.sprite_sheets && mob.r_ear.sprite_sheets[mob.dna.species.sprite_sheet_name])
			right_ear_icon = mob.r_ear.sprite_sheets[mob.dna.species.sprite_sheet_name]
		if(mob.r_ear.icon_override)
			right_ear_icon = "[right_ear_item_state]_l"
			right_ear_icon = mob.r_ear.icon_override

		var/mutable_appearance/standing = mutable_appearance(right_ear_icon, right_ear_item_state, layer = -RIGHT_EAR_LAYER)
		standing.pixel_x = shift_x_head
		standing.pixel_y = shift_y_head
		mob.overlays_standing[RIGHT_EAR_LAYER] = standing

	mob.apply_overlay(LEFT_EAR_LAYER)
	mob.apply_overlay(RIGHT_EAR_LAYER)

/mob/living/carbon/human/setDir(new_dir)
	. = ..()
	if(SEND_SIGNAL(src, COMSIG_MOB_OVERLAY_SHIFT_CHECK) & MOB_OVERLAY_SHIFT_CHECK)
		SEND_SIGNAL(src, COMSIG_MOB_OVERLAY_SHIFT_CALL, new_dir)

/mob/living/carbon/human/Life(seconds, times_fired)
	. = ..()
	if(SEND_SIGNAL(src, COMSIG_MOB_OVERLAY_SHIFT_CHECK) & MOB_OVERLAY_SHIFT_CHECK)
		SEND_SIGNAL(src, COMSIG_MOB_OVERLAY_SHIFT_CALL)
