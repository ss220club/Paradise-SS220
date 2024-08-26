/obj/structure/closet/secure_closet/expedition
	name = "expeditors locker"
	req_access = list(ACCESS_EXPEDITION)
	icon = 'modular_ss220/objects/icons/closets.dmi'
	icon_state = "explorer"
	icon_opened = "explorer_open"
	open_door_sprite = "explorer_door"

/obj/structure/closet/secure_closet/expedition/populate_contents()
	new /obj/item/gun/energy/laser/awaymission_aeg/rnd(src)
	new /obj/item/storage/firstaid/regular(src)
	new /obj/item/paper/pamphlet/gateway(src)

/obj/structure/closet/crate/freezer/organ
	name = "Organ Freezer"
	desc = "A freezer for keeping organs fresh."
	icon = 'modular_ss220/objects/icons/closets.dmi'
	icon_state = "organ_freezer"
	icon_opened = "organ_freezer_open"
	icon_closed = "organ_freezer"
	storage_capacity = 60

/obj/structure/closet/crate/freezer/organ/populate_contents()
	new /obj/item/reagent_containers/iv_bag/blood/OMinus(src)
	new /obj/item/reagent_containers/iv_bag/blood/OPlus(src)
	new /obj/item/reagent_containers/iv_bag/blood/AMinus(src)
	new /obj/item/reagent_containers/iv_bag/blood/APlus(src)
	new /obj/item/reagent_containers/iv_bag/blood/BMinus(src)
	new /obj/item/reagent_containers/iv_bag/blood/BPlus(src)
	new /obj/item/reagent_containers/iv_bag/blood/random(src)
	new /obj/item/reagent_containers/iv_bag/blood/random(src)
	new /obj/item/reagent_containers/iv_bag/blood/random(src)
	new /obj/item/reagent_containers/iv_bag/salglu(src)
	new /obj/item/reagent_containers/iv_bag/slime(src)
	new /obj/item/reagent_containers/iv_bag/blood/vox(src)

