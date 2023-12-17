/mob/living/simple_animal/hostile/megafauna/legion/adjustHealth(damage, updating_health)
	. = ..()
	if(!GLOB.necropolis_gate)
		return
	if(GLOB.necropolis_gate.legion_triggered)
		return
	GLOB.necropolis_gate.toggle_the_gate(src, TRUE)

/obj/structure/necropolis_gate/legion_gate
	var/legion_triggered = FALSE

/obj/structure/necropolis_gate/legion_gate/toggle_the_gate(mob/user, legion_damaged)
	if(open)
		return
	GLOB.necropolis_gate.legion_triggered = TRUE
	. = ..()
	if(.)
		locked = TRUE
