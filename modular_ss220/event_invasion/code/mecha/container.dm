/obj/structure/container/syndie
	name = "Syndie Container"
	desc = "A huge industrial shipping container."
	icon = 'modular_ss220/event_invasion/icons/Container.dmi'
	icon_state = "container"
	bound_width = 128
	bound_height = 64
	layer = 5.5
	bound_x = -32
	bound_y = -32
	pixel_x = 10
	density = TRUE
	max_integrity = 10000
	opacity = FALSE
	anchored = TRUE
	var/datum/effect_system/smoke_spread/smoke

/obj/structure/container/syndie/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/largetransparency, 0, 1, 2, 0)
	smoke = new /datum/effect_system/smoke_spread
	smoke.attach(NORTH_OF_TURF(loc))
	appearance_flags |= PIXEL_SCALE
	transform = transform.Scale(2, 2)

/obj/structure/container/syndie/Destroy()
	QDEL_NULL(smoke)
	return ..()

/obj/structure/container/syndie/attack_hand(mob/living/user)
	open_container()

/obj/structure/container/syndie/proc/prime_smoke()
	playsound(src.loc, 'sound/effects/smoke.ogg', 50, 1, -3)
	alpha = 0
	smoke.set_up(10, FALSE)
	spawn(0)
		src.smoke.start()
		sleep(10)
		src.smoke.start()
		sleep(10)
		src.smoke.start()
		sleep(10)
		src.smoke.start()
	sleep(80)
	qdel(src)

/obj/structure/container/syndie/proc/open_container()
	new /obj/mecha/combat/nomad(loc)
	new /obj/effect/container_wall/bottom(loc)
	new /obj/effect/container_wall/up(locate(loc.x, loc.y + 2, loc.z))
	new /obj/effect/container_wall/down(locate(loc.x, loc.y - 2, loc.z))
	new /obj/effect/container_wall/side/left(locate(loc.x - 3, loc.y, loc.z))
	new /obj/effect/container_wall/side/right(locate(loc.x + 4, loc.y, loc.z))
	prime_smoke()

/obj/effect/container_wall
	icon = 'modular_ss220/event_invasion/icons/Container_parts1.dmi'
	appearance_flags = PIXEL_SCALE
	name = "Внушительная стена контейнера"
	desc = "Огромная металлическая пластина."
	pixel_x = -15
	pixel_y = 5

/obj/effect/container_wall/Initialize(mapload)
	. = ..()
	transform = transform.Scale(2, 2)

/obj/effect/container_wall/up
	icon_state = "up"

/obj/effect/container_wall/down
	icon_state = "down"
	pixel_y = 8

/obj/effect/container_wall/bottom
	icon_state = "bottom"
	pixel_y = 11

/obj/effect/container_wall/roof
	icon_state = "roof"
	layer = 3.1

/obj/effect/container_wall/side
	icon = 'modular_ss220/event_invasion/icons/Container_parts2.dmi'
	icon_state = "container_wall"

/obj/effect/container_wall/side/left
	dir = WEST
	pixel_x = 0
	pixel_y = 3

/obj/effect/container_wall/side/right
	dir = EAST
	pixel_x = -30
	pixel_y = 3
