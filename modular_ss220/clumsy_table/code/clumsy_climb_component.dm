/datum/component/clumsy_climb_component
	var/thrown_chance = 80 	//default for all human-sized livings
	var/force_mod = 0.1 	//коэффицент уменьшения урона при сбрасывании предмета
	var/max_thrown_objects = 15
	var/max_thrown_objects_low = 5

/datum/component/clumsy_climb_component/Initialize()
	//RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, PROC_REF(Repaint))
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/clumsy_climb_component/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOVABLE_CROSSED, PROC_REF(cross))
	RegisterSignal(parent, COMSIG_CLIMBED_ON, PROC_REF(cross))

/datum/component/clumsy_climb_component/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_MOVABLE_CROSSED, COMSIG_CLIMBED_ON))

/datum/component/clumsy_climb_component/proc/cross(atom/table, mob/living/climber)
	if(!table.contents)
		return

	if(!istype(climber))
		return

	var/mob/living/user = climber
	if(user.mob_size <= MOB_SIZE_SMALL && !user.throwing)
		return

	max_thrown_objects = initial(max_thrown_objects)
	if(!user.throwing)
		max_thrown_objects = max_thrown_objects_low

	clumsy_stuff(user)


/datum/component/clumsy_climb_component/proc/clumsy_stuff(mob/living/user)
	if(!user)
		return

	switch(user.mob_size)
		if(MOB_SIZE_LARGE)
			thrown_chance = 100
		if(MOB_SIZE_SMALL)
			thrown_chance = 20
		if(MOB_SIZE_TINY)
			thrown_chance = 10

	if(HAS_TRAIT(user, TRAIT_CLUMSY))
		thrown_chance += 20
	if(user.mind?.miming)
		thrown_chance -= 30

	thrown_chance = clamp(thrown_chance, 1, 100)

	var/list/thrown_atoms = list()

	for(var/turf/T in range(0, user)) //Preventing from rotating stuff in an inventory
		for(var/atom/movable/I in T)
			if(!I.anchored && !isliving(I) && prob(thrown_chance))
				thrown_atoms += I
				if(thrown_atoms.len >= max_thrown_objects)
					break

	var/atom/thrown_target
	for(var/obj/item/I in thrown_atoms)
		I.force *= force_mod
		I.throwforce *= force_mod //no killing using shards :lul:
		thrown_target = get_edge_target_turf(user, get_dir(user, get_step_away(I, user)))
		I.throw_at(target = thrown_target, range = 1, speed = 1)
		I.pixel_x = rand(-6, 6)
		I.pixel_y = rand(0, 10)
		I.force /= force_mod
		I.throwforce /= force_mod
