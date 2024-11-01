/obj/machinery/economy/vending/medidrobe/Initialize(mapload)
	products += list(
		/obj/item/clothing/under/rank/medical/paramedic/suit = 2,
		/obj/item/clothing/head/beret/paramedic = 2,
		/obj/item/storage/belt/medical/medicalwebbing = 2,
		)
	prices += list(
		/obj/item/clothing/under/rank/medical/paramedic/suit = 50,
		/obj/item/clothing/head/beret/paramedic = 50,
		/obj/item/storage/belt/medical/medicalwebbing = 75,
		)
	. = ..()
