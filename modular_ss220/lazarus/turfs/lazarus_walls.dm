/turf/simulated/wall/ice
	name = "ледяная стена"
	desc = "Стена из застывших во льду камней. Кирка против неё бесполезна, но сварочник может помочь."
	icon = 'icons/turf/walls/ice_wall.dmi'
	icon_state = "ice_wall-0"
	base_icon_state = "ice_wall"
	sheet_type = null
	explosion_block = 3
	smoothing_groups = list(SMOOTH_GROUP_SIMULATED_TURFS, SMOOTH_GROUP_WALLS, SMOOTH_GROUP_ICE_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_ICE_WALLS)
	baseturf = /turf/simulated/floor/plating/asteroid/lazarus/dirt

/turf/simulated/wall/indestructible/ice
	name = "ледяная стена"
	desc = "Стена из застывших во льду камней. Эта выглядит очень крепко."
	icon = 'icons/turf/walls/ice_wall.dmi'
	icon_state = "ice_wall-0"
	base_icon_state = "ice_wall"
	sheet_type = null
	smoothing_groups = list(SMOOTH_GROUP_SIMULATED_TURFS, SMOOTH_GROUP_WALLS, SMOOTH_GROUP_ICE_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_ICE_WALLS)
	baseturf = /turf/simulated/floor/plating/asteroid/lazarus/dirt
