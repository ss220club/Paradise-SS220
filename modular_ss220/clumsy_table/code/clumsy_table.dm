/obj/structure/do_climb(mob/living/user)
	if(!user)
		return ..()

	if(..())
		clumsy_stuff(user)

/obj/structure/table/Crossed(atom/movable/AM, oldloc)
	. = ..()

	if(!isliving(AM))
		if(istype(AM, /obj/item/holder))
			var/obj/item/holder/H = AM
			for(var/mob/M in H.contents)
				AM = M
				break
		return

	var/mob/living/user = AM
	if(user.mob_size <= MOB_SIZE_SMALL && !user.throwing)
		return

	var/max_throws_count = 5
	if(user.throwing)
		max_throws_count = 15

	clumsy_stuff(user, max_throws_count)

/obj/structure/proc/clumsy_stuff(mob/living/user, max_throws_count = 15)
	if(!user)
		return
	var/slopchance = 80 //default for all human-sized livings
	var/force_mult = 0.1 //коэффицент уменьшения урона при сбрасывании предмета

	switch(user.mob_size)
		if(MOB_SIZE_LARGE) 	slopchance = 100
		if(MOB_SIZE_SMALL) 	slopchance = 20
		if(MOB_SIZE_TINY) 	slopchance = 10

	if(HAS_TRAIT(user, TRAIT_CLUMSY))
		slopchance += 20
	if(user.mind?.miming)
		slopchance -= 30

	slopchance = clamp(slopchance, 1, 100)

	var/list/thrownatoms = list()

	for(var/turf/T in range(0, src)) //Preventing from rotating stuff in an inventory
		for(var/atom/movable/AM in T)
			if(!AM.anchored && !isliving(AM) && prob(slopchance))
				thrownatoms += AM
				if(thrownatoms.len >= max_throws_count)
					break

	var/atom/throwtarget
	for(var/obj/item/AM in thrownatoms)
		AM.force *= force_mult
		AM.throwforce *= force_mult //no killing using shards :lul:
		throwtarget = get_edge_target_turf(user, get_dir(src, get_step_away(AM, src)))
		AM.throw_at(target = throwtarget, range = 1, speed = 1)
		AM.pixel_x = rand(-6, 6)
		AM.pixel_y = rand(0, 10)
		AM.force /= force_mult
		AM.throwforce /= force_mult
