// Middle
/obj/machinery/door/poddoor/window_blinds
	name = "жалюзи"
	desc = "Довольно крепкие, металлические, автоматизированные жалюзи, устанавливаемые на окнах."
	icon = 'modular_ss220/objects/icons/goonstation/blinds.dmi'
	icon_state = "middle_closed"
	layer = NOT_HIGH_OBJ_LAYER
	closingLayer = NOT_HIGH_OBJ_LAYER
	heat_proof = FALSE
	max_integrity = 100
	armor = list(MELEE = 25, BULLET = 10, LASER = 10, ENERGY = 0, BOMB = 0, RAD = 0, FIRE = 50, ACID = 70)
	resistance_flags = NONE
	damage_deflection = 10
	dir = SOUTH

	var/door_open_sound = 'modular_ss220/aesthetics/shutters/sound/shutters_open.ogg'
	var/door_close_sound = 'modular_ss220/aesthetics/shutters/sound/shutters_close.ogg'

// Middle
/obj/machinery/door/poddoor/window_blinds/middle
	icon_state = "middle"

/obj/machinery/door/poddoor/window_blinds/middle/preopen
	density = FALSE
	opacity = FALSE

// Left
/obj/machinery/door/poddoor/window_blinds/left
	icon_state = "left"

/obj/machinery/door/poddoor/window_blinds/left/preopen
	density = FALSE
	opacity = FALSE

// Right
/obj/machinery/door/poddoor/window_blinds/right
	icon_state = "right"

/obj/machinery/door/poddoor/window_blinds/right/preopen
	density = FALSE
	opacity = FALSE

// Solo
/obj/machinery/door/poddoor/window_blinds/solo
	icon_state = "solo"

/obj/machinery/door/poddoor/window_blinds/solo/preopen
	density = FALSE
	opacity = FALSE

// Procs
/obj/machinery/door/poddoor/window_blinds/update_icon_state()
	if(density)
		icon_state = "[initial(icon_state)]_closed"
	else
		icon_state = "[initial(icon_state)]"

// TODO: flick opening and closing animations
/obj/machinery/door/poddoor/window_blinds/do_animate(animation)
	switch(animation)
		if("opening")
			playsound(src, door_open_sound, 30, 1)
		if("closing")
			playsound(src, door_close_sound, 30, 1)
