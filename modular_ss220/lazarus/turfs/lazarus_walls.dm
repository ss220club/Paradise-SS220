#define SMOOTH_GROUP_ICE_WALLS S_OBJ(80)	///turf/simulated/wall/ice

/turf/simulated/wall/ice
	name = "ледяная стена"
	desc = "Стена из застывших во льду камней. Кирка против неё бесполезна, но сварочник может помочь."
	icon = 'modular_ss220/lazarus/icons/ice_wall.dmi'
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
	icon = 'modular_ss220/lazarus/icons/ice_wall.dmi'
	icon_state = "ice_wall-0"
	base_icon_state = "ice_wall"
	sheet_type = null
	smoothing_groups = list(SMOOTH_GROUP_SIMULATED_TURFS, SMOOTH_GROUP_WALLS, SMOOTH_GROUP_ICE_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_ICE_WALLS)
	baseturf = /turf/simulated/floor/plating/asteroid/lazarus/dirt

// ROCKS

/turf/simulated/mineral/random/lazarus
	environment_type = "dirt"
	turf_type = /turf/simulated/floor/plating/asteroid/lazarus
	baseturf = /turf/simulated/floor/plating/asteroid/lazarus

/turf/simulated/floor/chasm/straight_down/lava_land_surface/normal_air/lazarus
	icon = 'modular_ss220/lazarus/icons/lazarus_chasms.dmi'
	light_range = 3
	light_power = 0.8
	light_color = LIGHT_COLOR_DARKRED
