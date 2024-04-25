/obj/item/storage/box/mre
	name = "сухпаёк"
	desc = "Коробка с сухпайком внутри, объеденье!"
	icon = 'modular_ss220/objects/icons/mre.dmi'
	icon_state = "mre_box"

/obj/item/storage/box/mre/populate_contents()
	. = ..()
	new /obj/item/food/snacks/mre/steak(src)
	new /obj/item/food/snacks/mre/steak(src)


