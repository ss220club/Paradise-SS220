// ============ Органы внешние ============
/obj/item/kitchen/knife/combat/serpentblade
	name = "serpentid mantis blade"
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "knife"
	lefthand_file = null
	righthand_file = null
	desc = "Biological melee weapon. Sharp and durable. It can cut off some heads, or maybe not..."
	origin_tech = null
	force = 11
	armour_penetration_flat = 3
	tool_behaviour = TOOL_SAW
	var/stamina_constant = 2
	var/stamina_coefficient = 0.5

/obj/item/kitchen/knife/combat/serpentblade/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_ADVANCED_SURGICAL, ROUNDSTART_TRAIT)
	ADD_TRAIT(src, TRAIT_FORCES_OPEN_DOORS_ITEM, ROUNDSTART_TRAIT)
	AddComponent(/datum/component/parry, _stamina_constant = stamina_constant, _stamina_coefficient = stamina_coefficient, _parryable_attack_types = NON_PROJECTILE_ATTACKS)
	AddComponent(/datum/component/double_attack)
