/obj/structure/alien/weeds/meaty
	icon = 'modular_ss220/lazarus/icons/meaty_weeds.dmi'

/obj/structure/alien/weeds/node/meaty
	icon = 'modular_ss220/lazarus/icons/meaty_weeds.dmi'

/obj/structure/alien/wallweed/meaty
	icon = 'modular_ss220/lazarus/icons/meaty_weeds.dmi'

/obj/structure/alien/weeds/check_surroundings()
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
