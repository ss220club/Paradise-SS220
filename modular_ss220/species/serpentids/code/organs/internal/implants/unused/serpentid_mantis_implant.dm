//===Клинки через грудной имплант===
/obj/item/organ/internal/cyberimp/chest/serpentid_blades_arms
	name = "neuronodule of blades"
	desc = "control organ of upper blades"
	icon_state = "chest_implant"
	parent_organ = "chest"
	actions_types = list(/datum/action/item_action/organ_action/toggle/switch_blades)
	contents = newlist(/obj/item/kitchen/knife/combat/serpentblade,/obj/item/kitchen/knife/combat/serpentblade)
	action_icon = list(/datum/action/item_action/organ_action/toggle/switch_blades = 'modular_ss220/species/serpentids/icons/organs.dmi')
	action_icon_state = list(/datum/action/item_action/organ_action/toggle/switch_blades = "gas_hand_act")
	var/obj/item/holder_l = null
	var/obj/item/holder_r = null
	var/icon_file = 'modular_ss220/species/serpentids/icons/mob/r_serpentid.dmi'
	var/new_icon_state = "blades_0"
	var/mutable_appearance/old_overlay
	var/mutable_appearance/new_overlay
	var/overlay_color
	emp_proof = TRUE

/datum/action/item_action/organ_action/toggle/switch_blades
	name = "Switch Threat Mode"
	desc = "Switch your stance to show other your intentions"
	button_overlay_icon = 'modular_ss220/species/serpentids/icons/organs.dmi'
	button_overlay_icon_state = "gas_hand_act"

/obj/item/organ/internal/cyberimp/chest/serpentid_blades_arms/insert(mob/living/carbon/M, special, dont_remove_slot)
	. = .. ()
	if(owner && owner.real_name != "unknown")
		owner.update_body()
	else
		spawn(1)
			if(owner && owner.real_name != "unknown")
				owner.update_body()

/obj/item/organ/internal/cyberimp/chest/serpentid_blades_arms/remove(mob/living/carbon/M, special, dont_remove_slot)
	if(owner && owner.real_name != "unknown")
		owner.update_body()
	else
		spawn(1)
			if(owner && owner.real_name != "unknown")
				owner.update_body()
	. = .. ()

/mob/living/carbon/human/proc/update_blades__arms_overlays()
	var/obj/item/organ/internal/cyberimp/chest/serpentid_blades_arms/target_implant = get_int_organ(/obj/item/organ/internal/cyberimp/chest/serpentid_blades_arms)
	if(target_implant)
		target_implant.update_icon(UPDATE_OVERLAYS)

/mob/living/carbon/human/update_body(rebuild_base = FALSE)
	. = .. ()
	update_blades__arms_overlays()

/obj/item/organ/internal/cyberimp/chest/serpentid_blades_arms/ui_action_click()
	if(crit_fail || (!holder_l && !length(contents)) && (!holder_r && !length(contents)))
		to_chat(owner, "<span class='warning'>The implant doesn't respond. It seems to be broken...</span>")
		return
	var/extended = holder_l && !(holder_l in src) && holder_r && !(holder_r in src)
	if(extended)
		Retract()
	else if(do_after(owner, 2 SECONDS * (owner.dna.species.action_mult), FALSE, owner))
		holder_l = null
		holder_r = null
		Extend(contents[1],contents[2])

/obj/item/organ/internal/cyberimp/chest/serpentid_blades_arms/update_overlays()
	. = .. ()
	if(old_overlay)
		owner.overlays -= old_overlay
	if(owner)
		var/icon/blades_icon = new/icon("icon" = icon_file, "icon_state" = new_icon_state)
		var/obj/item/organ/external/chest/torso = owner.get_limb_by_name("chest")
		var/body_color = torso.s_col
		blades_icon.Blend(body_color, ICON_ADD)
		new_overlay = mutable_appearance(blades_icon)
		old_overlay = new_overlay
		owner.overlays += new_overlay

/obj/item/organ/internal/cyberimp/chest/serpentid_blades_arms/proc/check_cuffs()
	if(owner.handcuffed)
		to_chat(owner, "<span class='warning'>The handcuffs interfere with [src]!</span>")
		return TRUE

/obj/item/organ/internal/cyberimp/chest/serpentid_blades_arms/proc/Extend(obj/item/item_l, obj/item/item_r)
	if(!(item_l in src) && !(item_r in src) && check_cuffs())
		return
	if(status & ORGAN_DEAD)
		return

	holder_l = item_l
	holder_r = item_r

	holder_l.flags |= NODROP
	holder_l.resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	holder_l.slot_flags = null
	holder_l.w_class = WEIGHT_CLASS_HUGE
	holder_l.materials = null

	holder_r.flags |= NODROP
	holder_r.resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	holder_r.slot_flags = null
	holder_r.w_class = WEIGHT_CLASS_HUGE
	holder_r.materials = null

	for(var/arm_slot in list(SLOT_HUD_RIGHT_HAND, SLOT_HUD_LEFT_HAND))
		var/obj/item/arm_item = owner.get_item_by_slot(arm_slot)

		if(arm_item)
			if(istype(arm_item, /obj/item/offhand))
				var/obj/item/offhand_arm_item = owner.get_active_hand()
				to_chat(owner, "<span class='warning'>Your hands are too encumbered wielding [offhand_arm_item] to deploy [src]!</span>")
				return
			else if(!owner.unEquip(arm_item))
				to_chat(owner, "<span class='warning'>Your [arm_item] interferes with [src]!</span>")
				return
			else
				to_chat(owner, "<span class='notice'>You drop [arm_item] to activate [src]!</span>")

	if(!owner.put_in_l_hand(holder_l))
		return
	if(!owner.put_in_r_hand(holder_r))
		return

	playsound(get_turf(owner), 'sound/mecha/mechmove03.ogg', 50, 1)
	new_icon_state = "blades_1"
	owner.update_body()
	return TRUE

/obj/item/organ/internal/cyberimp/chest/serpentid_blades_arms/proc/Retract()
	if((!holder_l || (holder_l in src)) && (!holder_r || (holder_r in src)))
		return
	if(status & ORGAN_DEAD)
		return

	owner.unEquip(holder_r, 1)
	owner.unEquip(holder_l, 1)
	holder_r.forceMove(src)
	holder_l.forceMove(src)
	holder_r = null
	holder_l = null
	playsound(get_turf(owner), 'sound/mecha/mechmove03.ogg', 50, 1)
	new_icon_state = "blades_0"
	owner.update_body()
//==Конец клинков через грудной имплант==
