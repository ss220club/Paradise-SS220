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

/obj/structure/closet/secure_closet/blueshield/populate_contents()
	new /obj/item/storage/backpack/blueshield(src)
	new /obj/item/storage/backpack/satchel_blueshield(src)
	new /obj/item/storage/briefcase(src)
	new /obj/item/storage/backpack/duffel/blueshield(src)
	new /obj/item/radio/headset/heads/blueshield/alt(src)
	new /obj/item/cartridge/hos(src)
	new	/obj/item/storage/firstaid/adv(src)
	new /obj/item/pinpointer/crew(src)
	new /obj/item/flashlight/seclite(src)
	new /obj/item/storage/belt/security/full(src)
	new /obj/item/clothing/accessory/holster(src)
	new /obj/item/storage/bag/garment/blueshield(src)
	new /obj/item/melee/electrostaff/loaded(src)
	new /obj/item/screwdriver(src)
