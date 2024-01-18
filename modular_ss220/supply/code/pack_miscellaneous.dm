/datum/supply_packs/misc/bigband/New()
	. = ..()

	contains |= /obj/machinery/jukebox/drum_red

/datum/supply_packs/misc/soundhand
	name = "Soundhand fan crate"
	contains = list(/obj/item/clothing/suit/soundhand_black_jacket,
					/obj/item/clothing/suit/soundhand_olive_jacket,
					/obj/item/clothing/suit/soundhand_brown_jacket)
	cost = 600
	containername = "soundhand fan crate"
