/turf/simulated/wall
	icon = 'modular_ss220/aesthetics/walls/icons/wall.dmi'

/turf/simulated/wall/r_wall
	icon = 'modular_ss220/aesthetics/walls/icons/reinforced_wall.dmi'

/obj/structure/falsewall
	icon = 'modular_ss220/aesthetics/walls/icons/wall.dmi'

/obj/structure/falsewall/reinforced
	icon = 'modular_ss220/aesthetics/walls/icons/reinforced_wall.dmi'

/turf/simulated/wall/indestructible/whiteshuttle
    name = "reinforced shuttle wall"
    desc = "A light-weight reinforced titanium wall used in shuttles."
    icon = 'icons/turf/walls/plastinum_wall.dmi'
    icon_state = "plastinum_wall-0"
    base_icon_state = "plastinum_wall"
    smoothing_flags = SMOOTH_BITMASK | SMOOTH_DIAGONAL_CORNERS
    smoothing_groups = list(SMOOTH_GROUP_TITANIUM_WALLS, SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE)
    canSmoothWith = list(SMOOTH_GROUP_TITANIUM_WALLS, SMOOTH_GROUP_AIRLOCK, SMOOTH_GROUP_SHUTTLE_PARTS, SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE)

/turf/simulated/wall/indestructible/whiteshuttle/nodiagonal
    icon_state = "map-shuttle_nd"
    smoothing_flags = SMOOTH_BITMASK

/turf/simulated/wall/indestructible/syndishuttle
    name = "reinforced shuttle wall"
    desc = "An evil reinforced wall of plasma and titanium."
    icon = 'icons/turf/walls/plastitanium_wall.dmi'
    icon_state = "plastitanium_wall-0"
    base_icon_state = "plastitanium_wall"
    smoothing_flags = SMOOTH_BITMASK | SMOOTH_DIAGONAL_CORNERS
    smoothing_groups = list(SMOOTH_GROUP_PLASTITANIUM_WALLS)
    canSmoothWith = list(SMOOTH_GROUP_PLASTITANIUM_WALLS, SMOOTH_GROUP_AIRLOCK, SMOOTH_GROUP_SHUTTLE_PARTS)

/turf/simulated/wall/indestructible/syndishuttle/nodiagonal
    icon_state = "map-shuttle_nd"
    base_icon_state = "plastitanium_wall"
    smoothing_flags = SMOOTH_BITMASK


