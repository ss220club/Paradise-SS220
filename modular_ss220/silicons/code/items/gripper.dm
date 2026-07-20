/obj/item/gripper/engineering/Initialize(mapload)
	can_hold |= list(
		/obj/item/flash,
	)
	return ..()

/obj/item/gripper/medical
	actions_types = list(/datum/action/item_action/drop_gripped_item)
	can_hold = list(
		/obj/item/organ,
		/obj/item/reagent_containers/iv_bag,
		/obj/item/robot_parts,
		/obj/item/stack/sheet/mineral/plasma, // For repair plasmemes
		/obj/item/mmi,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/patch,
		/obj/item/reagent_containers/drinks,
		/obj/item/reagent_containers/glass,
		/obj/item/reagent_containers/syringe,
	)

/obj/item/gripper/service/Initialize(mapload)
	can_hold |= list(
		/obj/item/card,
		/obj/item/camera_film,
		/obj/item/disk/data,
		/obj/item/disk/design_disk,
		/obj/item/disk/plantgene,
	)
	return ..()

/obj/structure/morgue/attack_ai(mob/user)
	add_hiddenprint(user)
	return attack_hand(user)
