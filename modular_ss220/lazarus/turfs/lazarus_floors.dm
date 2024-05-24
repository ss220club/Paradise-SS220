// BASIC TYPE

/turf/simulated/floor/plating/asteroid/lazarus
	name = "dirt"
	environment_type = "dirt"
	baseturf = /turf/simulated/floor/plating/asteroid/lazarus
	icon_state = "dirt_0"
	icon_plating = "dirt_0"
	icon = 'icons/turf/floors/lazarus_natural_floors.dmi'
	digResult = /obj/item/stack/ore/glass
	turf_type = /turf/simulated/floor/plating/asteroid/lazarus
	//planetary_atmos = TRUE // It's not work properly

/turf/simulated/floor/plating/asteroid/lazarus/randomize_icon_state()
	if(prob(floor_variance))
		icon_state = "[environment_type]_[rand(1,2)]"

/turf/simulated/floor/plating/screwdriver_act(mob/user, obj/item/I)	// "You start unfastening the dirt" fix
	return FALSE

// DIRT

/turf/simulated/floor/plating/asteroid/lazarus/dirt
	name = "земля"
	desc = "Почва, почти полностью состоящая из песка. Используйте лопату для добычи песка."
	baseturf = /turf/simulated/floor/plating/asteroid/lazarus/dirt
	icon_state = "dirt_0"

// SNOW

/turf/simulated/floor/plating/asteroid/lazarus/snow
	name = "снег"
	desc = "Большой сугроб. Замедляет вас и понижает температуру при передвижении. Используйте лопату для расчистки снега."
	icon = 'icons/turf/floors/lazarus_snow.dmi'
	icon_state = "snow"
	base_icon_state = "snow"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_TURF, SMOOTH_GROUP_LAZARUS_SNOW)
	canSmoothWith = list(SMOOTH_GROUP_LAZARUS_SNOW)
	layer = SNOW_LAYER
	broken_states = list("damaged")
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	environment_type = "snow"
	baseturf = /turf/simulated/floor/plating/asteroid/lazarus/dirt
	transform = matrix(1, 0, -9, 0, 1, -9) //50x50
	slowdown = 1

/turf/simulated/floor/plating/asteroid/lazarus/snow/getDug()
	ChangeTurf(/turf/simulated/floor/plating/asteroid/lazarus/dirt, keep_icon = FALSE)
	randomize_icon_state()


