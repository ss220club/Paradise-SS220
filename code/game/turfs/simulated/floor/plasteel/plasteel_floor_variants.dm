// Visual variants of the standard plasteel floor

/turf/simulated/floor/plasteel/side
	icon_state = "tile_edge"

/turf/simulated/floor/plasteel/half
	icon_state = "tile_half"

/turf/simulated/floor/plasteel/full
	icon_state = "tile_full"

/turf/simulated/floor/plasteel/corner
	icon_state = "tile_corner"

/turf/simulated/floor/plasteel/grid
	icon_state = "tile_grid"

/turf/simulated/floor/plasteel/dark
	icon_state = "tile_dark_standard"

/turf/simulated/floor/plasteel/dark/airless
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

// SS220 EDIT START: Added lavaland air variant for dark plasteel floor
/turf/simulated/floor/plasteel/dark/lavaland_air
	oxygen = LAVALAND_OXYGEN
	nitrogen = LAVALAND_NITROGEN
	temperature = LAVALAND_TEMPERATURE
	atmos_mode = ATMOS_MODE_EXPOSED_TO_ENVIRONMENT
	atmos_environment = ENVIRONMENT_LAVALAND
// SS220 EDIT END

/turf/simulated/floor/plasteel/dark/edge
	icon_state = "tile_dark_edge"

/turf/simulated/floor/plasteel/dark/half
	icon_state = "tile_dark_half"

/turf/simulated/floor/plasteel/dark/full
	icon_state = "tile_dark_full"

/turf/simulated/floor/plasteel/dark/corner
	icon_state = "tile_dark_corner"

/turf/simulated/floor/plasteel/dark/grid
	icon_state = "tile_dark_grid"

/turf/simulated/floor/plasteel/white
	icon_state = "tile_white_standard"

/turf/simulated/floor/plasteel/white/airless
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

// SS220 EDIT START: Added lavaland air variant for white plasteel floor
/turf/simulated/floor/plasteel/white/lavaland_air
	oxygen = LAVALAND_OXYGEN
	nitrogen = LAVALAND_NITROGEN
	temperature = LAVALAND_TEMPERATURE
	atmos_mode = ATMOS_MODE_EXPOSED_TO_ENVIRONMENT
	atmos_environment = ENVIRONMENT_LAVALAND
// SS220 EDIT END

/turf/simulated/floor/plasteel/white/edge
	icon_state = "tile_white_edge"

/turf/simulated/floor/plasteel/white/half
	icon_state = "tile_white_half"

/turf/simulated/floor/plasteel/white/full
	icon_state = "tile_white_full"

/turf/simulated/floor/plasteel/white/corner
	icon_state = "tile_white_corner"

/turf/simulated/floor/plasteel/white/grid
	icon_state = "tile_white_grid"
