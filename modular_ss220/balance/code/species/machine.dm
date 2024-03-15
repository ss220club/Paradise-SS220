/datum/species/machine
	speciesbox = /obj/item/storage/box/survival_ipc

// Survival box for IPC
/obj/item/storage/box/survival_ipc
	icon = 'modular_ss220/aesthetics/boxes/icons/boxes.dmi'
	icon_state = "machine_box"

/obj/item/storage/box/survival_ipc/populate_contents()
	new /obj/item/weldingtool(src)
	new /obj/item/stack/cable_coil/five(src)
	new /obj/item/flashlight/flare/glowstick/emergency(src)

/obj/machinery/recharger/attackby(obj/item/G, mob/user, params)
	if(istype(G, /obj/item/melee/baton/electrostaff))
		to_chat(user, "<span class='notice'>[G] не имеет внешних разъемов для подзарядки.</span>")
		return
	. = ..()

/obj/machinery/economy/vending/suitdispenser/Initialize(mapload)
	src.products += list(/obj/item/clothing/under/yellowgreen_skirt = 10,
						/obj/item/clothing/under/black_skirt = 10,
						/obj/item/clothing/under/aqua_skirt = 10,
						/obj/item/clothing/under/blue_skirt = 10,
						/obj/item/clothing/under/brown_skirt = 10,
						/obj/item/clothing/under/darkblue_skirt = 10,
						/obj/item/clothing/under/darkred_skirt = 10,
						/obj/item/clothing/under/green_skirt = 10,
						/obj/item/clothing/under/grey_skirt = 10,
						/obj/item/clothing/under/lightblue_skirt = 10,
						/obj/item/clothing/under/lightbrown_skirt = 10,
						/obj/item/clothing/under/lightgreen_skirt = 10,
						/obj/item/clothing/under/lightpurple_skirt = 10,
						/obj/item/clothing/under/lightred_skirt = 10,
						/obj/item/clothing/under/orange_skirt = 10,
						/obj/item/clothing/under/pink_skirt = 10,
						/obj/item/clothing/under/purple_skirt = 10,
						/obj/item/clothing/under/red_skirt = 10,
						/obj/item/clothing/under/white_skirt = 10,
						/obj/item/clothing/under/yellow_skirt = 10,
						/obj/item/clothing/under/prisoner_skirt = 1,
						/obj/item/clothing/under/rainbow_skirt = 1)
	src.prices += list(/obj/item/clothing/under/yellowgreen_skirt = 10,
						/obj/item/clothing/under/aqua_skirt = 50,
						/obj/item/clothing/under/black_skirt = 30,
						/obj/item/clothing/under/blue_skirt = 50,
						/obj/item/clothing/under/brown_skirt = 30,
						/obj/item/clothing/under/darkblue_skirt = 50,
						/obj/item/clothing/under/darkred_skirt = 50,
						/obj/item/clothing/under/green_skirt = 50,
						/obj/item/clothing/under/grey_skirt = 30,
						/obj/item/clothing/under/lightblue_skirt = 50,
						/obj/item/clothing/under/lightbrown_skirt = 30,
						/obj/item/clothing/under/lightgreen_skirt = 50,
						/obj/item/clothing/under/lightpurple_skirt = 50,
						/obj/item/clothing/under/lightred_skirt = 50,
						/obj/item/clothing/under/orange_skirt = 50,
						/obj/item/clothing/under/pink_skirt = 50,
						/obj/item/clothing/under/purple_skirt = 50,
						/obj/item/clothing/under/red_skirt = 50,
						/obj/item/clothing/under/white_skirt = 50,
						/obj/item/clothing/under/yellow_skirt = 50,
						/obj/item/clothing/under/prisoner_skirt = 175,
						/obj/item/clothing/under/rainbow_skirt = 100)
	. = ..()

