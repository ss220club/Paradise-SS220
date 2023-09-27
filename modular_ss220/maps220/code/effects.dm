/* Awaymission - Gate Lizard */
// Firefly
/obj/effect/firefly
	name = "firefly"
	desc = ""
	icon = 'modular_ss220/maps220/icons/effects.dmi'
	icon_state = "fire_fly1"
	light_color = "#F8F6E6"
	light_power = 4
	light_range = 2
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/firefly/blue
	icon_state = "fire_fly3"
	light_color = "#4169E1"

/obj/effect/firefly/green
	icon_state = "fire_fly2"
	light_color = "#228B22"

/* Syndicate Base - Mothership */
// Decals
/obj/effect/decal/syndie_logo
	name = "Syndicate logo"
	icon = 'modular_ss220/maps220/icons/syndie_logo.dmi'
	icon_state = "logo1"
	layer = TURF_LAYER
	desc = "Death to Nanotrasen."

// Turf decals
/obj/effect/turf_decal/miscellaneous
	icon_state = null

/obj/effect/turf_decal/miscellaneous/plumbing
	icon = 'modular_ss220/maps220/icons/decals.dmi'
	icon_state = "plumbing"

/obj/effect/turf_decal/miscellaneous/goldensiding
	icon = 'modular_ss220/maps220/icons/decals.dmi'
	icon_state = "golden_stripes"

/obj/effect/turf_decal/miscellaneous/goldensiding/corner
	icon_state = "golden_stripes_corner"

/obj/effect/turf_decal/siding/black
	icon = 'modular_ss220/maps220/icons/decals.dmi'
	icon_state = "bs_line"

/obj/effect/turf_decal/siding/black/corner
	icon_state = "bs_deadlock"

/obj/effect/turf_decal/siding/black/full
	icon_state = "bs_full"

// Turf decals fix on shuttles
/obj/effect/turf_decal
	layer = TURF_DECAL_LAYER
	var/do_not_delete_me = FALSE

/obj/effect/turf_decal/Initialize(mapload)
	. = ..()
	var/turf/T = loc
	if(!istype(T)) //you know this will happen somehow
		CRASH("Turf decal initialized in an object/nullspace")
	T.AddComponent(/datum/component/decal, icon, icon_state, dir, CLEAN_GOD, color, null, null, alpha)

	if(!do_not_delete_me)
		qdel(src) // return INITIALIZE_HINT_QDEL <-- Doesn't work
	invisibility = INVISIBILITY_MAXIMUM

/obj/effect/turf_decal/onShuttleMove()
	. = ..()
	var/turf/T = loc
	if(!istype(T)) //you know this will happen somehow
		return
	T.AddComponent(/datum/component/decal, icon, icon_state, dir, CLEAN_GOD, color, null, null, alpha)
