/// Floor icon_states for floor painter
/datum/painter/floor/New()
	allowed_states |= list("darkneutralcorner", "darkneutral", "darkneutralfull", "navybluecorners", "navyblue", "navybluefull",
		"navybluealt", "navybluealtstrip", "navybluecornersalt", "darkbluealt", "darkbluealtstrip", "darkbluecornersalt",
		"darkredalt", "darkredaltstrip", "darkredcornersalt", "darkyellowalt", "darkyellowaltstrip", "darkyellowcornersalt",
		"whitebrowncorner", "whitebrown"
		)
	. = ..()

/turf/simulated/floor
	icon = 'modular_ss220/aesthetics/floors/icons/floors.dmi'

/turf/simulated/floor/plasteel/dark
	icon_state = "dark"

/turf/simulated/floor/mech_bay_recharge_floor
	icon = 'modular_ss220/aesthetics/floors/icons/floors.dmi'

/turf/simulated/floor/plasteel/smooth
	icon_state = "smooth"

// Wood
/turf/simulated/floor/wood
	icon = 'modular_ss220/aesthetics/floors/icons/wooden.dmi'
	icon_state = "wood"
	color = "#864A2D"

/turf/simulated/floor/wood/oak
	color = "#644526"
	floor_tile = /obj/item/stack/tile/wood/oak

/turf/simulated/floor/wood/birch
	color = "#FFECB3"
	floor_tile = /obj/item/stack/tile/wood/birch

/turf/simulated/floor/wood/cherry
	color = "#643412"
	floor_tile = /obj/item/stack/tile/wood/cherry

/turf/simulated/floor/wood/get_broken_states()
	return list("wood-broken", "wood-broken2", "wood-broken3", "wood-broken4", "wood-broken5", "wood-broken6", "wood-broken7")

// Fancy Wood
/turf/simulated/floor/wood/fancy
	icon_state = "wood_fancy"
	color = "#864A2D"
	floor_tile = /obj/item/stack/tile/wood/fancy

/turf/simulated/floor/wood/fancy/oak
	color = "#644526"
	floor_tile = /obj/item/stack/tile/wood/fancy/oak

/turf/simulated/floor/wood/fancy/birch
	color = "#FFECB3"
	floor_tile = /obj/item/stack/tile/wood/fancy/birch

/turf/simulated/floor/wood/fancy/cherry
	color = "#643412"
	floor_tile = /obj/item/stack/tile/wood/fancy/cherry

/turf/simulated/floor/wood/fancy/get_broken_states()
	return list("wood_fancy-broken", "wood_fancy-broken2", "wood_fancy-broken3")

// Parquet
/turf/simulated/floor/wood/parquet
	icon_state = "wood_parquet"
	color = "#864A2D"
	floor_tile = /obj/item/stack/tile/wood/parquet

/turf/simulated/floor/wood/parquet/get_broken_states()
	return list("wood_parquet-broken", "wood_parquet-broken2", "wood_parquet-broken3", "wood_parquet-broken4", "wood_parquet-broken5", "wood_parquet-broken6", "wood_parquet-broken7")

// Tiled Parquet
/turf/simulated/floor/wood/parquet/tile
	icon_state = "wood_tile"
	color = "#864A2D"
	floor_tile = /obj/item/stack/tile/wood/parquet/tile

/turf/simulated/floor/wood/parquet/tile/get_broken_states()
	return list("wood_tile-broken", "wood_tile-broken2", "wood_tile-broken3")

// LIGHT FLOORS
/turf/simulated/floor/light
	icon = 'icons/turf/floors.dmi'

/turf/simulated/floor/light/red
	color = "#f23030"
	light_color = "#f23030"

/turf/simulated/floor/light/green
	color = "#30f230"
	light_color = "#30f230"

/turf/simulated/floor/light/blue
	color = "#3030f2"
	light_color = "#3030f2"

/turf/simulated/floor/light/purple
	color = "#d493ff"
	light_color = "#d493ff"
