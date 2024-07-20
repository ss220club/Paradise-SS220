/turf/simulated/floor/plating/asteroid/lazarus/forest
	name = "forest turf"
	icon = 'modular_ss220/lazarus/icons/mapping.dmi'
	icon_state = "forest"
	var/dirt_chance = 15
	var/result = list(
	/datum/nothing = 15,
	/obj/structure/flora/tree/pine = 12,
	/obj/structure/flora/grass/green = 3,
	/obj/structure/flora/grass/brown = 3,
	/obj/structure/flora/grass/both = 3,
	/obj/structure/flora/bush = 2,
	/obj/structure/flora/rock/icy = 1,
	/obj/structure/flora/rock/pile/icy = 1,
	)

/turf/simulated/floor/plating/asteroid/lazarus/forest/Initialize(mapload)
	. = ..()
	var/type_to_spawn = pickweight(result)
	new type_to_spawn(src)
	if(prob(dirt_chance))
		ChangeTurf(/turf/simulated/floor/plating/asteroid/lazarus/dirt, keep_icon = FALSE)
	else
		ChangeTurf(/turf/simulated/floor/plating/asteroid/lazarus/snow, keep_icon = FALSE)

/turf/simulated/floor/plating/asteroid/lazarus/forest/edge
	name = "forest edge turf"
	icon_state = "forest_edge"
	dirt_chance = 3
	result = list(
	/datum/nothing = 40,
	/obj/structure/flora/tree/pine = 4,
	/obj/structure/flora/grass/green = 15,
	/obj/structure/flora/grass/brown = 15,
	/obj/structure/flora/grass/both = 15,
	/obj/structure/flora/bush = 12,
	/obj/structure/flora/rock/icy = 2,
	/obj/structure/flora/rock/pile/icy = 2,
	)

// Destroyed Window Helpers
/// Parent type for destroyed_window helpers. Do not use in maps
/obj/effect/mapping_helpers/destroyed_window
	name = "destroyed window helper"
	icon = 'modular_ss220/lazarus/icons/mapping.dmi'
	icon_state = "destroyed_window"
	layer = ABOVE_OBJ_LAYER
	late = TRUE

/obj/effect/mapping_helpers/destroyed_window/Initialize(mapload)
	. = ..()
	if(!mapload)
		log_world("[src] spawned outside of mapload!")
		return INITIALIZE_HINT_QDEL
	return INITIALIZE_HINT_LATELOAD

/obj/effect/mapping_helpers/destroyed_window/LateInitialize()
	. = ..()
	var/obj/structure/window/target = locate(/obj/structure/window) in loc

	if(isnull(target))
		var/area/target_area = get_area(src)
		log_world("[src] failed to find a window at [AREACOORD(src)] ([target_area.type]).")
		qdel(src)
		return
	else
		payload(target)
	qdel(src)

/obj/effect/mapping_helpers/destroyed_window/proc/payload(obj/structure/window/target)
	var/area/target_area = get_area(src)
	log_world("[src] at [AREACOORD(src)] ([target_area.type]) is not valid type. Use subtypes instead")

/// Destroy first window found on a tile and left grille intact
/obj/effect/mapping_helpers/destroyed_window/intact_grill/payload(obj/structure/window/target)
	target.obj_destruction()

/// Destroy first window found on a tile and left grille damaged
/obj/effect/mapping_helpers/destroyed_window/broken_grill/payload(obj/structure/window/target)
	target.obj_destruction()
	var/obj/structure/window/grille = locate(/obj/structure/grille) in loc
	if(isnull(grille))
		var/area/target_area = get_area(src)
		log_world("[src] failed to find a grille at [AREACOORD(src)] ([target_area.type]). If there is no grille on this tile, use destroyed_window/intact_gril instead")
		return
	else
		grille.take_damage(grille.obj_integrity)

/// Destroy first window found on a tile and destroy grille
/obj/effect/mapping_helpers/destroyed_window/destroyed_grill/payload(obj/structure/window/target)
	target.obj_destruction()
	var/obj/structure/window/grille = locate(/obj/structure/grille) in loc
	if(isnull(grille))
		var/area/target_area = get_area(src)
		log_world("[src] failed to find a grille at [AREACOORD(src)] ([target_area.type]). If there is no grille on this tile, use destroyed_window/intact_gril instead")
		return
	else
		grille.obj_destruction()
