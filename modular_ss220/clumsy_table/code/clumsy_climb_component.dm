/datum/component/clumsy_climb_component
	/// default for all human-sized livings
	var/thrown_chance = 80
	/// force damage modifier
	var/force_mod = 0.1
	var/max_thrown_objects = 15
	var/max_thrown_objects_low = 5

/datum/component/clumsy_climb_component/Initialize()
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/clumsy_climb_component/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOVABLE_CROSSED, PROC_REF(cross))
	RegisterSignal(parent, COMSIG_CLIMBED_ON, PROC_REF(cross))
	RegisterSignal(parent, COMSIG_DANCED_ON, PROC_REF(cross))

/datum/component/clumsy_climb_component/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_MOVABLE_CROSSED, COMSIG_CLIMBED_ON))

/datum/component/clumsy_climb_component/proc/cross(atom/table, mob/living/user)
	if(!table.contents)
		return

	if(!istype(user))
		return

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

	var/turf/user_turf = get_turf(user)
	for(var/atom/movable/AM in user_turf)
		if(!AM.anchored && !isliving(AM) && prob(thrown_chance))
			thrown_atoms += AM
			if(length(thrown_atoms) >= max_thrown_objects)
				break

	for(var/obj/item/item in thrown_atoms)
		item.force *= force_mod
		item.throwforce *= force_mod //no killing using shards :lul:
		var/atom/thrown_target = get_edge_target_turf(user, get_dir(user_turf, get_step_away(item, user_turf)))
		item.throw_at(target = thrown_target, range = 1, speed = 1)
		item.pixel_x = rand(-6, 6)
		item.pixel_y = rand(0, 10)
		item.force /= force_mod
		item.throwforce /= force_mod
