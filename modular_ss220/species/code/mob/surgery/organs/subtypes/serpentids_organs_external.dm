// ============ Органы внешние ============
///Руки - аналогичные богомолам имлпанты, но при изъятии сжирают по 10 стамины
/obj/item/organ/internal/cyberimp/arm/toolset/serpentblade
	name = "hidden blade implant"
	desc = "A blade designed to be hidden just beneath the skin. The brain is directly linked to this bad boy, allowing it to spring into action."
	contents = newlist(/obj/item/kitchen/knife/combat/serpentblade)
	action_icon = list(/datum/action/item_action/organ_action/toggle = 'icons/obj/items_cyborg.dmi')
	action_icon_state = list(/datum/action/item_action/organ_action/toggle = "knife")
	origin_tech = "biotech=6;"

/obj/item/organ/internal/cyberimp/arm/toolset/serpentblade/l
	parent_organ = "l_arm"
	slot = "l_arm_device"

/obj/item/organ/internal/cyberimp/arm/toolset/ui_action_click()
	. = ..()
	var/obj/item/organ/internal/cyberimp/arm/toolset/serpentblade/pair_implant = null
	var/list/organs = owner.internal_organs
	for(var/obj/item/organ/internal/O in organs)
		if (istype(O, /obj/item/organ/internal/cyberimp/arm/toolset/serpentblade) && src != O)
			pair_implant = O
	if (!isnull(pair_implant))
		if(!pair_implant.holder || (pair_implant.holder in src))
			pair_implant.holder = null
			pair_implant.Extend(pair_implant.contents[1])
		else
			pair_implant.Retract()

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
/obj/item/organ/external/chest/carapice
	encased = "chitin"
	min_broken_damage = 20
	carapice_limb = TRUE

/obj/item/organ/external/groin/carapice
	encased = "chitin"
	min_broken_damage = 20
	carapice_limb = TRUE

/obj/item/organ/external/head/carapice
	encased = "chitin"
	min_broken_damage = 20
	carapice_limb = TRUE

/obj/item/organ/external/arm/carapice
	encased = "chitin"
	min_broken_damage = 20
	carapice_limb = TRUE
	can_change_visual = TRUE
	alt_visual_icon = "l_arm_agressive"

/obj/item/organ/external/arm/right/carapice
	encased = "chitin"
	min_broken_damage = 20
	carapice_limb = TRUE
	can_change_visual = TRUE
	alt_visual_icon = "r_arm_agressive"

/obj/item/organ/external/leg/carapice
	encased = "chitin"
	min_broken_damage = 20
	carapice_limb = TRUE

/obj/item/organ/external/leg/right/carapice
	encased = "chitin"
	min_broken_damage = 20
	carapice_limb = TRUE

/obj/item/organ/external/hand/carapice
	encased = "chitin"
	min_broken_damage = 20
	carapice_limb = TRUE
	can_change_visual = TRUE
	alt_visual_icon = "l_arm_agressive"

/obj/item/organ/external/hand/right/carapice
	encased = "chitin"
	min_broken_damage = 20
	carapice_limb = TRUE
	can_change_visual = TRUE
	alt_visual_icon = "r_arm_agressive"

/obj/item/organ/external/foot/carapice
	encased = "chitin"
	min_broken_damage = 20
	carapice_limb = TRUE

/obj/item/organ/external/foot/right/carapice
	encased = "chitin"
	min_broken_damage = 20
	carapice_limb = TRUE
