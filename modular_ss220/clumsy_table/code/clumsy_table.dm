#define COMSIG_CLIMBED_ON "climb_on"

/obj/structure/table/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/clumsy_climb_component, 15)

/obj/structure/do_climb(mob/living/user)
	if(!user)
		return ..()

	if(..())
		SEND_SIGNAL(src, COMSIG_CLIMBED_ON, user)
