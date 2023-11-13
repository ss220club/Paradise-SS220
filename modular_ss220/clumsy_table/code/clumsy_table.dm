/obj/structure/table/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/clumsy_climb, 15)

/obj/structure/do_climb(mob/living/user)
	. = ..()
	SEND_SIGNAL(src, COMSIG_CLIMBED_ON, user)
