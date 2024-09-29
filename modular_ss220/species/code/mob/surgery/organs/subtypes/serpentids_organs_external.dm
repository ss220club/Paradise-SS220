#define CARAPACE_BROKEN_STATE 20
#define CARAPACE_BASIC_BRUTE_RESISTANCE 0.8
#define CHEM_CARAPACE_HEAL_REAGENT_ID "synthflesh"
#define CHEM_CARAPACE_HEAL_REAGENT_COUNT 10
#define CHEM_CARAPACE_HEAL_REAGENT_PROB 50

/obj/item/organ/external

	var/can_change_visual = FALSE
	var/change_visual = FALSE
	var/alt_visual_icon = null

	var/carapace_limb = FALSE
	var/carapace_heal_reagent_id = CHEM_CARAPACE_HEAL_REAGENT_ID
	var/carapace_broken_treshold = CARAPACE_BROKEN_STATE
	var/carapace_brute_resistance = CARAPACE_BASIC_BRUTE_RESISTANCE

/obj/item/organ/external/proc/update_visual()
	if (can_change_visual && change_visual)
		icon_name = alt_visual_icon
	if (can_change_visual && !(change_visual))
		icon_name = initial(icon_name)
	owner.update_body()

/obj/item/organ/external/proc/update_resistance()
	if (status & ORGAN_BROKEN)
		brute_mod = (100 + get_damage())/100
	else
		brute_mod = carapace_brute_resistance
	burn_mod = brute_mod + 0.2

/obj/item/organ/external/receive_damage(brute, burn, sharp, used_weapon = null, list/forbidden_limbs = list(), ignore_resists = FALSE, updating_health = TRUE)
	. = ..()
	if (carapace_limb)
		if (get_damage() > carapace_broken_treshold)
			fracture()
		var/obj/item/organ/internal/O = pick(internal_organs)
		O.receive_damage(burn * get_damage())
		update_resistance()
	return

/obj/item/organ/external/heal_damage(brute, burn, internal = 0, robo_repair = 0, updating_health = TRUE)
	. = .. ()
	if ((status & ORGAN_BROKEN) && get_damage() < carapace_broken_treshold)
		for(var/datum/reagent/consumable/chemical in owner.reagents.reagent_list)
			if(istype(chemical, owner.get_chemical_path(carapace_heal_reagent_id)) && owner.get_chemical_value(carapace_heal_reagent_id) >= CHEM_CARAPACE_HEAL_REAGENT_COUNT)
				chemical.holder.remove_reagent(carapace_heal_reagent_id, CHEM_CARAPACE_HEAL_REAGENT_COUNT)
				if (prob(CHEM_CARAPACE_HEAL_REAGENT_PROB))
					mend_fracture()
	update_resistance()
	return

// ============ Органы внешние ============
///Руки - аналогичные богомолам имлпанты
/obj/item/organ/internal/cyberimp/arm/
	var/can_work_in_pair = FALSE
	var/state_active = FALSE

/obj/item/organ/internal/cyberimp/arm/toolset/serpentblade
	name = "hidden blade implant"
	desc = "A blade designed to be hidden just beneath the skin. The brain is directly linked to this bad boy, allowing it to spring into action."
	contents = newlist(/obj/item/kitchen/knife/combat/serpentblade)
	action_icon = list(/datum/action/item_action/organ_action/toggle = 'icons/obj/items_cyborg.dmi')
	action_icon_state = list(/datum/action/item_action/organ_action/toggle = "knife")
	origin_tech = "biotech=6;"
	can_work_in_pair = TRUE
	state_active = FALSE
	parent_organ = "r_hand"
	slot = "r_hand_device"
	emp_proof = TRUE

/obj/item/organ/internal/cyberimp/arm/toolset/serpentblade/l
	parent_organ = "l_hand"
	slot = "l_hand_device"

/obj/item/organ/internal/cyberimp/arm/toolset/serpentblade/l/on_life()
	. = ..()
	var/obj/item/organ/internal/cyberimp/arm/toolset/serpentblade/pair_implant = null
	var/list/organs = owner.internal_organs
	for(var/obj/item/organ/internal/O in organs)
		if (istype(O, /obj/item/organ/internal/cyberimp/arm/toolset/serpentblade) && src != O)
			pair_implant = O
	var/datum/action/action_candidate = src.actions[1]
	if (!isnull(pair_implant))
		if (action_candidate in owner.actions)
			action_candidate.Remove(owner)
	else
		if (!(action_candidate in owner.actions))
			action_candidate.Grant(owner)
	owner.update_action_buttons()

/obj/item/organ/internal/cyberimp/arm/proc/synchonize_implants()
	var/obj/item/organ/internal/cyberimp/arm/toolset/serpentblade/pair_implant = null
	var/list/organs = owner.internal_organs
	for(var/obj/item/organ/internal/O in organs)
		if (istype(O, /obj/item/organ/internal/cyberimp/arm) && istype(src, /obj/item/organ/internal/cyberimp/arm) && src != O)
			pair_implant = O
	if (!isnull(pair_implant))
		if (src.state_active != pair_implant.state_active)
			if(src.state_active)
				pair_implant.holder = null
				pair_implant.Extend(pair_implant.contents[1])
			else
				pair_implant.Retract()

/obj/item/organ/internal/cyberimp/arm/Retract()
	. = .. ()
	state_active = FALSE
	if (can_work_in_pair)
		synchonize_implants()

/obj/item/organ/internal/cyberimp/arm/Extend()
	. = .. ()
	state_active = TRUE
	if (can_work_in_pair)
		synchonize_implants()
//===Окончание первой вариации парных имплантов===
//===Клинки через грудной имплант===
/obj/item/organ/internal/cyberimp/chest/serpentid_blades
	name = "serpentid blade implant"
	desc = "implants for the organs in your torso."
	icon_state = "chest_implant"
	implant_overlay = "chest_implant_overlay"
	parent_organ = "chest"
	actions_types = list(/datum/action/item_action/organ_action/toggle/switch_blades)
	contents = newlist(/obj/item/kitchen/knife/combat/serpentblade,/obj/item/kitchen/knife/combat/serpentblade)
	action_icon = list(/datum/action/item_action/organ_action/toggle = 'icons/obj/items_cyborg.dmi')
	action_icon_state = list(/datum/action/item_action/organ_action/toggle = "knife")
	var/obj/item/holder_l = null
	var/obj/item/holder_r = null
	emp_proof = TRUE

/datum/action/item_action/organ_action/toggle/switch_blades
	name = "Switch Threat Mode"
	desc = "Switch your stance to show other your intentions"
	button_overlay_icon = 'icons/obj/items_cyborg.dmi'
	button_overlay_icon_state = "knife"

/obj/item/organ/internal/cyberimp/chest/serpentid_blades/ui_action_click()
	if(crit_fail || (!holder_l && !length(contents)) && (!holder_r && !length(contents)))
		to_chat(owner, "<span class='warning'>The implant doesn't respond. It seems to be broken...</span>")
		return
	if(do_after(owner, 20))
		if(holder_l && !(holder_l in src) && holder_r && !(holder_r in src))
			Retract()
		else
			holder_l = null
			holder_r = null
			Extend(contents[1],contents[2])

/obj/item/organ/internal/cyberimp/chest/serpentid_blades/proc/check_cuffs()
	if(owner.handcuffed)
		to_chat(owner, "<span class='warning'>The handcuffs interfere with [src]!</span>")
		return TRUE

/obj/item/organ/internal/cyberimp/chest/serpentid_blades/proc/Extend(obj/item/item_l, obj/item/item_r)
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
	return TRUE

/obj/item/organ/internal/cyberimp/chest/serpentid_blades/proc/Retract()
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
//==Конец клинков через грудной имплант==


/obj/item/kitchen/knife/combat/serpentblade
	name = "serpentid mantis blade"
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "knife"
	lefthand_file = null
	righthand_file = null
	desc = "Biological melee weapon. Sharp and durable. It can cut off some heads, or maybe not..."
	origin_tech = null
	force = 7
	armour_penetration_flat = 3
	var/attack_in_progress = FALSE
	tool_behaviour = TOOL_SAW

/obj/item/kitchen/knife/combat/serpentblade/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_ADVANCED_SURGICAL, ROUNDSTART_TRAIT)
	ADD_TRAIT(src, TRAIT_FORCES_OPEN_DOORS_ITEM, ROUNDSTART_TRAIT)
	AddComponent(/datum/component/parry, _stamina_constant = 2, _stamina_coefficient = 0.5, _parryable_attack_types = NON_PROJECTILE_ATTACKS)

/obj/item/melee/serpentblade/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(attack_type == PROJECTILE_ATTACK)
		final_block_chance = 0
	return ..()

/obj/item/kitchen/knife/combat/serpentblade/attack(mob/living/target, mob/living/user, params, def_zone, skip_attack_anim = FALSE)
	. = ..()
	if(attack_in_progress)
		return TRUE
	var/obj/item/kitchen/knife/combat/serpentblade/offhand_blade = user.get_inactive_hand()
	addtimer(CALLBACK(offhand_blade, PROC_REF(offhand_attack), target, user, params, def_zone), 0.2 SECONDS)

/obj/item/kitchen/knife/combat/serpentblade/proc/offhand_attack(mob/living/target, mob/living/user, params, def_zone)
	if(QDELETED(src) || QDELETED(target) || user != src.loc  || !user.Adjacent(target))
		return
	attack_in_progress = TRUE
	attack(target, user, params, def_zone)
	attack_in_progress = FALSE

///Хитиновые конечности
/obj/item/organ/external/chest/carapace
	encased = "chitin"
	min_broken_damage = 20
	carapace_limb = TRUE

/obj/item/organ/external/groin/carapace
	encased = "chitin"
	min_broken_damage = 20
	carapace_limb = TRUE

/obj/item/organ/external/head/carapace
	encased = "chitin"
	min_broken_damage = 20
	carapace_limb = TRUE

/obj/item/organ/external/arm/carapace
	encased = "chitin"
	min_broken_damage = 20
	carapace_limb = TRUE
	can_change_visual = TRUE
	alt_visual_icon = "l_arm_agressive"

/obj/item/organ/external/arm/right/carapace
	encased = "chitin"
	min_broken_damage = 20
	carapace_limb = TRUE
	can_change_visual = TRUE
	alt_visual_icon = "r_arm_agressive"

/obj/item/organ/external/leg/carapace
	encased = "chitin"
	min_broken_damage = 20
	carapace_limb = TRUE

/obj/item/organ/external/leg/right/carapace
	encased = "chitin"
	min_broken_damage = 20
	carapace_limb = TRUE

/obj/item/organ/external/hand/carapace
	encased = "chitin"
	min_broken_damage = 20
	carapace_limb = TRUE
	can_change_visual = TRUE
	alt_visual_icon = "l_arm_agressive"

/obj/item/organ/external/hand/right/carapace
	encased = "chitin"
	min_broken_damage = 20
	carapace_limb = TRUE
	can_change_visual = TRUE
	alt_visual_icon = "r_arm_agressive"

/obj/item/organ/external/foot/carapace
	encased = "chitin"
	min_broken_damage = 20
	carapace_limb = TRUE

/obj/item/organ/external/foot/right/carapace
	encased = "chitin"
	min_broken_damage = 20
	carapace_limb = TRUE
