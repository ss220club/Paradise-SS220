/obj/structure/table/Crossed(atom/movable/AM, oldloc)
	add_clumsy_climb()
	. = ..()
	remove_clumsy_climb()

/obj/structure/table/do_climb(mob/living/user)
	add_clumsy_climb()
	. = ..()
	SEND_SIGNAL(src, COMSIG_CLIMBED_ON, user)
	remove_clumsy_climb()

/obj/structure/table/proc/add_clumsy_climb()
	AddComponent(/datum/component/clumsy_climb, 15)

/obj/structure/table/proc/remove_clumsy_climb()
	qdel(GetComponent(/datum/component/clumsy_climb))
