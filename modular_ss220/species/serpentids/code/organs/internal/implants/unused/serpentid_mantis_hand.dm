/obj/item/organ/internal/cyberimp/arm/toolset/mantisblade
	name = "mantis blade implant right"
	desc = "A blade designed to be hidden just beneath the skin. The brain is directly linked to this bad boy, allowing it to spring into action."
	contents = newlist(/obj/item/kitchen/knife/combat/cyborg)
	action_icon = list(/datum/action/item_action/organ_action/toggle = 'icons/obj/items_cyborg.dmi')
	action_icon_state = list(/datum/action/item_action/organ_action/toggle = "knife")
	origin_tech = "biotech=6;"
	var/can_work_in_pair = TRUE
	var/state_active = FALSE
	parent_organ = "r_arm"
	slot = "r_arm_device"
	emp_proof = TRUE

/obj/item/organ/internal/cyberimp/arm/toolset/mantisblade/l
	name = "mantis blade implant left"
	parent_organ = "l_arm"
	slot = "l_arm_device"

/obj/item/organ/internal/cyberimp/arm/toolset/mantisblade/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/paired_implants, src)
