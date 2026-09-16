/obj/machinery/nuclear_centrifuge/crowbar_act(mob/user, obj/item/I)
	if(!panel_open)
		return
	. = TRUE
	default_deconstruction_crowbar(user, I)

/obj/machinery/nuclear_centrifuge/wrench_act(mob/user, obj/item/I)
	if(default_unfasten_wrench(user, I, time = 1 SECONDS))
		return TRUE

/obj/machinery/nuclear_rod_fabricator
	anchored = TRUE


/obj/machinery/nuclear_rod_fabricator/wrench_act(mob/user, obj/item/I)
	if(default_unfasten_wrench(user, I, time = 1 SECONDS))
		return TRUE
