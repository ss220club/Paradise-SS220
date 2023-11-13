/obj/structure/window/full
	smoothing_groups = list(SMOOTH_GROUP_WINDOW_FULLTILE)
	canSmoothWith = list(SMOOTH_GROUP_WINDOW_FULLTILE, SMOOTH_GROUP_WALLS, SMOOTH_GROUP_REINFORCED_WALLS, SMOOTH_GROUP_AIRLOCK)

/obj/structure/window/full/basic
	icon = 'modular_ss220/aesthetics/windows/icons/window.dmi'
	edge_overlay_file = 'modular_ss220/aesthetics/windows/icons/window_edges.dmi'

/obj/structure/window/full/reinforced
	icon = 'modular_ss220/aesthetics/windows/icons/reinforced_window.dmi'
	edge_overlay_file = 'modular_ss220/aesthetics/windows/icons/reinforced_window_edges.dmi'

/obj/structure/window/full/reinforced/tinted
	icon = 'modular_ss220/aesthetics/windows/icons/tinted_window.dmi'

/obj/structure/window/full/plasmabasic
	icon = 'modular_ss220/aesthetics/windows/icons/plasma_window.dmi'
	edge_overlay_file = 'modular_ss220/aesthetics/windows/icons/window_edges.dmi'

/obj/structure/window/full/plasmareinforced
	icon = 'modular_ss220/aesthetics/windows/icons/rplasma_window.dmi'
	edge_overlay_file = 'modular_ss220/aesthetics/windows/icons/reinforced_window_edges.dmi'

/turf/simulated/wall/indestructible/fakeglass
	icon = 'modular_ss220/aesthetics/windows/icons/reinforced_window.dmi'
	edge_overlay_file = 'modular_ss220/aesthetics/windows/icons/reinforced_window_edges.dmi'
	smoothing_groups = list(SMOOTH_GROUP_WINDOW_FULLTILE)
	canSmoothWith = list(SMOOTH_GROUP_WINDOW_FULLTILE, SMOOTH_GROUP_WALLS, SMOOTH_GROUP_REINFORCED_WALLS, SMOOTH_GROUP_AIRLOCK)

/obj/structure/window/full/shuttle
	smoothing_groups = list(SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE)
	canSmoothWith = list(SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE, SMOOTH_GROUP_TITANIUM_WALLS, SMOOTH_GROUP_AIRLOCK)

//WINDOW SPAWNERS
/obj/effect/spawner/window
	icon = 'modular_ss220/aesthetics/windows/icons/spawners.dmi'

/obj/effect/spawner/window/reinforced
	icon = 'modular_ss220/aesthetics/windows/icons/spawners.dmi'

/obj/effect/spawner/window/reinforced/tinted
	icon = 'modular_ss220/aesthetics/windows/icons/spawners.dmi'

/obj/effect/spawner/window/reinforced/polarized
	icon = 'modular_ss220/aesthetics/windows/icons/spawners.dmi'

/obj/effect/spawner/window/plasma
	icon = 'modular_ss220/aesthetics/windows/icons/spawners.dmi'

/obj/effect/spawner/window/reinforced/plasma
	icon = 'modular_ss220/aesthetics/windows/icons/spawners.dmi'

/obj/effect/spawner/window/plastitanium
	icon = 'icons/obj/structures.dmi'

/obj/effect/spawner/window/shuttle
	icon = 'icons/obj/structures.dmi'
