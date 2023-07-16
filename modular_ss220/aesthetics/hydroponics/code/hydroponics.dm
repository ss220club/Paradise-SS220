/obj/machinery/plantgenes
	icon = 'modular_ss220/aesthetics/hydroponics/icons/hydroponics.dmi'

/obj/machinery/plantgenes/update_overlays()
	. = ..()
	if(disk)
		. += "dnamod-disk"

/obj/item/storage/bag/plants
	icon = 'modular_ss220/aesthetics/hydroponics/icons/hydroponics.dmi'

/obj/structure/loom
	icon = 'modular_ss220/aesthetics/hydroponics/icons/hydroponics.dmi'
