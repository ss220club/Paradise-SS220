/obj/structure/closet/cabinet
	icon = 'modular_ss220/aesthetics/closets/icons/closets.dmi'

/obj/structure/closet/secure_closet/detective
	icon = 'modular_ss220/aesthetics/closets/icons/closets.dmi'

/obj/structure/closet/secure_closet/bar
	icon = 'modular_ss220/aesthetics/closets/icons/closets.dmi'

/obj/structure/closet/secure_closet/personal/cabinet
	icon = 'modular_ss220/aesthetics/closets/icons/closets.dmi'

/obj/structure/closet/secure_closet/brigphysic
	name = "security medic's locker"
	req_access = list(ACCESS_SECURITY)
	icon_state = "sec"

/obj/structure/closet/secure_closet/brigphysic/populate_contents()
	if(prob(50))
		new /obj/item/storage/backpack/security(src)
	else
		new /obj/item/storage/backpack/satchel_sec(src)
	new /obj/item/radio/headset/headset_secmedical/alt(src)
	new /obj/item/radio/headset/headset_secmedical(src)
	new /obj/item/defibrillator/compact/loaded(src)
	new /obj/item/holosign_creator/security(src)
	new /obj/item/storage/box/gloves(src)
	new /obj/item/storage/box/masks(src)
	new /obj/item/storage/box/syringes(src)
	new /obj/item/storage/box/autoinjectors(src)
	new /obj/item/storage/box/bodybags(src)
	new /obj/item/clothing/glasses/hud/health/sunglasses(src)
	new /obj/item/flashlight/seclite(src)
	new /obj/item/clothing/gloves/color/latex(src)
	new /obj/item/clothing/gloves/color/latex/nitrile(src)
