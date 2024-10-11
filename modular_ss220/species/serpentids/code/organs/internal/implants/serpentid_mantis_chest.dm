//===Клинки через грудной имплант===
/obj/item/organ/internal/cyberimp/chest/serpentid_blades
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
	var/blades_active = FALSE
	unremovable = TRUE
	emp_proof = TRUE

/datum/action/item_action/organ_action/toggle/switch_blades
	name = "Switch Threat Mode"
	desc = "Switch your stance to show other your intentions"
	button_overlay_icon = 'modular_ss220/species/serpentids/icons/organs.dmi'
	button_overlay_icon_state = "gas_hand_act"

/obj/item/organ/internal/cyberimp/chest/serpentid_blades/insert(mob/living/carbon/M, special, dont_remove_slot)
	. = .. ()
	if(owner && owner.real_name != "unknown")
		owner.update_body()
	else
		spawn(1)
			if(owner && owner.real_name != "unknown")
				owner.update_body()

/obj/item/organ/internal/cyberimp/chest/serpentid_blades/remove(mob/living/carbon/M, special, dont_remove_slot)
	if(owner && owner.real_name != "unknown")
		owner.update_body()
	else
		spawn(1)
			if(owner && owner.real_name != "unknown")
				owner.update_body()
	. = .. ()

/mob/living/carbon/human/proc/update_blades_overlays()
	var/obj/item/organ/internal/cyberimp/chest/serpentid_blades/target_implant = get_int_organ(/obj/item/organ/internal/cyberimp/chest/serpentid_blades)
	if(target_implant)
		target_implant.update_overlays()

/mob/living/carbon/human/update_body(rebuild_base = FALSE)
	. = .. ()
	update_blades_overlays()

/obj/item/organ/internal/cyberimp/chest/serpentid_blades/ui_action_click()
	if(crit_fail || (!holder_l && !length(contents)) && (!holder_r && !length(contents)))
		to_chat(owner, "<span class='warning'>The implant doesn't respond. It seems to be broken...</span>")
		return
	var/extended = holder_l && !(holder_l in src) && holder_r && !(holder_r in src)
	if(extended)
		Retract()
	else if(do_after(owner, 20*(owner.dna.species.action_mult), FALSE, owner))
		holder_l = null
		holder_r = null
		Extend(contents[1],contents[2])

/obj/item/organ/internal/cyberimp/chest/serpentid_blades/update_overlays()
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

/obj/item/organ/internal/cyberimp/chest/serpentid_blades/proc/Extend(obj/item/item_l, obj/item/item_r)
	if(!(item_l in src) && !(item_r in src))
		return
	if(status & ORGAN_DEAD)
		return

	blades_active = TRUE
	playsound(get_turf(owner), 'sound/mecha/mechmove03.ogg', 50, 1)
	new_icon_state = "blades_1"
	owner.update_body()
	return TRUE

/obj/item/organ/internal/cyberimp/chest/serpentid_blades/proc/Retract()
	if((!holder_l || (holder_l in src)) && (!holder_r || (holder_r in src)))
		return
	if(status & ORGAN_DEAD)
		return

	blades_active = FALSE
	playsound(get_turf(owner), 'sound/mecha/mechmove03.ogg', 50, 1)
	new_icon_state = "blades_0"
	owner.update_body()

//Проки на обработку при поднятом клинке
/datum/species/spec_attack_hand(mob/living/carbon/human/M, mob/living/carbon/human/H, datum/martial_art/attacker_style) //Handles any species-specific attackhand events.
	if(!istype(M))
		return

	if(istype(M))
		var/obj/item/organ/external/temp = M.bodyparts_by_name["r_hand"]
		if(M.hand)
			temp = M.bodyparts_by_name["l_hand"]
		if(!temp || !temp.is_usable())
			to_chat(M, "<span class='warning'>You can't use your hand.</span>")
			return

	if(M.mind)
		attacker_style = M.mind.martial_art

	if((M != H) && M.a_intent != INTENT_HELP && H.check_shields(M, 0, M.name, attack_type = UNARMED_ATTACK))
		add_attack_logs(M, H, "Melee attacked with blades (miss/block)")
		H.visible_message("<span class='warning'>[M] attempted to touch [H]!</span>")
		return FALSE

	switch(M.a_intent)
		if(INTENT_HELP)
			help(M, H, attacker_style)

		if(INTENT_GRAB)
			grab(M, H, attacker_style)

		if(INTENT_HARM)
			harm(M, H, attacker_style)

		if(INTENT_DISARM)
			disarm(M, H, attacker_style)

//Модификация граба для хвата из стелса
/datum/species/grab(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	. = .. ()
	var/obj/item/grab/grab_item = user.get_active_hand()
	var/limb_name = (user.l_hand == grab_item ? "l_hand" : "r_hand")
	var/obj/item/organ/external/hand/active_hand = user.get_limb_by_name(limb_name)
	if(istype(active_hand, /obj/item/organ/external/hand/carapace) || istype(active_hand, /obj/item/organ/external/hand/right/carapace))
		if(user.invisibility == INVISIBILITY_LEVEL_TWO)
			grab_item.state = GRAB_AGGRESSIVE
			grab_item.icon_state = "grabbed1"
			user.reset_visibility()
