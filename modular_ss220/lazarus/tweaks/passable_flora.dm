#define PASSFLORA (1<<10)

/obj/structure/flora/CanPass(atom/movable/mover, turf/target, height)
	if(istype(mover) && mover.checkpass(PASSFLORA))
		return TRUE
	. = ..()
