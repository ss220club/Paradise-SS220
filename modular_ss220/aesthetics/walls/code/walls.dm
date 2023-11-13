/turf/simulated/wall
	icon = 'modular_ss220/aesthetics/walls/icons/wall.dmi'
	smoothing_groups = list(SMOOTH_GROUP_SIMULATED_TURFS, SMOOTH_GROUP_WALLS, SMOOTH_GROUP_REGULAR_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_REGULAR_WALLS, SMOOTH_GROUP_REINFORCED_WALLS, SMOOTH_GROUP_AIRLOCK, SMOOTH_GROUP_WINDOW_FULLTILE)

/turf/simulated/wall/r_wall
	icon = 'modular_ss220/aesthetics/walls/icons/reinforced_wall.dmi'
	canSmoothWith = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_REGULAR_WALLS, SMOOTH_GROUP_REINFORCED_WALLS, SMOOTH_GROUP_AIRLOCK, SMOOTH_GROUP_WINDOW_FULLTILE)

/obj/structure/falsewall
	icon = 'modular_ss220/aesthetics/walls/icons/wall.dmi'
	canSmoothWith = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_REGULAR_WALLS, SMOOTH_GROUP_REINFORCED_WALLS, SMOOTH_GROUP_AIRLOCK, SMOOTH_GROUP_WINDOW_FULLTILE)

/obj/structure/falsewall/reinforced
	icon = 'modular_ss220/aesthetics/walls/icons/reinforced_wall.dmi'
	canSmoothWith = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_REGULAR_WALLS, SMOOTH_GROUP_REINFORCED_WALLS, SMOOTH_GROUP_AIRLOCK, SMOOTH_GROUP_WINDOW_FULLTILE)

/turf/simulated/wall/indestructible/riveted
	icon = 'modular_ss220/aesthetics/walls/icons/reinforced_wall.dmi'
	canSmoothWith = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_REGULAR_WALLS, SMOOTH_GROUP_REINFORCED_WALLS, SMOOTH_GROUP_AIRLOCK, SMOOTH_GROUP_WINDOW_FULLTILE)

/turf/simulated/wall/mineral/titanium
	smoothing_groups = list(SMOOTH_GROUP_TITANIUM_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_TITANIUM_WALLS, SMOOTH_GROUP_AIRLOCK, SMOOTH_GROUP_SHUTTLE_PARTS, SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE)

/turf/simulated/wall/indestructible/wood
	smoothing_groups = list(SMOOTH_GROUP_WOOD_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_WOOD_WALLS, SMOOTH_GROUP_AIRLOCK)

