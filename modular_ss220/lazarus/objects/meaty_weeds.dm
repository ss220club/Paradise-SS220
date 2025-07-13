/obj/structure/alien/weeds/meaty
	icon = 'modular_ss220/lazarus/icons/meaty_weeds.dmi'
	name = "мясистая плоть"
	desc = "Мясистый ковёр из плоти, устилающий пол. Он постоянно движется, наращивая всё новые слои."

/obj/structure/alien/weeds/node/meaty
	icon = 'modular_ss220/lazarus/icons/meaty_weeds.dmi'
	light_color = "#A91515"
	light_power = 0.8
	light_range = 3
	name = "глазной отросток"
	desc = "Отросток, на котором растёт множество белых глазных яблок. Они смотрят прямо на вас..."
	layer = 2.12

/obj/structure/alien/wallweed/meaty
	icon = 'modular_ss220/lazarus/icons/meaty_weeds.dmi'
	name = "мясистая плоть"
	desc = "Мясистый ковёр из плоти, устилающий стены. Он постоянно движется, наращивая всё новые слои."

/obj/structure/alien/resin/wall/meaty
	name = "мясистая стена"
	desc = "Огромный ком плоти, образующий некоторое подобие стены."
	icon = 'modular_ss220/lazarus/icons/meaty_wall.dmi'

/obj/structure/alien/resin/door/meaty
	name = "мясистая дверь"
	desc = "Отвратительная арка, заросшая мясистой плотью."
	icon = 'modular_ss220/lazarus/icons/meaty_door.dmi'

/obj/structure/alien/resin/door/meaty/try_to_operate(mob/user, bumped_open = FALSE)
	if(!ismob(user))	// It's strange, but sometimes effects try to operate doors
		return
	if(is_operating)
		return
	if(user.faction.Find("treacherous_flesh"))
		operate(bumped_open)

/obj/structure/alien/resin/door/attack_animal(mob/living/simple_animal/M)
	if(M.a_intent != INTENT_HARM)
		try_to_operate(M)
		return

/obj/structure/alien/resin/Initialize(mapload)
	recalculate_atmos_connectivity()
	if(!is_alien)
		return ..()
	for(var/obj/structure/alien/weeds/node/W in get_turf(src))
		qdel(W)
	if(locate(/obj/structure/alien/weeds) in get_turf(src))
		return ..()
	new /obj/structure/alien/weeds/meaty(loc, src)
	return ..()

/obj/structure/alien/weeds/meaty/check_surroundings()
	var/turf/T = get_turf(src)
	var/list/nearby_dense_turfs = T.AdjacentTurfs(cardinal_only = FALSE, dense_only = TRUE)
	if(!length(nearby_dense_turfs)) // There is no dense turfs around it
		clear_wall_weed()
		return

	var/list/wall_dirs = list()
	for(var/turf/W in nearby_dense_turfs)
		if(iswallturf(W))
			wall_dirs.Add(get_dir(W, T))
	if(!length(wall_dirs)) // There is no walls around it
		clear_wall_weed()
		return

	var/list/nearby_open_turfs = T.AdjacentTurfs(open_only = TRUE, cardinal_only = TRUE)

	for(var/turf/W in nearby_open_turfs) // This handles removal of corner-weeds when they are to be replaced with a full side-weed instead
		if(locate(/obj/structure/alien/weeds, W))
			var/dirs = get_dir(W, T)
			switch(dirs)
				if(NORTH)
					wall_dirs.Remove(NORTHEAST, NORTHWEST)
				if(SOUTH)
					wall_dirs.Remove(SOUTHEAST, SOUTHWEST)
				if(EAST)
					wall_dirs.Remove(NORTHEAST, SOUTHEAST)
				if(WEST)
					wall_dirs.Remove(NORTHWEST, SOUTHWEST)

	if(!length(wall_dirs)) // No weeds will be applied, better off deleting it
		clear_wall_weed()
		return

	if(!wall_weed || QDELETED(wall_weed))
		wall_weed = new /obj/structure/alien/wallweed/meaty(T, src)

	wall_weed.compare_overlays(wall_dirs)

/obj/structure/alien/weeds/node/meaty/check_surroundings()
	var/turf/T = get_turf(src)
	var/list/nearby_dense_turfs = T.AdjacentTurfs(cardinal_only = FALSE, dense_only = TRUE)
	if(!length(nearby_dense_turfs)) // There is no dense turfs around it
		clear_wall_weed()
		return

	var/list/wall_dirs = list()
	for(var/turf/W in nearby_dense_turfs)
		if(iswallturf(W))
			wall_dirs.Add(get_dir(W, T))
	if(!length(wall_dirs)) // There is no walls around it
		clear_wall_weed()
		return

	var/list/nearby_open_turfs = T.AdjacentTurfs(open_only = TRUE, cardinal_only = TRUE)

	for(var/turf/W in nearby_open_turfs) // This handles removal of corner-weeds when they are to be replaced with a full side-weed instead
		if(locate(/obj/structure/alien/weeds, W))
			var/dirs = get_dir(W, T)
			switch(dirs)
				if(NORTH)
					wall_dirs.Remove(NORTHEAST, NORTHWEST)
				if(SOUTH)
					wall_dirs.Remove(SOUTHEAST, SOUTHWEST)
				if(EAST)
					wall_dirs.Remove(NORTHEAST, SOUTHEAST)
				if(WEST)
					wall_dirs.Remove(NORTHWEST, SOUTHWEST)

	if(!length(wall_dirs)) // No weeds will be applied, better off deleting it
		clear_wall_weed()
		return

	if(!wall_weed || QDELETED(wall_weed))
		wall_weed = new /obj/structure/alien/wallweed/meaty(T, src)

	wall_weed.compare_overlays(wall_dirs)

/obj/structure/alien/weeds/meaty/spread()
	var/turf/U = get_turf(src)

	if(isspaceturf(U))
		qdel(src)
		return

	if(!linked_node)
		if(prob(20))
			silent_removal = TRUE
			qdel(src)
		return

	if((istype(linked_node, /obj/structure/alien/resin/door)) || (istype(linked_node, /obj/structure/alien/resin/wall)))
		return

	if(get_dist(linked_node, src) > linked_node.node_range) /*!linked_node || */
		return

	for(var/turf/T in U.GetAtmosAdjacentTurfs())
		if((locate(/obj/structure/alien/weeds) in T) || isspaceturf(T) || islava(T) || ischasm(T))
			continue
		new /obj/structure/alien/weeds/meaty(T, linked_node)
		check_surroundings()

/obj/structure/alien/weeds/node/meaty/spread()
	var/turf/U = get_turf(src)

	if(isspaceturf(U))
		qdel(src)
		return

	if(!linked_node)
		if(prob(20))
			silent_removal = TRUE
			qdel(src)
		return

	if((istype(linked_node, /obj/structure/alien/resin/door)) || (istype(linked_node, /obj/structure/alien/resin/wall)))
		return

	if(get_dist(linked_node, src) > linked_node.node_range) /*!linked_node || */
		return

	for(var/turf/T in U.GetAtmosAdjacentTurfs())
		if((locate(/obj/structure/alien/weeds) in T) || isspaceturf(T) || islava(T) || ischasm(T))
			continue
		new /obj/structure/alien/weeds/meaty(T, linked_node)
		check_surroundings()
